class AddContractValueToContracts < ActiveRecord::Migration[6.1]
  def change
    add_column :contracts, :contract_value, :decimal, precision: 15, scale: 2
  end
end
