require "rails_helper"

RSpec.describe "routes for Lists", :type => :routing do
  # API
  it "routes /api/v1/lists to the Lists controller" do
    expect(get("/api/v1/lists")).
      to route_to(:controller => "lists", :action => "index")
  end

  it "routes /api/v1/lists/:sha to the Lists controller" do
    list = create(:list)
    expect(get("/api/v1/lists/#{list.to_param}")).
      to route_to(:controller => "lists", :action => "show", :id => "#{list.to_param}")
  end

  # HTML
  it "routes /lists to the Lists controller" do
    expect(get("/lists")).
      to route_to("lists#index")
  end

  it "routes /lists/:sha to the Lists controller" do
    list = create(:list)
    expect(get("/lists/#{list.to_param}")).
      to route_to(:controller => "lists", :action => "show", :id => "#{list.to_param}")
  end
end
