require "rails_helper"

RSpec.describe "mutation delete_survey", type: :request do

  

  it "deletes a survey" do
    query = <<~GQL
      mutation {
        deleteSurvey(input: {
          id: 11
        }) {
          survey {
            id
            title
          }
          errors
        }
      }
    GQL

    result = SurveyGraphAppSchema.execute(query)
    
    expect(result["data"]["deleteSurvey"]["errors"]).to be_empty
  end

  it "returns an error when the survey doesn't exist" do
    query = <<~GQL
      mutation {
        deleteSurvey(input: {
          id: 10000 
        }) {
          survey {
            id
            title
          }
          errors
        }
      }
    GQL

    result = SurveyGraphAppSchema.execute(query)
    
    expect(result["data"]["deleteSurvey"]["survey"]).to be_nil
    expect(result["data"]["deleteSurvey"]["errors"]).to include("Survey not found")
  end
end
