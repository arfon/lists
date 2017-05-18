# Lists

This is Lists<sup>\*</sup>, a really simple service for creating and maintaining lists of astronomical things. It's an experimental service created by the team at MAST.

## Getting started

First visit [`http://list.mast.stsci.edu`](http://list.mast.stsci.edu) to get started - you'll need an ORCID account to sign in.

## About Lists

A `List` belongs to an individual. Lists need _at a minimum_ a name, and a short description. Lists can be public or private.

Each `List` is composed of multiple (currently limited to 10,000) `Things`. Each `Thing` has custom user-defined properties.

### Creating a list

To create a List you first need to create a Git repository with the metadata that defines the list properties and the Things you want to include in your List. An example of a list for exoplanets is here: https://github.com/arfon/exoplanet_list

### List conventions

A List repository should have the following basic structure:

```
list.yaml       <-- A YAML file describing the List (required)
things/         <-- A folder called 'things' with separate files for each Thing (required)
LICENSE         <-- Recommended
README.md       <-- Recommended

```

YAML is a human-readable markup language. You can read more about the YAML syntax here: https://en.wikipedia.org/wiki/YAML

#### A worked example

An example of a list for exoplanets is here: https://github.com/arfon/exoplanet_list.

The `list.yaml` is defined with a `name`, `description` and an array of `properties` that are essentially available fields to describe the associated `Things` with:

So to describe our list of exoplanet candidates we are describing the following five properties:

- `Name` - the exoplanet name
- `Star Name` - the name of the host star
- `Planet Mass` - the mass of the exoplanet
- `RA` - the right ascension of the host star/system
- `Dec` - the declination of the host star/system

The YAML to describe this list is as follows:

```
name: "Arfon's Fantastic Exoplanets"
description: "Arfon's list of exoplanet candidates. Hand-picked just for you."
properties:
  - name: "Name"
    kind: "String"
    units: ""
    required: "true"
    group: "Default"
    key: "default_name"
  - name: "Star Name"
    kind: "String"
    units: ""
    required: "true"
    group: "Default"
    key: "default_star_name"
  - name: "Planet Mass"
    kind: "Decimal"
    units: "mjupiter"
    required: "false"
    group: "Orbital Parameters"
    key: "orbital_parameters_planet_mass"
  - name: "RA"
    kind: "Decimal"
    units: "degrees"
    required: "true"
    group: "Default"
    key: "default_ra"
  - name: "Dec"
    kind: "Decimal"
    units: "degrees"
    required: "true"
    group: "Default"
    key: "default_dec"
```

`properties` in `list.yaml` is a YAML array and each of the `properties` in the array has the following structure:

```
- name: "RA"        <-- The property name (required)
  kind: "Decimal"   <-- The 'type' of the property
  units: "degrees"  <-- The units of the property value
  required: "true"  <-- Whether this is a required property for the Thing
  group: "Default"  <-- The property group
  key: "default_ra" <-- The unique key identifying the property (required)
```

**Important**

The `key` field for a property is used to relate the top-level `properties` defined within `list.yaml` with the associated list items (`Things`) stored in the `things` directory.

`key` fields must be unique in your list and by convention take the form of `group` + `name` all in lowercase joined by underscores.

**Things**

Things should be nested in the List repository in a folder named `things`. Each `Thing` in your list should have its own file. Below is an example for the exoplanet candidate Kepler 181 b:

```
# Example for `things/kepler-181-b.yaml`

properties:
  - property_key : "default_name"
    property_value: "Kepler-181 b"
    property_origin: "http://arxiv.org/abs/1402.6534"
  - property_key : "default_star_name"
    property_value: "Kepler-181"
    property_origin: ""
  - property_key : "orbital_parameters_planet_mass"
    property_value: "0.0067"
    property_origin: "http://arxiv.org/abs/1402.6534"
  - property_key : "default_ra"
    property_value: "286.0166667"
    property_origin: "http://arxiv.org/abs/1402.6534"
  - property_key : "default_dec"
    property_value: "50.0958333"
    property_origin: "http://arxiv.org/abs/1402.6534"
```

Note that we only need to define two key/value pairs here, `property_key` and `property_value`. These `property_key` fields are matched against the properties defined in `list.yaml` when presenting them.

## Importing a list from a Git repository

Once you've made a list you you can import it from the command line with the following three tasks:

```
thor lists:clone   # Clone the target list source repository
thor lists:verify  # Verify target repository has correct basic structure
thor lists:load    # Load the target repository into the database
```

`thor lists:clone`

> N.B. Only public Git repositories are currently supported.

Clones the target repository to `tmp/repository_name`:

```
> thor lists:clone git@github.com:arfon/exoplanet_list.git
```

`thor lists:verify`

Verify the list repository has the correct basic structure:

```
> thor lists:verify /Users/arfon/stsci/lists/tmp/exoplanet_list
```

`thor lists:load`

Load the local repository into the local database. By default doesn't save records, use `--save=true` to write to the database:

```
# Doesn't save to the DB
> thor lists:load /Users/arfon/stsci/lists/tmp/exoplanet_list

# Save to DB
> thor lists:load /Users/arfon/stsci/lists/tmp/exoplanet_list --save=true
```

## API

To be written

---------------------------------------
<sup>\*</sup>Formerly known as Listicles
