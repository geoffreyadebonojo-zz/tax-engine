class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :uuid
      t.text :tax_brackets

      t.timestamps
    end
  end
end
