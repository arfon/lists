FactoryGirl.define do
  factory :thing do
    list
    properties {{
      "orbital_parameters_planet_mass" => "1.5",
      "default_name" => "Kepler-181 b"}
    }
    created_at  { Time.now }
    updated_at  { Time.now }

    sha SecureRandom.hex
  end
end
