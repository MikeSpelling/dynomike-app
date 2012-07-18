class CreatePasswords < ActiveRecord::Migration
  def change
    create_table :passwords do |t|
      t.string :text

      t.timestamps
    end
  end
end
