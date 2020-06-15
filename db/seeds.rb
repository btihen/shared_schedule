require './db/seed_demo_group.rb'
require './db/seed_extra_tenants.rb'

# figure out login for site-admin
# admin  = FactoryBot.create :user, tenant: tenant, user_role: "admin", email: "admin@example.ch",   password: "Let-M3-In!", password_confirmation:  "Let-M3-In!"
# users << admin

# Protect against destroying Production
error_msg = "Database Seed not allowed in production"
raise StandardError, error_msg      if Rails.env.production?
raise StandardError, error_msg  unless Rails.env.development? || Rails.env.test?

# Delete Everything - delete all tenants and associated records
Tenant.destroy_all

# create demo group - for guests to try
# SeedDemoGroup.create

if File.exists? Rails.root.join('db', 'seed_private_tenant.rb')
  require './db/seed_private_tenant.rb'
  SeedPrivateTenant.create
end

SeedExtraTenants.create
