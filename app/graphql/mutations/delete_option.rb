module Mutations
  class DeleteOption < Mutations::BaseMutation
    argument :id, ID, required: true

    field :option, Types::OptionType, null: true
    field :errors, [String], null: false

    def resolve(id:)
      option = Option.find_by(id: id)

      if option
        # Adjust the amt_options of the related question
        question = option.question

        if question.amt_options > 0
          question.update(amt_options: question.amt_options - 1)
        end

        # Attempt to destroy the option
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