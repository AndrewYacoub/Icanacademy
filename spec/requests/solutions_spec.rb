require 'rails_helper'

RSpec.describe "Solutions", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/solutions/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/solutions/show"
      expect(response).to have_http_status(:success)
    end
  end

end
