class CreateTaxTiers < ActiveRecord::Migration[5.2]
  def change
    create_table :tax_tiers do |t|
      t.integer :lower_limit
      t.integer :upper_limit
      t.integer :tax_percent

      t.timestamps
    end
  end
end
