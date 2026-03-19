class ChangeRunnerToRun < ActiveRecord::Migration[8.1]
  def change
    rename_table :runners, :runs
  end
end
