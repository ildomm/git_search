require 'rails_helper'

RSpec.describe GitController, type: :controller do
  describe "GET index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "POST search" do
    it "renders the search template" do
      post :search, format: :js
      expect(response).to render_template("search")
    end

    it "locate results" do

      body = open(Rails.root + "spec/fixtures/git_1.html") {|io| io.read}

      stub_request(:get, "https://github.com/search?q=").
          with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(status: 200, body: body, headers: {})

      post :search, format: :js
      expect(assigns(:counter)).to eq("1,981 repository results")
    end
  end

end
