class CreateEnigmaMachines < ActiveRecord::Migration
  def change
    create_table :enigma_machines do |t|

      t.timestamps
    end
  end
end
