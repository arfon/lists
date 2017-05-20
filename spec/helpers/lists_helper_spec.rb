require 'rails_helper'

RSpec.describe ListsHelper, type: :helper do
  describe "hidden" do
    it "knows what lable to return for hidden lists" do
      list = create(:list, :visible => false)
      assign(:list, list)
      expect(helper.private_tag(list)).to eq(" <mark><em>Private</em></mark>")
    end
  end

  describe "not hidden" do
    it "knows what lable to return for hidden lists" do
      list = create(:list, :visible => true)
      assign(:list, list)
      expect(helper.private_tag(list)).to eq(nil)
    end
  end

  describe "property_units" do
    it "knows how to render the units for the property" do
      list = create(:list_without_properties)
      new_property = {
        "name" => "Semi-Major Axis",
        "units" => "foooo",
        "kind" => "Decimal",
        "required" => false,
        "group" => "Orbital Parameters"
      }

      list.add_property!(new_property)
      list.save
      assign(:list, list)

      expect(helper.property_units(list.properties.first)).to eq("<span class='units'> (foooo)</span>")
    end
  end
end
