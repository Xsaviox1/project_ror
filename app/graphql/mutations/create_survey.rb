module Mutations
    class Mutations::CreateSurvey < Mutations::BaseMutation
  
      argument :name, String, required: true
      argument :title, String, required: true
      argument :amt_questions, Integer, required: true
      argument :contents, [String], required: true  
      argument :question_types, [String], required: true  
  
      field :user, Types::UserType, null: false
      field :survey, Types::SurveyType, null: false
      field :questions, [Types::QuestionType], null: false  
      field :errors, [String], null: false
  
      def resolve(name:, title:, amt_questions:, contents:, question_types:)
        ActiveRecord::Base.transaction do
          user = User.find_by!(name: name)
  
          survey = user.surveys.create!(title: title, amt_questions: amt_questions)
  
          created_questions = []
          contents.each_with_index do |content, index|
            question_type = question_types[index]
            question = survey.questions.create!(content: content, question_type: question_type)
            created_questions << question
          end
  
          
          { user: user, survey: survey, questions: created_questions, errors: [] }
        end
      rescue ActiveRecord::RecordInvalid => e
        { user: nil, survey: nil, questions: [], errors: [e.message] }
      end
    end
  end
  