# Lists

This is Lists<sup>\*</sup>, a really simple service for creating and maintaining lists of astronomical things. It's an experimental service created by the team at MAST.

## Getting started

First visit [`https://list.mast.stsci.edu`](http://list.mast.stsci.edu) to get started - you'll need an ORCID account to sign in.

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

default_name:
  value: "Kepler-181 b"
  origin: "http://arxiv.org/abs/1402.6534"
default_star_name:
  value: "Kepler-181"
  origin: ""
orbital_parameters_planet_mass:
  value: "0.0067"
  origin: "http://arxiv.org/abs/1402.6534"
default_ra:
  value: "286.0166667"
  origin: "http://arxiv.org/abs/1402.6534"
default_dec:
  value: "50.0958333"
  origin: "http://arxiv.org/abs/1402.6534"

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

Lists has a simple API RESTful that allows you to view `Lists` and their associated `Things` and also filter these `Things` based on custom URL filters.

The Lists API responses implement the [JSON-API](http://jsonapi.org/) specification.

### Base URL

All URLs referenced in the following documentation have the following base:

```
https://list.mast.stsci.edu/api/v1
```

### Authentication

Currently authentication is not supported via the API. Therefore, only visible Lists are available via the API.

### Pagination

By default all collection resources support pagination. Resource can be paged through by passing a `page=` URL parameter. The default page size is 30 records, this can be adjusted by passing a `per_page=` URL parameter (e.g. `per_page=50`).

### Cheat Sheet

If you're just looking for a quick list of the URLs that the Lists service exposes here it is:

```
All public lists: https://list.mast.stsci.edu/api/v1/lists
A single list: https://list.mast.stsci.edu/api/v1/lists/:list_id

A list's Things: https://list.mast.stsci.edu/api/v1/lists/:list_id/things
Filtering a List's Things: https://list.mast.stsci.edu/api/v1/lists/:list_id/things/filter?query=param
A single List Thing: https://list.mast.stsci.edu/api/v1/lists/:list_id/things/:thing_id

A User's public lists: https://list.mast.stsci.edu/api/v1/users/:user_id/lists
```

For more in-depth documentation read on...

### List Resource

The 30 most recent visible `Lists` are available at:

```
curl -v -H "Accept: application/json" \
https://list.mast.stsci.edu/api/v1/lists
```

```
HTTP/1.1 200 OK
X-Content-Type-Options: nosniff
Content-Type: application/json; charset=utf-8
Connection: close

{  
   "data":[  
      {  
         "id":"34e1e459c816fc8ad0b8602ac6adfbd9",
         "type":"lists",
         "attributes":{  
            "name":"Arfon's Fantastic Exoplanets",
            "description":"Arfon's list of exoplanet candidates. Hand-picked just for you.",
            "properties":[  
               {  
                  "key":"default_name",
                  "kind":"String",
                  "name":"Name",
                  "group":"Default",
                  "units":"",
                  "required":"true"
               },
               {  
                  "key":"default_star_name",
                  "kind":"String",
                  "name":"Star Name",
                  "group":"Default",
                  "units":"",
                  "required":"true"
               },
               {  
                  "key":"orbital_parameters_planet_mass",
                  "kind":"Decimal",
                  "name":"Planet Mass",
                  "group":"Orbital Parameters",
                  "units":"mjupiter",
                  "required":"false"
               },
               {  
                  "key":"default_ra",
                  "kind":"Decimal",
                  "name":"RA",
                  "group":"Default",
                  "units":"degrees",
                  "required":"true"
               },
               {  
                  "key":"default_dec",
                  "kind":"Decimal",
                  "name":"Dec",
                  "group":"Default",
                  "units":"degrees",
                  "required":"true"
               }
            ]
         },
         "relationships":{  
            "things":{  
               "data":[  
                  {  
                     "id":"1c82ecc057c2ccfdde763a1997664700",
                     "type":"things"
                  },
                  {  
                     "id":"de562564270ce9135871db63c7d75908",
                     "type":"things"
                  },
                  {  
                     "id":"efbeee053fd22b8546fe0ee102d43c2a",
                     "type":"things"
                  },
                  {  
                     "id":"8adb6fafc6734f5d88952aec34b3324d",
                     "type":"things"
                  }
               ]
            }
         },
         "links":{  
            "self":"/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9",
            "things":"/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9/things"
         }
      }
   ],
   "links":{  

   }
}
```

Additional lists can be accessed by paging, e.g.:

```
https://list.mast.stsci.edu/api/v1/lists?page=2
```

#### Accessing a single List

Following RESTful conventions, individual Lists are available at:

```
https://list.mast.stsci.edu/api/v1/lists/:list_id
```

```
curl -v -H "Accept: application/json" \
https://list.mast.stsci.edu/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9
```

```
HTTP/1.1 200 OK
X-Content-Type-Options: nosniff
Content-Type: application/json; charset=utf-8
Connection: close

{  
   "data":{  
      "id":"34e1e459c816fc8ad0b8602ac6adfbd9",
      "type":"lists",
      "attributes":{  
         "name":"Arfon's Fantastic Exoplanets",
         "description":"Arfon's list of exoplanet candidates. Hand-picked just for you.",
         "properties":[  
            {  
               "key":"default_name",
               "kind":"String",
               "name":"Name",
               "group":"Default",
               "units":"",
               "required":"true"
            },
            {  
               "key":"default_star_name",
               "kind":"String",
               "name":"Star Name",
               "group":"Default",
               "units":"",
               "required":"true"
            },
            {  
               "key":"orbital_parameters_planet_mass",
               "kind":"Decimal",
               "name":"Planet Mass",
               "group":"Orbital Parameters",
               "units":"mjupiter",
               "required":"false"
            },
            {  
               "key":"default_ra",
               "kind":"Decimal",
               "name":"RA",
               "group":"Default",
               "units":"degrees",
               "required":"true"
            },
            {  
               "key":"default_dec",
               "kind":"Decimal",
               "name":"Dec",
               "group":"Default",
               "units":"degrees",
               "required":"true"
            }
         ]
      },
      "relationships":{  
         "things":{  
            "data":[  
               {  
                  "id":"1c82ecc057c2ccfdde763a1997664700",
                  "type":"things"
               },
               {  
                  "id":"de562564270ce9135871db63c7d75908",
                  "type":"things"
               },
               {  
                  "id":"efbeee053fd22b8546fe0ee102d43c2a",
                  "type":"things"
               },
               {  
                  "id":"8adb6fafc6734f5d88952aec34b3324d",
                  "type":"things"
               }
            ]
         }
      },
      "links":{  
         "self":"/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9",
         "things":"/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9/things"
      }
   }
}
```

### Thing Resource

`Things` are available as a nested resource on the parent `List`. For example, the `Things` for List ID `34e1e459c816fc8ad0b8602ac6adfbd9` are available at:

```
curl -v -H "Accept: application/json" \
https://list.mast.stsci.edu/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9/things
```

```
HTTP/1.1 200 OK
X-Content-Type-Options: nosniff
Content-Type: application/json; charset=utf-8
Connection: close

{  
   "data":[  
      {  
         "id":"1c82ecc057c2ccfdde763a1997664700",
         "type":"things",
         "attributes":{  
            "properties":{  
               "default-ra":{  
                  "value":"286.0166667",
                  "origin":"http://adsabs.harvard.edu/abs/2016ApJ...822...86M"
               },
               "default-dec":{  
                  "value":"50.0958333",
                  "origin":"http://adsabs.harvard.edu/abs/2016ApJ...822...86M"
               },
               "default-name":{  
                  "value":"Kepler-1156 b",
                  "origin":"http://adsabs.harvard.edu/abs/2016ApJ...822...86M"
               },
               "default-star-name":{  
                  "value":"Kepler-1156",
                  "origin":""
               },
               "orbital-parameters-planet-mass":{  
                  "value":"0.0067",
                  "origin":"http://adsabs.harvard.edu/abs/2016ApJ...822...86M"
               }
            }
         },
         "links":{  
            "self":"/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9/things/1c82ecc057c2ccfdde763a1997664700",
            "list":"/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9"
         }
      },
      {  
         "id":"de562564270ce9135871db63c7d75908",
         "type":"things",
         "attributes":{  
            "properties":{  
               "default-ra":{  
                  "value":"286.0166667",
                  "origin":"http://arxiv.org/abs/1402.6534"
               },
               "default-dec":{  
                  "value":"50.0958333",
                  "origin":"http://arxiv.org/abs/1402.6534"
               },
               "default-name":{  
                  "value":"Kepler-181 b",
                  "origin":"http://arxiv.org/abs/1402.6534"
               },
               "default-star-name":{  
                  "value":"Kepler-181",
                  "origin":""
               },
               "orbital-parameters-planet-mass":{  
                  "value":"0.0067",
                  "origin":"http://arxiv.org/abs/1402.6534"
               }
            }
         },
         "links":{  
            "self":"/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9/things/de562564270ce9135871db63c7d75908",
            "list":"/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9"
         }
      },
      {  
         "id":"efbeee053fd22b8546fe0ee102d43c2a",
         "type":"things",
         "attributes":{  
            "properties":{  
               "default-ra":{  
                  "value":"286.0166667",
                  "origin":"http://arxiv.org/abs/1402.6534"
               },
               "default-dec":{  
                  "value":"50.0958333",
                  "origin":"http://arxiv.org/abs/1402.6534"
               },
               "default-name":{  
                  "value":"Kepler-181 c",
                  "origin":"http://arxiv.org/abs/1402.6534"
               },
               "default-star-name":{  
                  "value":"Kepler-181",
                  "origin":""
               },
               "orbital-parameters-planet-mass":{  
                  "value":"0.0015",
                  "origin":"http://arxiv.org/abs/1402.6534"
               }
            }
         },
         "links":{  
            "self":"/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9/things/efbeee053fd22b8546fe0ee102d43c2a",
            "list":"/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9"
         }
      },
      {  
         "id":"8adb6fafc6734f5d88952aec34b3324d",
         "type":"things",
         "attributes":{  
            "properties":{  
               "default-ra":{  
                  "value":"286.0166667",
                  "origin":"http://adsabs.harvard.edu/abs/2006ApJ...646..505B"
               },
               "default-dec":{  
                  "value":"50.0958333",
                  "origin":"http://adsabs.harvard.edu/abs/2006ApJ...646..505B"
               },
               "default-name":{  
                  "value":"WASP-14 b",
                  "origin":"http://arxiv.org/abs/1402.6534"
               },
               "default-star-name":{  
                  "value":"WASP-14",
                  "origin":""
               },
               "orbital-parameters-planet-mass":{  
                  "value":"7.69",
                  "origin":"http://adsabs.harvard.edu/abs/2006ApJ...646..505B"
               }
            }
         },
         "links":{  
            "self":"/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9/things/8adb6fafc6734f5d88952aec34b3324d",
            "list":"/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9"
         }
      }
   ],
   "links":{  

   }
}
```

A single `Thing` can also be accessed via a nested `List` URL, for example, for `Thing` ID `de562564270ce9135871db63c7d75908`:

```
curl -v -H "Accept: application/json" \
https://list.mast.stsci.edu/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9/things/de562564270ce9135871db63c7d75908
```

```
HTTP/1.1 200 OK
X-Content-Type-Options: nosniff
Content-Type: application/json; charset=utf-8
Connection: close

{  
   "data":{  
      "id":"de562564270ce9135871db63c7d75908",
      "type":"things",
      "attributes":{  
         "properties":{  
            "default-ra":{  
               "value":"286.0166667",
               "origin":"http://arxiv.org/abs/1402.6534"
            },
            "default-dec":{  
               "value":"50.0958333",
               "origin":"http://arxiv.org/abs/1402.6534"
            },
            "default-name":{  
               "value":"Kepler-181 b",
               "origin":"http://arxiv.org/abs/1402.6534"
            },
            "default-star-name":{  
               "value":"Kepler-181",
               "origin":""
            },
            "orbital-parameters-planet-mass":{  
               "value":"0.0067",
               "origin":"http://arxiv.org/abs/1402.6534"
            }
         }
      },
      "links":{  
         "self":"/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9/things/de562564270ce9135871db63c7d75908",
         "list":"/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9"
      }
   }
}
```

### Filtering Things

It's possible to return only a subset of the `Things` associated with a `List`. This is achieved by passing custom URL parameters that match the `List` property keys to the following URL:

```
https://list.mast.stsci.edu/api/v1/lists/:list_id/things/filter
```

The filtering functionality supports three basic filtering options:
0. Exact match (e.g. `default_ra=123.456`)
0. Greater than or equal to (e.g. `default_ra=gte123.456`)
0. Less than or equal to (e.g. `default_ra=lte123.456`)

Available filter parameters are defined by the parent `List` property keys and can be combined when constructing a query.

For example, to find all `Things` (exoplanets in this case) for the `List` defined in the [worked example above](#a-worked-example), with ID `34e1e459c816fc8ad0b8602ac6adfbd9`, with a RA greater than 20 degrees and a mass less than 10 mJupiter (assuming these are the units of a property):

```
curl -v -H "Accept: application/json" \
https://list.mast.stsci.edu/api/v1/lists/34e1e459c816fc8ad0b8602ac6adfbd9/things/filter?default_ra=gte20&orbital_parameters_planet_mass=lte10
```

### Viewing a User and their public Lists

If you know a User's ID then you can view the user and access their public lists via the API:

```
curl -v -H "Accept: application/json" \
https://list.mast.stsci.edu/api/v1/users/:user_id
```

```
HTTP/1.1 200 OK
X-Content-Type-Options: nosniff
Content-Type: application/json; charset=utf-8
Connection: close

{  
   "data":{  
      "id":"a8d4372e6481a445b07fd99f1701b240",
      "type":"users",
      "attributes":{  
         "name":"Arfon Smith",
         "lists":[  
            {  
               "id":2,
               "name":"Arfon's Fantastic Exoplanets",
               "sha":"34e1e459c816fc8ad0b8602ac6adfbd9",
               "description":"Arfon's list of exoplanet candidates. Hand-picked just for you.",
               "doi":null,
               "properties":[  
                  {  
                     "key":"default_name",
                     "kind":"String",
                     "name":"Name",
                     "group":"Default",
                     "units":"",
                     "required":"true"
                  },
                  {  
                     "key":"default_star_name",
                     "kind":"String",
                     "name":"Star Name",
                     "group":"Default",
                     "units":"",
                     "required":"true"
                  },
                  {  
                     "key":"orbital_parameters_planet_mass",
                     "kind":"Decimal",
                     "name":"Planet Mass",
                     "group":"Orbital Parameters",
                     "units":"mjupiter",
                     "required":"false"
                  },
                  {  
                     "key":"default_ra",
                     "kind":"Decimal",
                     "name":"RA",
                     "group":"Default",
                     "units":"degrees",
                     "required":"true"
                  },
                  {  
                     "key":"default_dec",
                     "kind":"Decimal",
                     "name":"Dec",
                     "group":"Default",
                     "units":"degrees",
                     "required":"true"
                  }
               ],
               "user_id":1,
               "visible":true,
               "created_at":"2017-05-25T22:02:31.042Z",
               "updated_at":"2017-05-25T22:45:29.759Z"
            }
         ]
      },
      "relationships":{  
         "lists":{  
            "data":[  
               {  
                  "id":"34e1e459c816fc8ad0b8602ac6adfbd9",
                  "type":"lists"
               }
            ]
         }
      },
      "links":{  
         "self":"/api/v1/users/a8d4372e6481a445b07fd99f1701b240"
      }
   }
}
```

Note that if a `User` has more than 30 public lists then you'll need to paginate, e.g.:

```
https://list.mast.stsci.edu/api/v1/users/:user_id&page=2
```





---------------------------------------
<sup>\*</sup>Formerly known as Listicles
