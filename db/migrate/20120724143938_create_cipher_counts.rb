class CreateCipherCounts < ActiveRecord::Migration
  def change
    create_table :cipher_counts do |t|
      t.integer :total

      t.timestamps
    end
  end
end
