require 'rails_helper'

RSpec.describe GitController, type: :controller do
  describe "GET index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET search" do
    it "renders the search template" do
      post :search, :format => :js
      expect(response).to render_template("search")
    end
  end

end
