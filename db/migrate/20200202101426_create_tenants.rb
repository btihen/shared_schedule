class CreateTenants < ActiveRecord::Migration[6.0]
  def change
    create_table :tenants do |t|
      t.string :tenant_name,          null: false
      t.string :tenant_tagline
      t.string :tenant_site_url
      t.string :tenant_logo_url
      t.text   :tenant_description
      t.boolean :is_demo_tenant,       null: false, default: false
      t.boolean :is_publicly_viewable, null: false, default: false

      t.timestamps
    end

    add_index :tenants,  :tenant_name, unique: true
  end
end
