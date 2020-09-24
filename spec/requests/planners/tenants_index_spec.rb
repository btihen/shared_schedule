require 'rails_helper'

RSpec.describe "Planners PublicTenantsIndex", type: :request do

  let(:tenant_public)     { FactoryBot.create :tenant, is_publicly_viewable: true }
  let(:tenant_private)    { FactoryBot.create :tenant, is_publicly_viewable: false }

  describe "GET /planners/tenants" do
    # setup filter when lots (later)
    it "check only publicly viewable tenants are listed when not logged in" do
      expect(tenant_public).to      be
      expect(tenant_private).to     be

      get planners_tenants_path

      expect(response).to           have_http_status(200)

      expect(response.body).to      match tenant_public.tenant_name
      expect(response.body).not_to  match tenant_private.tenant_name
    end
  end

  describe "GET /planners" do
    # setup filter when lots (later)
    it "check only publicly viewable tenants are listed when not logged in" do
      expect(tenant_public).to      be
      expect(tenant_private).to     be

      get planners_root_path

      expect(response).to           have_http_status(200)

      expect(response.body).to      match tenant_public.tenant_name
      expect(response.body).not_to  match tenant_private.tenant_name
    end
  end

end
