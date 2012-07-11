class CreateRotors < ActiveRecord::Migration
  def change
    create_table :rotors do |t|

      t.timestamps
    end
  end
end
