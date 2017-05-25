FactoryGirl.define do
  factory :thing do
    list
    properties ({
      "orbital_parameters_planet_mass" => {
        "value" => "1.5",
        "origin" => "http://arxiv.org/abs/1402.6534"
      },
      "default_name" => {
        "value" => "Kepler-181 b",
        "origin" => "http://arxiv.org/abs/1402.6534"
      }
    })

    created_at  { Time.now }
    updated_at  { Time.now }

    sha SecureRandom.hex
  end
end
