module Mutations
  class EditOption < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :content, String, required: false

    field :option, Types::OptionType, null: false
    field :errors, [String], null: false

    def resolve(id:, content: nil)
      option = Option.find(id) # Corrigir para buscar uma Option, não uma Question

      if option.update(content: content)
        { option: option, errors: [] }
      else
        { option: nil, errors: option.errors.full_messages }
      end
    rescue ActiveRecord::RecordNotFound
      { option: nil, errors: ["Option not found"] }
    end
  end
end
