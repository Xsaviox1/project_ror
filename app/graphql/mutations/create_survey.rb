module Mutations
  class Mutations::CreateSurvey < Mutations::BaseMutation

    argument :name, String, required: true
    argument :title, String, required: true
    argument :amt_questions, Integer, required: true
    argument :contents, [String], required: true  
    argument :question_types, [String], required: true  
    argument :options, [[String]], required: false
    argument :amt_options, [Integer], required: false

    field :user, Types::UserType, null: false
    field :survey, Types::SurveyType, null: false
    field :questions, [Types::QuestionType], null: false  
    field :errors, [String], null: false

    def resolve(name:, title:, amt_questions:, contents:, question_types:, options: nil, amt_options: nil)
      
      ActiveRecord::Base.transaction do
        user = User.find_by!(name: name)

        survey = user.surveys.create!(title: title, amt_questions: amt_questions)

        created_questions = []
        contents.each_with_index do |content, index|
          question_type = question_types[index]

          case question_type
          when 'multiple'
            raise GraphQL::ExecutionError, "Máximo de 10 perguntas por pesquisa." if created_questions.size >= 10

            question_options = options[index] || []
            if question_options.uniq.size > 5
              raise GraphQL::ExecutionError, "Máximo de 5 opções por pergunta."
            end

            question = survey.questions.create!(
              content: content, 
              question_type: question_type, 
              amt_options: question_options.size
            )

            question_options.each do |option_content|
              question.options.create!(content: option_content)
            end

          when 'unique'
            question_options = options[index] || []
            if question_options.uniq.size > 5
              raise GraphQL::ExecutionError, "Máximo de 5 opções por pergunta."
            end

            question = survey.questions.create!(
              content: content, 
              question_type: question_type, 
              amt_options: question_options.size
            )

            question_options.each do |option_content|
              question.options.create!(content: option_content)
            end

          when 'short'
            if content.length > 100
              raise GraphQL::ExecutionError, "Pergunta do tipo 'short' não pode exceder 100 caracteres."
            end

            question = survey.questions.create!(
              content: content, 
              question_type: question_type
            )

          when 'long'
            question = survey.questions.create!(
              content: content, 
              question_type: question_type
            )

          else
            raise GraphQL::ExecutionError, "Tipo de pergunta inválido: #{question_type}."
          end

          created_questions << question
        end

        { user: user, survey: survey, questions: created_questions, errors: [] }
      end
    rescue ActiveRecord::RecordInvalid => e
      { user: nil, survey: nil, questions: [], errors: [e.message] }
    end
  end
end
