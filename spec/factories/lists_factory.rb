FactoryGirl.define do
  factory :list do
    user
    name  'My great list of exoplanets'
    description 'Only the finest exoplanet candidates'

    properties {}

    created_at  { Time.now }
    updated_at  { Time.now }

    sha SecureRandom.hex

    factory :public_list do
      visible true
    end

    factory :private_list do
      visible false
    end
  end
end
