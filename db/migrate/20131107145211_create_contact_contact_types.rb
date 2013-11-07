class CreateContactContactTypes < ActiveRecord::Migration
  def change
    create_table :contact_contact_types do |t|
      t.belongs_to :contact
      t.belongs_to :contact_type
    end
    add_index :contact_contact_types, [:contact_id, :contact_type_id] , :name => 'contact_contact_type_ix'
  end

end
