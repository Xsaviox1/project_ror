class RemoveTituloFromOptions < ActiveRecord::Migration[7.2]
  def change
    remove_column :options, :titulo, :string
  end
end
