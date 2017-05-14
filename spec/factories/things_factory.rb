FactoryGirl.define do
  factory :thing do
    list

    created_at  { Time.now }
    updated_at  { Time.now }

    sha SecureRandom.hex
  end
end
