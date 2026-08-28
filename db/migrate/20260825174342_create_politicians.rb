class CreatePoliticians < ActiveRecord::Migration[8.1]
  def change
    create_table :politicians do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :runner, default: false

      t.timestamps
    end
  end
end
