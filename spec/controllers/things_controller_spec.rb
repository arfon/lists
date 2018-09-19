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
      assert_equal hash_from_json(response.body)["data"]["attributes"]["properties"]["orbital-parameters-planet-mass"]["units"], "mjupiter"
    end
  end

  # Private lists
  describe "GET #index with JSON" do
    it "should respond with 403 (forbidden) for public users" do
      list = create(:list, :visible => false)
      2.times do
        create(:thing, :list => list)
      end

      get :index, :params => { :list_id => list.to_param }, :format => :json

      expect(response.status).to eq(403)
    end
  end

  # Filtering Things
  describe "GET #filter" do
    it "should know how to sanitize filter params" do
      list = create(:list, :visible => true)

      thing_properties = {
        "default_name" => {
          "value" => "Kepler-181 b",
          "origin" => "http://arxiv.org/abs/1402.6534"
        },
        "stellar_properties_star_name" => {
          "value" => "Kepler-181",
          "origin" => "http://arxiv.org/abs/1402.6534"
        },
        "orbital_parameters_planet_mass" => {
          "value" => "1.9",
          "origin" => "http://arxiv.org/abs/1402.6534"
        }
      }

      thing = create(:thing, :list => list, :properties => thing_properties)

      get :filter, :params => { :list_id => list.to_param, :default_name => "Kepler-181 b", :foo => "bar" }, :format => :json
      expect(response.status).to eq(200)
      expect(@controller.send(:sanitize_query_fields)).to eq({"default_name" => "Kepler-181 b"})
      assert_equal hash_from_json(response.body)["data"].first["id"], list.things.first.sha
      assert_equal hash_from_json(response.body)["data"].first["attributes"]["properties"]["orbital-parameters-planet-mass"]["units"], "mjupiter"
    end

    it "should know how to filter with ranges" do
      list = create(:list, :visible => true)

      thing_properties = {
        "default_name" => {
          "value" => "Kepler-181 b",
          "origin" => "http://arxiv.org/abs/1402.6534"
        },
        "stellar_properties_star_name" => {
          "value" => "Kepler-181",
          "origin" => "http://arxiv.org/abs/1402.6534"
        },
        "orbital_parameters_planet_mass" => {
          "value" => "1.9",
          "origin" => "http://arxiv.org/abs/1402.6534"
        }
      }

      thing = create(:thing, :list => list, :properties => thing_properties)

      get :filter, :params => { :list_id => list.to_param, :orbital_parameters_planet_mass => "gte1.8", :default_name => "Kepler-181 b" }, :format => :json
      expect(response.status).to eq(200)
      assert_equal hash_from_json(response.body)["data"].first["id"], list.things.first.sha
    end
  end
end
