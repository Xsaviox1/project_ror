module Mutations
    class Mutations::DeleteSurvey < Mutations::BaseMutation

    argument :id, ID, required: true
    argument :title, String, required: false

    field :survey, Types::SurveyType, null: true
    field :errors, [String], null: false

        def resolve(id:)
            survey = Survey.find_by(id: id)
        
          if survey

            if survey.destroy
                {survey: survey, errors: []}
            else
                {survey: nil, errors: survey.errors.full_messages}
            end
        else
            {survey: nil, errors: ["Survey not found"]}
          end
      end
    end
end