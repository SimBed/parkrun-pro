class CreateParkruns < ActiveRecord::Migration[8.1]
  def change
    create_table :parkruns do |t|
      t.string :name, null: false
      t.string :code_name, null: false
      t.boolean :verified, default: false

      t.timestamps
    end
    add_index :parkruns, :name
  end
end
