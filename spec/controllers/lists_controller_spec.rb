require 'rails_helper'

describe ListsController, :type => :controller do
  render_views

  describe "GET #index with JSON" do
    it "should respond with a JSON array" do
      list = create(:list, :visible => true)
      get :index, :format => :json

      expect(response).to be_success
      expect(response.status).to eq(200)
      assert_equal hash_from_json(response.body)["data"].first["id"], list.sha
    end
  end

  describe "GET #index with JSON" do
    it "should only return visible things" do
      3.times do
        create(:list, :visible => false)
      end

      4.times do
        create(:list, :visible => true)
      end

      get :index, :format => :json

      expect(response).to be_success
      expect(response.status).to eq(200)
      expect(hash_from_json(response.body)["data"].size).to eq(4)
    end
  end

  describe "GET #show with JSON" do
    it "responds with success" do
      list = create(:list, :visible => true)
      create(:thing, :list => list)

      get :show, :params => { :id => list.to_param }, :format => :json
      expect(response).to be_success
    end
  end
end
