module Mutations
    class CreateUser < Mutations::BaseMutation
  
      argument :name, String, required: true
      argument :password, String, required: true
      argument :role, String, required: true
  
      field :user, Types::UserType, null: false
      field :errors, [String], null: false
  
      def resolve(name:, password:, role:)
        user = User.new(name: name, password: password, role: role)
        
        if user.save
          { user: user, errors: [] }
        else
          if user.errors.details[:name].any? { |error| error[:error] == :taken }
            { user: nil, errors: ["O nome de usuário '#{name}' já existe."] }
          else
            { user: nil, errors: user.errors.full_messages }
          end
        end
      end
    end
  end
  