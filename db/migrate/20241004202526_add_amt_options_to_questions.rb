class AddAmtOptionsToQuestions < ActiveRecord::Migration[7.2]
  def change
    add_column :questions, :amt_options, :string
  end
end
