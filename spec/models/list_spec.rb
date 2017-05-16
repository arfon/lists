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
end
