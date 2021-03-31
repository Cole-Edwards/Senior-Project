class CreateToken < ActiveRecord::Migration[5.1]
  def change
    create_table :tokens do |t|
      t.string :owner
      t.string :service
      t.string :token_type
      t.string :data
      t.timestamps
    end
    add_index :tokens, :owner  
    add_index :tokens, :service
  end
end
