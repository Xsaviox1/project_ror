module Mutations
    class Mutations::EditSurvey < Mutations::BaseMutation
    
      argument :id, ID, required: true
      argument :title, String, required: false
      argument :status, String, required: false
  
      field :survey, Types::SurveyType, null: true
      field :errors, [String], null: false
  
      def resolve(id:, title: nil, status: nil)
        
        survey = Survey.find(id)
  
        if survey.update(title: title, status: status)
          {
            survey: survey,
            errors: []
          }
        else
          {
            survey: nil,
            errors: survey.errors.full_messages
          }
        end
      rescue ActiveRecord::RecordNotFound => e
        {
          survey: nil,
          errors: ["Survey not found: #{e.message}"]
        }
      end
    end
  end
  