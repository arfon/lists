require 'rails_helper'

describe Thing do
  it { should belong_to(:list) }

  it "should initialize properly" do
    thing = create(:thing)

    assert !thing.sha.nil?
    expect(thing.sha.length).to eq(32)
    expect(thing.available_property_keys.length).to eq(5)
    expect(thing.property_values).to contain_exactly("1.5", "Kepler-181 b")
  end

  it "should know how to parameterize itself properly" do
    thing = create(:thing)

    expect(thing.sha).to eq(thing.to_param)
  end

  it "should be impossible to create a Thing without properties" do
    thing = build(:thing, :properties => {})
    thing.save

    assert !thing.persisted?
    expect(thing.errors.size).to eq(1)
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

    thing_properties = [{
      "property_key" => "orbital_parameters_semi_major_axis",
      "property_value" => "1.0",
      "property_origin" => "http://arxiv.org/abs/1402.6534"
    }]

    thing = create(:thing, :properties => thing_properties, :list => list)

    expect(thing.available_property_keys.length).to eq(1)
    expect(thing.available_property_keys.first).to eq("orbital_parameters_semi_major_axis")
    expect(thing.available_properties.first['name']).to eq("Semi-Major Axis")
    expect(thing.property_values.first).to eq("1.0")
  end

  it "should be impossible to create a Thing with invalid properties" do
    list = create(:list)

    thing_properties = [{
      "foo" => "bar"
    }]

    expect { create(:thing, :properties => thing_properties, :list => list) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
