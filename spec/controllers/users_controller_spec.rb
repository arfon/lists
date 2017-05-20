require 'rails_helper'

describe UsersController, type: :controller do
  render_views

  describe "GET #show with JSON logged out" do
    it "user with a single visible list responds with success" do
      user = create(:user)
      list = create(:list, :visible => true, :user => user)

      get :show, :params => { :id => user.to_param }, :format => :json
      expect(response).to be_success
      assert_equal hash_from_json(response.body)["data"]["id"], user.sha
      assert !hash_from_json(response.body)["data"]["attributes"]["lists"].empty?
    end
  end

  describe "GET #show with JSON logged out" do
    it "user with a single hidden list responds with success and doesn't render hidden lists" do
      user = create(:user)
      list = create(:list, :visible => false, :user => user)

      get :show, :params => { :id => user.to_param }, :format => :json
      expect(response).to be_success
      assert_equal hash_from_json(response.body)["data"]["id"], user.sha
      assert hash_from_json(response.body)["data"]["attributes"]["lists"].empty?
    end
  end
end
