class AddSalesforceidToLead < ActiveRecord::Migration
  def change
    add_column :leads, :salesforceid, :string
  end
end
