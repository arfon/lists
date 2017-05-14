require 'rails_helper'

describe List do
  it { should belong_to(:user) }

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
end
