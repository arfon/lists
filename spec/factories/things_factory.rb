FactoryGirl.define do
  factory :thing do
    list
    properties {[
      {
        "property_key" => "orbital_parameters_planet_mass",
        "property_value" => "1.5",
        "property_origin" => "http://arxiv.org/abs/1402.6534"
      },
      {
        "property_key" => "default_name",
        "property_value" => "Kepler-181 b",
        "property_origin" => "http://arxiv.org/abs/1402.6534"
      }
    ]}

    created_at  { Time.now }
    updated_at  { Time.now }

    sha SecureRandom.hex
  end
end
