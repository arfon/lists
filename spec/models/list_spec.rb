require 'rails_helper'

describe List do
  it { should belong_to(:user) }
  it { should have_many(:things) }

  it "should initialize properly" do
    list = create(:list)

    assert !list.sha.nil?
    expect(list.sha.length).to eq(32)
    assert !list.visible?
  end

  it "should know how to parameterize itself properly" do
    list = create(:list)

    expect(list.sha).to eq(list.to_param)
  end

  # Scopes

  it "should know about public and private lists" do

    3.times do
      create(:public_list)
    end

    5.times do
      create(:private_list)
    end

    10.times do
      create(:list)
    end

    # Basic scopes
    expect(List.all.count).to eq(18)
    expect(List.visible.count).to eq(3)
    expect(List.hidden.count).to eq(15)
  end

  it "should know what Lists are visible to particular users" do
    owner = create(:user)
    user = create(:user)

    3.times do
      create(:public_list)
    end

    2.times do
      create(:private_list, :user => owner)
    end

    expect(List.all.count).to eq(5)
    expect(List.visible_to_user(owner).count).to eq(5)
    expect(List.visible_to_user(user).count).to eq(3)
  end

  # Properties

  it "should know about it's properties" do
    list = create(:list)

    expect(list.properties.length).to eq(5)
    expect(list.property_groups.length).to eq(3)
    expect(list.property_groups).to contain_exactly("Default", "Orbital Parameters", "Stellar Properties")
  end

  # Property units

  it "should know about the units of properties" do
    list = create(:list)

    expect(list.property_for('default_name')).to eq({"key"=>"default_name", "name"=>"Name", "units"=>"", "kind"=>"String", "required"=>true, "group"=>"Default"})
    expect(list.property_units_for('orbital_parameters_planet_mass')).to eq('mjupiter')
    expect(list.property_units_for('default_name')).to eq('')
    expect(list.property_units_for('foo')).to eq(nil)
  end
  
  it "should know how to create property keys before saving its properties" do
    list = create(:list_without_properties)
    new_property = {
      "name" => "Semi-Major Axis",
      "units" => "au",
      "kind" => "Decimal",
      "required" => false,
      "group" => "Orbital Parameters"
    }

    list.add_property!(new_property)
    list.save

    expect(list.reload.properties.length).to eq(1)
    expect(list.reload.properties.first['key']).to eq("orbital_parameters_semi_major_axis")
  end

  it "should not override a property key if the user has already set it" do
    list = create(:list_without_properties)
    new_property = {
      "name" => "Semi-Major Axis",
      "units" => "au",
      "kind" => "Decimal",
      "required" => false,
      "group" => "Orbital Parameters",
      "key" => "foo_bar_baz"
    }

    list.add_property!(new_property)
    list.save

    expect(list.reload.properties.length).to eq(1)
    expect(list.reload.properties.first['key']).to eq("foo_bar_baz")
  end

  it "should validated properties before adding them" do
    list = create(:list_without_properties)
    valid_property = {
      "name" => "Semi-Major Axis",
      "units" => "au",
      "kind" => "Decimal",
      "required" => false,
      "group" => "Orbital Parameters"
    }

    # Missing a 'name' field
    invalid_property = {
      "units" => "",
      "kind" => "String",
      "required" => true,
      "group" => "Stellar Properties"
    }

    list.add_property!(valid_property)
    list.add_property!(invalid_property)

    expect(list.reload.properties.length).to eq(1)
    expect(list.reload.properties.first['key']).to eq("orbital_parameters_semi_major_axis")
  end

  it "should know how to filter it's Things based on passed key:value pairs with ranges" do
    list = create(:list_without_properties)
    property = {
      "name" => "Semi-Major Axis",
      "units" => "au",
      "kind" => "Decimal",
      "required" => false,
      "group" => "Orbital Parameters"
    }

    list.add_property!(property)
    list.save

    thing_1_properties = {
      "orbital_parameters_semi_major_axis" => {
        "value" => "1.0",
        "origin" => "http://arxiv.org/abs/1402.6534"
      }
    }

    thing_2_properties = {
      "orbital_parameters_semi_major_axis" => {
        "value" => "0.9",
        "origin" => "http://arxiv.org/abs/1402.6534"
      }
    }

    thing_1 = create(:thing, :properties => thing_1_properties, :list => list)
    thing_2 = create(:thing, :properties => thing_2_properties, :list => list)

    expect(list.filter_things_with({'orbital_parameters_semi_major_axis' => '1.0'})).to include(thing_1)
    expect(list.filter_things_with({'orbital_parameters_semi_major_axis' => '1.0'})).not_to include(thing_2)
    expect(list.filter_things_with({'orbital_parameters_semi_major_axis' => 'gte0.9'})).to contain_exactly(thing_1, thing_2)
    expect(list.filter_things_with({'orbital_parameters_semi_major_axis' => 'lte0.8'})).to be_empty
  end

  it "should know how to filter it's Things based on passed key:value pairs with mixed ranges and exact operators" do
    list = create(:list_without_properties)
    property_1 = {
      "name" => "Semi-Major Axis",
      "units" => "au",
      "kind" => "Decimal",
      "required" => false,
      "group" => "Orbital Parameters",
      "key" => "orbital_parameters_semi_major_axis"
    }

    property_2 = {
      "name" => "Planet Name",
      "units" => "",
      "kind" => "String",
      "required" => true,
      "group" => "Default",
      "key" => "default_planet_name"
    }

    property_3 = {
      "name" => "Planet Mass",
      "units" => "mJupiter",
      "kind" => "Decimal",
      "required" => true,
      "group" => "Default",
      "key" => "default_planet_mass"
    }

    list.add_property!(property_1)
    list.save

    list.add_property!(property_2)
    list.save

    list.add_property!(property_3)
    list.save

    thing_1_properties = {
      "orbital_parameters_semi_major_axis" => {
        "value" => "1.0",
        "origin" => "http://arxiv.org/abs/1402.6534"
      },
      "default_planet_name" => {
        "value" => "Kepler-181 b",
        "origin" => "http://arxiv.org/abs/1402.6534"
      },
      "default_planet_mass" => {
        "value" => "5.6",
        "origin" => "http://arxiv.org/abs/1402.6534"
      }
    }

    thing_2_properties = {
      "orbital_parameters_semi_major_axis" => {
        "value" => "1.9",
        "origin" => "http://arxiv.org/abs/1402.6534"
      },
      "default_planet_name" => {
        "value" => "Kepler-181 c",
        "origin" => "http://arxiv.org/abs/1402.6534"
      },
      "default_planet_mass" => {
        "value" => "1.6",
        "origin" => "http://arxiv.org/abs/1402.6534"
      }
    }

    thing_1 = create(:thing, :properties => thing_1_properties, :list => list)
    thing_2 = create(:thing, :properties => thing_2_properties, :list => list)

    expect(list.filter_things_with({'orbital_parameters_semi_major_axis' => '1.0'})).to include(thing_1)
    expect(list.filter_things_with({'orbital_parameters_semi_major_axis' => '1.9', 'default_planet_name' => 'Kepler-181 c'})).to include(thing_2)
    expect(list.filter_things_with({'orbital_parameters_semi_major_axis' => 'lte1.9', 'default_planet_name' => 'Kepler-181 c', 'default_planet_mass' => 'gte1.5'})).to include(thing_2)
    expect(list.filter_things_with({'orbital_parameters_semi_major_axis' => '1.9', 'default_planet_name' => 'Kepler-181 c', 'default_planet_mass' => 'lte1.5'})).to be_empty
  end
end
