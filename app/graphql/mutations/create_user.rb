module Mutations
    class Mutations::CreateUser < Mutations::BaseMutation

    argument :name, String, required: true
    argument :password, String, required: true
    argument :role, String, required: true

    field :user, Types::UserType, null: false
    field :errors, [String], null: false

        def resolve(name:, password:, role:)
            user = User.new(name:, password:, role:)
        
          if user.save
           {user: user, errors: {}}
          else 
             {user: nil, errors: user.errors.full_messages}
          end
      end
    end
end