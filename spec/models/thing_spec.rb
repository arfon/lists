require 'rails_helper'

describe Thing do
  it { should belong_to(:list) }

  it "should initialize properly" do
    thing = create(:thing)

    assert !thing.sha.nil?
    expect(thing.sha.length).to eq(32)
  end

  it "should know how to parameterize itself properly" do
    thing = create(:thing)

    expect(thing.sha).to eq(thing.to_param)
  end
end
