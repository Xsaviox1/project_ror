require "rails_helper"

RSpec.describe "mutation login", type: :request do
  it "authenticates the account and returns a token" do
    query = <<~GQL
      mutation {
        login(input: {
          name: "usuario",
          password: "password123",
          role: "admin"
        }) {
          user {
            id
            name
            role
          }
          token
          errors
        }
      }
    GQL

    result = CoinfusionSchema.execute(query)
    expect(result.dig("data", "login", "token")).not_to be_nil
  end

  it "returns error when authentication fails" do
    query = <<~GQL
      mutation {
        login(input: {
          name: "Exemplo",
          password: "senha",
          role: "admin"
        }) {
          token
        }
      }
    GQL

    result = CoinfusionSchema.execute(query)
    expect(result["data"]).to be_nil
    expect(result["errors"].first["message"]).to eq("Invalid email or password")
  end
end
