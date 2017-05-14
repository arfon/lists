require 'rails_helper'

describe Thing do
  it { should belong_to(:list) }

  it "should initialize properly" do
    thing = create(:thing)

    assert !thing.sha.nil?
    expect(thing.sha.length).to eq(32)
    expect(thing.property_keys).to be_empty
    expect(thing.property_values).to be_empty
  end

  it "should know how to parameterize itself properly" do
    thing = create(:thing)

    expect(thing.sha).to eq(thing.to_param)
  end

  it "should know what the available properties are" do
    list = create(:list_without_properties)
    property = {
      "name" => "Semi-Major Axis",
      "units" => "au",
      "kind" => "Decimal",
      "required" => false,
      "group" => "Orbital Parameters"
    }
    list.add_property!(property)

    thing = create(:thing, :list => list)
    expect(thing.available_property_keys.length).to eq(1)
    expect(thing.available_property_keys.first).to eq("orbital_parameters_semi_major_axis")
    expect(thing.available_properties.first['name']).to eq("Semi-Major Axis")
  end
end
