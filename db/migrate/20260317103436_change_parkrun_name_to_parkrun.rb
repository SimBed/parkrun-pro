class ChangeParkrunNameToParkrun < ActiveRecord::Migration[8.1]
  def change
    rename_column :runs, :parkrun_name, :parkrun
  end
end
