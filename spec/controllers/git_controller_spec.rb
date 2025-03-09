# spec/controllers/git_controller_spec.rb
require 'rails_helper'

RSpec.describe GitController, type: :controller do
  describe "GET index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "POST search" do
    let(:fixture_body) { File.read(Rails.root.join("spec/fixtures/git_1.html")) }

    it "renders the search template with valid input" do
      stub_request(:get, "https://github.com/search?q=test").
        with(headers: { 'Accept' => '*/*', 'User-Agent' => 'GitSearch/1.0 (lala@example.com)' }).
        to_return(status: 200, body: fixture_body, headers: {})

      post :search, params: { term: "test" }, format: :js
      expect(response).to render_template("search")
      expect(response).to have_http_status(:ok)
    end

    it "locates results with valid input" do
      stub_request(:get, "https://github.com/search?q=test").
        with(headers: { 'Accept' => '*/*', 'User-Agent' => 'GitSearch/1.0 (lala@example.com)' }).
        to_return(status: 200, body: fixture_body, headers: {})

      post :search, params: { term: "test" }, format: :js
      expect(assigns(:counter)).to eq("1,981 repository results")
    end

    it "handles missing search term" do
      post :search, params: { term: "" }, format: :js
      expect(assigns(:counter)).to eq("Search term is required")
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end