FactoryGirl.define do
  factory :list do
    user
    name  'My great list of exoplanets'
    description 'Only the finest exoplanet candidates'

    properties {[
      {
        "key" => "default_name",
        "name" => "Name",
        "units" => "",
        "kind" => "String",
        "required" => true,
        "group" => "Default"
      },
      {
        "key" => "orbital_parameters_planet_mass",
        "name" => "Planet Mass",
        "units" => "mjupiter",
        "kind" => "Decimal",
        "required" => false,
        "group" => "Orbital Parameters"
      },
      {
        "key" => "orbital_parameters_orbital_period",
        "name" => "Orbital Period",
        "units" => "day",
        "kind" => "Decimal",
        "required" => false,
        "group" => "Orbital Parameters"
      },
      {
        "key" => "orbital_parameters_semi_major_axis",
        "name" => "Semi-Major Axis",
        "units" => "au",
        "kind" => "Decimal",
        "required" => false,
        "group" => "Orbital Parameters"
      },
      {
        "key" => "stellar_properties_star_name",
        "name" => "Star Name",
        "units" => "",
        "kind" => "String",
        "required" => true,
        "group" => "Stellar Properties"
      }
    ]}

    created_at  { Time.now }
    updated_at  { Time.now }

    sha SecureRandom.hex

    factory :public_list do
      visible true
    end

    factory :private_list do
      visible false
    end

    factory :list_without_properties do
      properties {[]}
    end
  end
end
