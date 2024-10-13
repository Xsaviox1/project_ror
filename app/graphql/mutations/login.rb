module Mutations
class Login < BaseMutation

    argument :name, String, required: true
    argument :password, String, required: true
    
    field :token, String, null: false
    
        def resolve(name:, password:)
            user = User.find_by(name: name)

            if user&.authenticate(password)
                token = JWT.encode({ user_id: user.id}, 'segredo', 'HS256')
                {token: token}
            else
                raise GraphQL::ExecutionError, "Invalid email or password"
            end
        end
end
end