# frozen_string_literal: true

class AddContractValueToTempContracts < ActiveRecord::Migration[6.0]
  def change
    # 如果 temp_contracts 表中已存在 contract_value 字段，则先删除它
    remove_column :temp_contracts, :contract_value, :decimal if column_exists?(:temp_contracts, :contract_value)

    # 重新添加 contract_value 字段，确保精度和缩放参数相同
    add_column :temp_contracts, :contract_value, :decimal, precision: 15, scale: 2
  end
end
