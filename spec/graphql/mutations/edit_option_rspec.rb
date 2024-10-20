require 'rails_helper'

RSpec.describe "mutation edit_option" do

  it "edits the option successfully" do
    query = <<~GQL
    mutation {
      editOption(input: {
        id: 2,           
        content: "Red"
      }) {
        option {
          id
          content
        }
        errors
      }
    }
    GQL

    result = SurveyGraphAppSchema.execute(query)

    expect(result["data"]["editOption"]["errors"]).to be_empty
    expect(result["data"]["editOption"]["option"]["id"]).to eq("2")
    expect(result["data"]["editOption"]["option"]["content"]).to eq("Red")
  end

  it "returns an error for a non-existent option" do
    query = <<~GQL
    mutation {
      editOption(input: {
        id: 2000,           
        content: "Red"
      }) {
        option {
          id
          content
        }
        errors
      }
    }
    GQL

    result = SurveyGraphAppSchema.execute(query)

    expect(result["errors"][0]["message"]).to eq("Cannot return null for non-nullable field EditOptionPayload.option")
    expect(result["data"]["editOption"]).to be_nil
  end
end
