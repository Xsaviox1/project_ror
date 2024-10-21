module Mutations
  class CreateSurvey < BaseMutation
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

    MAX_QUESTIONS = 10
    MAX_OPTIONS = 5

    def resolve(name:, title:, amt_questions:, contents:, question_types:, options: [], amt_options: nil)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "User not authenticated" unless user

      unless user.role == 'admin'
        raise GraphQL::ExecutionError, "Only admins are able to create surveys"
      end

      ActiveRecord::Base.transaction do
        survey = user.surveys.create!(title: title, amt_questions: amt_questions)
        created_questions = []

        contents.each_with_index do |content, index|
          question_type = question_types[index]
          raise GraphQL::ExecutionError, "maximum of #{MAX_QUESTIONS} questions per survey." if created_questions.size >= MAX_QUESTIONS

          question_options = options[index] || []

          if question_type == 'multiple' || question_type == 'unique'
            if question_options.uniq.size > MAX_OPTIONS
              raise GraphQL::ExecutionError, "maximum of #{MAX_OPTIONS} options per question."
            end
          elsif question_type == 'short' || question_type == 'long'
            if question_options.uniq.size > 1
              raise GraphQL::ExecutionError, "Only one option is accept."
            end
          else
            raise GraphQL::ExecutionError, "Question type is invalid: #{question_type}."
          end

          question = survey.questions.create!(content: content, question_type: question_type, amt_options: question_options.size)
          question_options.each { |option_content| question.options.create!(content: option_content) }
          created_questions << question
        end

        { user: user, survey: survey, questions: created_questions, errors: [] }
      end
    rescue ActiveRecord::RecordInvalid => e
      { user: nil, survey: nil, questions: [], errors: [e.message] }
    rescue StandardError => e
      { user: nil, survey: nil, questions: [], errors: [e.message] }
    end
  end
end
