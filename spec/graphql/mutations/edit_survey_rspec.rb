require 'rails_helper'

RSpec.describe "mutation edit_survey" do
    it "edits the survey" do
        query = <<~GQL
        mutation {
        editSurvey(input: {
            id: 2,           
            title: "New Title", 
            status: "inactive"    
        }) {
            survey {
            id
            title
            status
            }
            errors
        }
        }
        GQL

        result = SurveyGraphAppSchema.execute(query)

        expect(result["data"]["editSurvey"]["errors"]).to be_empty
        expect(result["data"]["editSurvey"]["survey"]["id"]).to eq("2")
        expect(result["data"]["editSurvey"]["survey"]["title"]).to eq("New Title")
        expect(result["data"]["editSurvey"]["survey"]["status"]).to eq("inactive")
    end

    it "edits the name of the survey" do
        query = <<~GQL
        mutation {
        editSurvey(input: {
            id: 2,           
            title: "New Title"   
        }) {
            survey {
            id
            title
            status
            }
            errors
        }
        }
        GQL

        result = SurveyGraphAppSchema.execute(query)

        expect(result["data"]["editSurvey"]["errors"]).to be_empty
        expect(result["data"]["editSurvey"]["survey"]["id"]).to eq("2")
        expect(result["data"]["editSurvey"]["survey"]["title"]).to eq("New Title")
    end

    it "edits the status of the survey" do
        query = <<~GQL
        mutation {
        editSurvey(input: {
            id: 2,           
            status: "inactive"    
        }) {
            survey {
            id
            title
            status
            }
            errors
        }
        }
        GQL

        result = SurveyGraphAppSchema.execute(query)

        expect(result["data"]["editSurvey"]["errors"]).to be_empty
        expect(result["data"]["editSurvey"]["survey"]["id"]).to eq("2")
        expect(result["data"]["editSurvey"]["survey"]["status"]).to eq("inactive")
    end

    it "edits the status of the survey" do
        query = <<~GQL
        mutation {
        editSurvey(input: {
            id: 200,           
            status: "inactive"    
        }) {
            survey {
            id
            title
            status
            }
            errors
        }
        }
        GQL

        result = SurveyGraphAppSchema.execute(query)
        
        expect(result["data"]["editSurvey"]["errors"]).to eq(["Survey not found: Couldn't find Survey with 'id'=200"])
    end
end
