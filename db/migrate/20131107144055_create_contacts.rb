class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :user, index: true
      t.references :contact_type, index: true
      t.string :v_address
      t.timestamps
    end
  end
end
