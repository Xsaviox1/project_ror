module Mutations
  class DeleteOption < Mutations::BaseMutation
    argument :id, ID, required: true

    field :option, Types::OptionType, null: true
    field :errors, [String], null: false

    def resolve(id:)
      
      user = context[:current_user]
      raise GraphQL::ExecutionError, "User not authenticated" unless user

      unless user.role == 'admin'
        raise GraphQL::ExecutionError, "Only players are able to answer the questions"
      end

      option = Option.find_by(id: id)

      if option
        
        question = option.question

        if question.amt_options > 0
          question.update(amt_options: question.amt_options - 1)
        end

        
        if option.destroy
          { option: option, errors: [] }
        else
          { option: nil, errors: option.errors.full_messages }
        end
      else
        { option: nil, errors: ["Option not found"] }
      end
    end
  end
end