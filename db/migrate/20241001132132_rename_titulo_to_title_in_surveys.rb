class RenameTituloToTitleInSurveys < ActiveRecord::Migration[7.2]
  def change
    rename_column :surveys, :titulo, :title
  end
end
