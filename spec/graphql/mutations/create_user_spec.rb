require "rails_helper"

RSpec.describe "mutation create_user" do

    before do
      User.create!(name: "Sávio110", password: "password123", role: "admin")
    end

  it "creates the account" do
    query = <<~GQL
    mutation {
  createUser(input: {
    name: "Usuario"
    password: "12345"
    role: "player"
  }) {
    user {
      id
      name
      role
    }
    errors
  }
}
    GQL

    result = SurveyGraphAppSchema.execute(query)  
    expect(result["errors"]).to be_nil
  end

  it "returns error when the user already exists" do
    query = <<~GQL 
    mutation {
        createUser(input: {
          name: "Sávio110"
          password: "password123"
          role: "admin"
        }) {
          user {
            id
            name
            role
          }
          errors
        }
      }
    GQL

    result = SurveyGraphAppSchema.execute(query)
    expect(result["errors"].first["message"]).to eq("The name 'Sávio110' already exists.")
    
  end

  it "returns error when the user already exists" do
    query = <<~GQL 
    mutation {
        createUser(input: {
          name: ""
          password: ""
          role: ""
        }) {
          user {
            id
            name
            role
          }
          errors
        }
      }
    GQL

    result = SurveyGraphAppSchema.execute(query)
    expect(result["errors"].first["message"]).to eq("The sent format is invalid.")
    
  end
end
