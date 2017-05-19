require 'rails_helper'

describe ListsController, :type => :controller do
  render_views

  ## API
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

  ## HTML
  describe "GET #index" do
    it "doesn't show hidden lists" do
      create(:list, :visible => true, :name => "List 1")
      create(:list, :visible => false, :name => "List 2")
      create(:list, :visible => true, :name => "List 3")

      get :index

      expect(response.body).to match /List 1/im
      expect(response.body).to match /List 3/im
      expect(response.body).not_to match /List 2/im
    end
  end
end
