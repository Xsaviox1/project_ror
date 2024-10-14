require "rails_helper"

RSpec.describe "mutation login" do

  before do
    User.create!(name: "Sávio11", password: "password123", role: "admin")
  end

  it "authenticates the account and returns a token" do
    query = <<~GQL
    mutation {
      login(input: {
        name: "Sávio11",
        password: "password123"
      }) {
        token
      }
    }
    GQL

    result = SurveyGraphAppSchema.execute(query)  
    expect(result.dig("data", "login", "token")).not_to be_nil
  end

  it "returns error when authentication fails" do
    query = <<~GQL 
      mutation {
        login(input: {
          name: "Exemplo",
          password: "senha"
        }) {
          token
        }
      }
    GQL

    result = SurveyGraphAppSchema.execute(query)
    expect(result.dig("data", "login")).to be_nil
    expect(result["errors"].first["message"]).to eq("Invalid name or password")
  end
end
