class CreateCredits < ActiveRecord::Migration
  
  def self.up
    create_table :credits do |t|
      t.string  :name
      t.decimal :amount, :precision => 8, :scale => 2
      t.integer :goal_id

      t.timestamps
    end
  end

  def self.down
    drop_table :credits
  end
end
