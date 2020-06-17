json.extract! tenant, :id, :tenant_name, :created_at, :updated_at
json.url tenant_url(tenant, format: :json)
