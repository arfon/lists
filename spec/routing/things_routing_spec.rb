require "rails_helper"

RSpec.describe "routes for Things", :type => :routing do
  # API
  it "routes /api/v1/lists/:sha/things to the Things controller" do
    list = create(:list)
    expect(get("/api/v1/lists/#{list.to_param}/things")).
      to route_to(:controller => "things", :action => "index", :list_id => list.to_param)
  end

  it "routes /api/v1/lists/:sha/things/:sha to the Things controller" do
    thing = create(:thing)
    expect(get("/api/v1/lists/#{thing.list.to_param}/things/#{thing.to_param}")).
      to route_to(:controller => "things", :action => "show", :list_id => thing.list.to_param, :id => thing.to_param)
  end

  # HTML
  # it "routes /lists to the Lists controller" do
  #   expect(get("/lists")).
  #     to route_to("lists#index")
  # end
  #
  # it "routes /lists/:sha to the Lists controller" do
  #   list = create(:list)
  #   expect(get("/lists/#{list.to_param}")).
  #     to route_to(:controller => "lists", :action => "show", :id => "#{list.to_param}")
  # end
end
