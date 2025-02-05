require 'rails_helper'

describe Thing do
  it { should belong_to(:list) }

  it "should initialize properly" do
    thing = create(:thing)

    assert !thing.sha.nil?
    expect(thing.sha.length).to eq(32)
    expect(thing.available_property_keys.length).to eq(5)
    expect(thing.property_values).to contain_exactly("1.5", "Kepler-181 b")
    expect(thing.property_unit_for('orbital_parameters_planet_mass')).to eq('mjupiter')
  end

  it "should know how to parameterize itself properly" do
    thing = create(:thing)

    expect(thing.sha).to eq(thing.to_param)
    expect(thing.property_unit_for('foo')).to eq(nil)
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

    thing_properties = {
      "orbital_parameters_semi_major_axis" => {
        "value" => "1.0",
        "origin" => "http://arxiv.org/abs/1402.6534"
      }
    }

    thing = create(:thing, :properties => thing_properties, :list => list)

    expect(thing.available_property_keys.length).to eq(1)
    expect(thing.available_property_keys.first).to eq("orbital_parameters_semi_major_axis")
    expect(thing.available_properties.first['name']).to eq("Semi-Major Axis")
    expect(thing.property_values.first).to eq("1.0")
    expect(thing.properties['orbital_parameters_semi_major_axis']['origin']).to eq("http://arxiv.org/abs/1402.6534")
    expect(thing.property_value_for("orbital_parameters_semi_major_axis")).to eq("1.0")
    expect(thing.origin_url_for("orbital_parameters_semi_major_axis")).to eq("http://arxiv.org/abs/1402.6534")
  end

  it "should be impossible to create a Thing with invalid properties" do
    list = create(:list)

    thing_properties = {
      "jimmy" => {
        "two" => "shakes"
      }
    }

    expect { create(:thing, :properties => thing_properties, :list => list) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
