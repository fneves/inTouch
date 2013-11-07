class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :user, index: true
      t.string :v_address

      t.timestamps
    end
  end
end
