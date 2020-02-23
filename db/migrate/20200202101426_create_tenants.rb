class CreateTenants < ActiveRecord::Migration[6.0]
  def change
    create_table :tenants do |t|
      t.string :tenant_name
      t.string :tenant_tagline
      t.string :tenant_site_url
      t.string :tenant_logo_url
      t.text   :tenant_description

      t.timestamps

    end
  end
end
