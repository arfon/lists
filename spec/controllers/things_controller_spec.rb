require 'rails_helper'

describe ThingsController, :type => :controller do
  render_views

  describe "GET #index with JSON" do
    it "should respond with a JSON array" do
      list = create(:list, :visible => true)
      2.times do
        create(:thing, :list => list)
      end

      get :index, :params => { :list_id => list.to_param }, :format => :json

      expect(response).to be_success
      expect(response.status).to eq(200)
      assert_equal hash_from_json(response.body)["data"].first["id"], list.things.first.sha
    end
  end

  describe "GET #show with JSON" do
    it "should respond with a single Thing" do
      list = create(:list, :visible => true)
      thing = create(:thing, :list => list)

      get :show, :params => { :list_id => list.to_param, :id => thing.to_param }, :format => :json

      expect(response).to be_success
      expect(response.status).to eq(200)
      assert_equal hash_from_json(response.body)["data"]["id"], thing.sha
    end
  end
end
