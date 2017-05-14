require 'rails_helper'

describe User do
  it { should have_many(:lists) }
  it { should have_many(:public_lists) }
  it { should have_many(:private_lists) }

  it "should initialize properly" do
    user = create(:user)

    assert !user.sha.nil?
    expect(user.sha.length).to eq(32)
    assert !user.admin?
  end

  it "should know how to parameterize itself properly" do
    user = create(:user)

    expect(user.sha).to eq(user.to_param)
  end

  # Scopes

  it "should know about public and private lists" do
    user = create(:user)

    3.times do
      create(:public_list, :user => user)
    end

    5.times do
      create(:private_list, :user => user)
    end

    10.times do
      create(:list)
    end

    expect(user.lists.count).to eq(8)
    expect(user.public_lists.count).to eq(3)
    expect(user.private_lists.count).to eq(5)
  end
end
