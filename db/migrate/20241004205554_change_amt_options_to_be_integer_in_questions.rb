class ChangeAmtOptionsToBeIntegerInQuestions < ActiveRecord::Migration[7.2]
  def change
    change_column :questions, :amt_options, :integer, using: 'amt_options::integer'
  end
end
