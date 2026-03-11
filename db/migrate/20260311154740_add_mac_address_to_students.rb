class AddMacAddressToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :mac_address, :string
  end
end
