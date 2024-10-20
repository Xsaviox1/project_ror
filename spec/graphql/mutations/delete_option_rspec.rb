require 'rails_helper'

RSpec.describe "mutation delete_option", type: :request do
  it "deletes the selected option" do
    query = <<~GQL
      mutation {
        deleteOption(input: {
          id: 2
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
 
    expect(result["data"]["deleteOption"]["errors"]).to be_empty
    expect(result["data"]["deleteOption"]["option"]["id"]).to eq("2")
    expect(result["data"]["deleteOption"]["option"]["content"]).to eq("Azul")
  end

  it "deletes with a wrog id" do
    query = <<~GQL
      mutation {
        deleteOption(input: {
          id: 200000
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
 
    expect(result["data"]["deleteOption"]["errors"]).not_to be_nil
  end
end
