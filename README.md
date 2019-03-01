# Lists

This is Lists<sup>\*</sup>, a really simple service for creating and maintaining lists of astronomical things. It's an experimental service created by the team at MAST.

## Getting started

First visit [`https://lists.mast.stsci.edu`](http://lists.mast.stsci.edu) to get started - you'll need an ORCID account to sign in.

## About Lists

A `List` belongs to an individual. Lists need _at a minimum_ a name, and a short description. Lists can be public or private.

Each `List` is composed of multiple (currently limited to 10,000) `Things`. Each `Thing` has custom user-defined properties.

### Creating a list

To create a List you first need to create a Git repository with the metadata that defines the list properties and the Things you want to include in your List. An example of a list for brown dwarfs is here: https://github.com/arfon/brown_dwarfs

### List conventions

A List repository should have the following basic structure:

```yaml
list.yaml       # A YAML file describing the List (required)
things/         # A folder called 'things' with separate files for each Thing (required)
LICENSE         # Recommended
README.md       # Recommended

```

YAML is a human-readable markup language. You can read more about the YAML syntax here: https://en.wikipedia.org/wiki/YAML

## A worked example

An example of a list for brown dwarfs is here: https://github.com/arfon/brown_dwarfs.

The `list.yaml` is defined with a `name`, `description` and an array of `properties` that are essentially available fields to describe the associated `Things` with:

So to describe our list of brown dwarfs we are describing a collection of properties including:

- `Short Name` - the brown dwarf name
- `Alternative Designation` - an alternative name
- `Distance` - distance in pc
- `RA` - the right ascension
- `Dec` - the declination

The YAML to describe this list is as follows:

```yaml
name: "Arfon's Fantastic List of Brown Dwarfs"
description: "Arfon's list of brown dwarfs. Hand-picked just for you."
properties:
  - name: "Short Name"
    kind: "String"
    units: ""
    required: "true"
    group: "Default"
    key: "default_short_name"
  - name: "Alternate Designation"
    kind: "String"
    units: ""
    required: "true"
    group: "Default"
    key: "default_alternate_designation"
  - name: "Distance"
    kind: "Decimal"
    units: "pc"
    required: "false"
    group: "Default"
    key: "default_distance"
  - name: "RA"
    kind: "Decimal"
    units: "degrees"
    required: "true"
    group: "Default"
    key: "default_ra"
```

`properties` in `list.yaml` is a YAML array and each of the `properties` in the array has the following structure:

```yaml
- name: "RA"          # The property name (required)
  kind: "Decimal"     # The 'type' of the property
  units: "degrees"    # The units of the property value
  required: "true"    # Whether this is a required property for the Thing
  group: "Default"    # The property group
  key: "default_ra"   # The unique key identifying the property (required)
```

**Important**

The `key` field for a property is used to relate the top-level `properties` defined within `list.yaml` with the associated list items (`Things`) stored in the `things` directory.

`key` fields must be unique in your list and by convention take the form of `group` + `name` all in lowercase joined by underscores.

**Things**

Things should be nested in the List repository in a folder named `things`. Each `Thing` in your list should have its own file. Below is an example for the brown dwarf 1658+1820:

```yaml
# Example for `things/1658+1820.yaml`

default_short_name:
  value: "1658+1820"
  origin: ""
default_alternate_designation:
  value: "SDSS J16585026+1820006"
  origin: "https://arxiv.org/abs/1408.3089"
default_distance:
  value: ""
  origin: ""
default_ra:
  value: "254.709737"
  origin: ""
default_dec:
  value: "18.333275"
  origin: ""
default_spectral_types:
  value: "Optical: L0.0 L0.0"
  origin: "http://simbad.u-strasbg.fr/simbad/sim-ref?bibcode=2014ApJ...794..143B"

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
> thor lists:clone git@github.com:arfon/brown_dwarfs.git
```

`thor lists:verify`

Verify the list repository has the correct basic structure:

```
> thor lists:verify /Users/arfon/stsci/lists/tmp/brown_dwarfs
```

`thor lists:load`

Load the local repository into the local database. By default doesn't save records, use `--save=true` to write to the database:

```
# Doesn't save to the DB
> thor lists:load /Users/arfon/stsci/lists/tmp/brown_dwarfs

# Save to DB
> thor lists:load /Users/arfon/stsci/lists/tmp/brown_dwarfs --save=true
```

## API

Lists has a simple API RESTful that allows you to view `Lists` and their associated `Things` and also filter these `Things` based on custom URL filters.

The Lists API responses implement the [JSON-API](http://jsonapi.org/) specification.

- [Base URL](#base-url)
- [Authentication](#authentication)
- [Pagination](#pagination)
- [URL cheatsheet](#url-cheat-sheet)
- [List resource](#list-resource)
  - [Accessing a single list](#accessing-a-single-list)
- [Thing resource](#thing-resource)
  - [Accessing a single thing](#accessing-a-single-thing)
  - [Filtering things](#filtering-things)
- [Viewing a user and their lists](#viewing-a-user-and-their-public-lists)

### Base URL

All URLs referenced in the following documentation have the following base:

```
https://list.mast.stsci.edu/api/v1
```

### Authentication

Currently authentication is not supported via the API. Therefore, only visible Lists are available via the API.

### Pagination

By default all collection resources support pagination. Resource can be paged through by passing a `page=` URL parameter. The default page size is 30 records, this can be adjusted by passing a `per_page=` URL parameter (e.g. `per_page=50`).

### URL Cheat Sheet

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
         "id":"3093de1052c36fc07241f920fd0b284c",
         "type":"lists",
         "attributes":{  
            "name":"Arfon's Fantastic List of Brown Dwarfs",
            "description":"Arfon's list of brown dwarfs. Hand-picked just for you.",
            "properties":[  
               {  
                  "key":"default_short_name",
                  "kind":"String",
                  "name":"Short Name",
                  "group":"Default",
                  "units":"",
                  "required":"true"
               },
               {  
                  "key":"default_alternate_designation",
                  "kind":"String",
                  "name":"Alternate Designation",
                  "group":"Default",
                  "units":"",
                  "required":"true"
               },
               {  
                  "key":"default_distance",
                  "kind":"Decimal",
                  "name":"Distance",
                  "group":"Default",
                  "units":"pc",
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
               },
               {  
                  "key":"default_spectral_types",
                  "kind":"String",
                  "name":"Spectral Types",
                  "group":"Default",
                  "units":"",
                  "required":"true"
               },
               {  
                  "key":"photometry_sdss_u",
                  "kind":"decimal",
                  "name":"SDSS u",
                  "group":"Photometry",
                  "units":"",
                  "required":"false"
               },
               {  
                  "key":"photometry_sdss_g",
                  "kind":"decimal",
                  "name":"SDSS g",
                  "group":"Photometry",
                  "units":"",
                  "required":"false"
               },
               {  
                  "key":"photometry_sdss_r",
                  "kind":"decimal",
                  "name":"SDSS r",
                  "group":"Photometry",
                  "units":"",
                  "required":"false"
               },
               {  
                  "key":"photometry_sdss_i",
                  "kind":"decimal",
                  "name":"SDSS i",
                  "group":"Photometry",
                  "units":"",
                  "required":"false"
               },
               {  
                  "key":"photometry_sdss_z",
                  "kind":"decimal",
                  "name":"SDSS z",
                  "group":"Photometry",
                  "units":"",
                  "required":"false"
               },
               {  
                  "key":"photometry_2mass_j",
                  "kind":"decimal",
                  "name":"2MASS J",
                  "group":"Photometry",
                  "units":"",
                  "required":"false"
               },
               {  
                  "key":"photometry_2mass_h",
                  "kind":"decimal",
                  "name":"2MASS H",
                  "group":"Photometry",
                  "units":"",
                  "required":"false"
               },
               {  
                  "key":"photometry_2mass_ks",
                  "kind":"decimal",
                  "name":"2MASS Ks",
                  "group":"Photometry",
                  "units":"",
                  "required":"false"
               },
               {  
                  "key":"photometry_wise_w1",
                  "kind":"decimal",
                  "name":"WISE W1",
                  "group":"Photometry",
                  "units":"",
                  "required":"false"
               },
               {  
                  "key":"photometry_wise_w2",
                  "kind":"decimal",
                  "name":"WISE W2",
                  "group":"Photometry",
                  "units":"",
                  "required":"false"
               },
               {  
                  "key":"photometry_wise_w3",
                  "kind":"decimal",
                  "name":"WISE W3",
                  "group":"Photometry",
                  "units":"",
                  "required":"false"
               },
               {  
                  "key":"photometry_wise_w4",
                  "kind":"decimal",
                  "name":"WISE W4",
                  "group":"Photometry",
                  "units":"",
                  "required":"false"
               }
            ]
         },
         "relationships":{  
            "things":{  
               "data":[  
                  {  
                     "id":"d7d5e7be104e2d828b7c45ce35e8d0f0",
                     "type":"things"
                  },
                  {  
                     "id":"dd28b0ee6b5a3c8e3343ae97d2086d6d",
                     "type":"things"
                  }
               ]
            }
         },
         "links":{  
            "self":"/api/v1/lists/3093de1052c36fc07241f920fd0b284c",
            "things":"/api/v1/lists/3093de1052c36fc07241f920fd0b284c/things"
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

### Accessing a single List

Following RESTful conventions, individual Lists are available at:

```
https://list.mast.stsci.edu/api/v1/lists/:list_id
```

```
curl -v -H "Accept: application/json" \
https://list.mast.stsci.edu/api/v1/lists/3093de1052c36fc07241f920fd0b284c
```

```
HTTP/1.1 200 OK
X-Content-Type-Options: nosniff
Content-Type: application/json; charset=utf-8
Connection: close

{  
   "data":{  
      "id":"3093de1052c36fc07241f920fd0b284c",
      "type":"lists",
      "attributes":{  
         "name":"Arfon's Fantastic List of Brown Dwarfs",
         "description":"Arfon's list of brown dwarfs. Hand-picked just for you.",
         "properties":[  
            {  
               "key":"default_short_name",
               "kind":"String",
               "name":"Short Name",
               "group":"Default",
               "units":"",
               "required":"true"
            },
            {  
               "key":"default_alternate_designation",
               "kind":"String",
               "name":"Alternate Designation",
               "group":"Default",
               "units":"",
               "required":"true"
            },
            {  
               "key":"default_distance",
               "kind":"Decimal",
               "name":"Distance",
               "group":"Default",
               "units":"pc",
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
            },
            {  
               "key":"default_spectral_types",
               "kind":"String",
               "name":"Spectral Types",
               "group":"Default",
               "units":"",
               "required":"true"
            },
            {  
               "key":"photometry_sdss_u",
               "kind":"decimal",
               "name":"SDSS u",
               "group":"Photometry",
               "units":"",
               "required":"false"
            },
            {  
               "key":"photometry_sdss_g",
               "kind":"decimal",
               "name":"SDSS g",
               "group":"Photometry",
               "units":"",
               "required":"false"
            },
            {  
               "key":"photometry_sdss_r",
               "kind":"decimal",
               "name":"SDSS r",
               "group":"Photometry",
               "units":"",
               "required":"false"
            },
            {  
               "key":"photometry_sdss_i",
               "kind":"decimal",
               "name":"SDSS i",
               "group":"Photometry",
               "units":"",
               "required":"false"
            },
            {  
               "key":"photometry_sdss_z",
               "kind":"decimal",
               "name":"SDSS z",
               "group":"Photometry",
               "units":"",
               "required":"false"
            },
            {  
               "key":"photometry_2mass_j",
               "kind":"decimal",
               "name":"2MASS J",
               "group":"Photometry",
               "units":"",
               "required":"false"
            },
            {  
               "key":"photometry_2mass_h",
               "kind":"decimal",
               "name":"2MASS H",
               "group":"Photometry",
               "units":"",
               "required":"false"
            },
            {  
               "key":"photometry_2mass_ks",
               "kind":"decimal",
               "name":"2MASS Ks",
               "group":"Photometry",
               "units":"",
               "required":"false"
            },
            {  
               "key":"photometry_wise_w1",
               "kind":"decimal",
               "name":"WISE W1",
               "group":"Photometry",
               "units":"",
               "required":"false"
            },
            {  
               "key":"photometry_wise_w2",
               "kind":"decimal",
               "name":"WISE W2",
               "group":"Photometry",
               "units":"",
               "required":"false"
            },
            {  
               "key":"photometry_wise_w3",
               "kind":"decimal",
               "name":"WISE W3",
               "group":"Photometry",
               "units":"",
               "required":"false"
            },
            {  
               "key":"photometry_wise_w4",
               "kind":"decimal",
               "name":"WISE W4",
               "group":"Photometry",
               "units":"",
               "required":"false"
            }
         ]
      },
      "relationships":{  
         "things":{  
            "data":[  
               {  
                  "id":"d7d5e7be104e2d828b7c45ce35e8d0f0",
                  "type":"things"
               },
               {  
                  "id":"dd28b0ee6b5a3c8e3343ae97d2086d6d",
                  "type":"things"
               }
            ]
         }
      },
      "links":{  
         "self":"/api/v1/lists/3093de1052c36fc07241f920fd0b284c",
         "things":"/api/v1/lists/3093de1052c36fc07241f920fd0b284c/things"
      }
   }
}
```

### Thing Resource

`Things` are available as a nested resource on the parent `List`. For example, the `Things` for List ID `34e1e459c816fc8ad0b8602ac6adfbd9` are available at:

```
curl -v -H "Accept: application/json" \
https://list.mast.stsci.edu/api/v1/lists/3093de1052c36fc07241f920fd0b284c/things
```

```
HTTP/1.1 200 OK
X-Content-Type-Options: nosniff
Content-Type: application/json; charset=utf-8
Connection: close

{  
   "data":[  
      {  
         "id":"d7d5e7be104e2d828b7c45ce35e8d0f0",
         "type":"things",
         "attributes":{  
            "properties":{  
               "default-ra":{  
                  "value":"202.953870",
                  "origin":"",
                  "units":"degrees"
               },
               "default-dec":{  
                  "value":"-1.280556",
                  "origin":"",
                  "units":"degrees"
               },
               "default-distance":{  
                  "value":"14.86",
                  "origin":"",
                  "units":"pc"
               },
               "photometry-sdss-g":{  
                  "value":"25.50",
                  "origin":"https://www.sdss.org/",
                  "units":""
               },
               "photometry-sdss-i":{  
                  "value":"20.67",
                  "origin":"https://www.sdss.org/",
                  "units":""
               },
               "photometry-sdss-r":{  
                  "value":"22.87",
                  "origin":"https://www.sdss.org/",
                  "units":""
               },
               "photometry-sdss-u":{  
                  "value":"23.72",
                  "origin":"https://www.sdss.org/",
                  "units":""
               },
               "photometry-sdss-z":{  
                  "value":"18.08",
                  "origin":"https://www.sdss.org/",
                  "units":""
               },
               "default-short-name":{  
                  "value":"1331-0116",
                  "origin":"",
                  "units":""
               },
               "photometry-2mass-h":{  
                  "value":"14.47",
                  "origin":"https://old.ipac.caltech.edu/2mass/",
                  "units":""
               },
               "photometry-2mass-j":{  
                  "value":"15.46",
                  "origin":"https://old.ipac.caltech.edu/2mass/",
                  "units":""
               },
               "photometry-wise-w1":{  
                  "value":"14.08",
                  "origin":"https://www.nasa.gov/mission_pages/WISE/main/index.html",
                  "units":""
               },
               "photometry-wise-w2":{  
                  "value":"13.78",
                  "origin":"https://www.nasa.gov/mission_pages/WISE/main/index.html",
                  "units":""
               },
               "photometry-wise-w3":{  
                  "value":"11.93",
                  "origin":"https://www.nasa.gov/mission_pages/WISE/main/index.html",
                  "units":""
               },
               "photometry-wise-w4":{  
                  "value":"\u003e8.63",
                  "origin":"https://www.nasa.gov/mission_pages/WISE/main/index.html",
                  "units":""
               },
               "photometry-2mass-ks":{  
                  "value":"14.07",
                  "origin":"https://old.ipac.caltech.edu/2mass/",
                  "units":""
               },
               "default-spectral-types":{  
                  "value":"Optical: L6.0 Infrared: T0.0",
                  "origin":"http://simbad.u-strasbg.fr/simbad/sim-ref?bibcode=2014AJ....147...34S",
                  "units":""
               },
               "default-alternate-designation":{  
                  "value":"2MASS J13314894-0116500",
                  "origin":"https://arxiv.org/abs/1408.3089",
                  "units":""
               }
            }
         },
         "links":{  
            "self":"/api/v1/lists/3093de1052c36fc07241f920fd0b284c/things/d7d5e7be104e2d828b7c45ce35e8d0f0",
            "list":"/api/v1/lists/3093de1052c36fc07241f920fd0b284c"
         }
      },
      {  
         "id":"dd28b0ee6b5a3c8e3343ae97d2086d6d",
         "type":"things",
         "attributes":{  
            "properties":{  
               "default-ra":{  
                  "value":"254.709737",
                  "origin":"",
                  "units":"degrees"
               },
               "default-dec":{  
                  "value":"18.333275",
                  "origin":"",
                  "units":"degrees"
               },
               "default-distance":{  
                  "value":"",
                  "origin":"",
                  "units":"pc"
               },
               "photometry-sdss-g":{  
                  "value":"",
                  "origin":"",
                  "units":""
               },
               "photometry-sdss-i":{  
                  "value":"",
                  "origin":"",
                  "units":""
               },
               "photometry-sdss-r":{  
                  "value":"",
                  "origin":"",
                  "units":""
               },
               "photometry-sdss-u":{  
                  "value":"",
                  "origin":"",
                  "units":""
               },
               "photometry-sdss-z":{  
                  "value":"",
                  "origin":"",
                  "units":""
               },
               "default-short-name":{  
                  "value":"1658+1820",
                  "origin":"",
                  "units":""
               },
               "photometry-2mass-h":{  
                  "value":"",
                  "origin":"",
                  "units":""
               },
               "photometry-2mass-j":{  
                  "value":"",
                  "origin":"",
                  "units":""
               },
               "photometry-wise-w1":{  
                  "value":"14.08",
                  "origin":"https://www.nasa.gov/mission_pages/WISE/main/index.html",
                  "units":""
               },
               "photometry-wise-w2":{  
                  "value":"13.78",
                  "origin":"https://www.nasa.gov/mission_pages/WISE/main/index.html",
                  "units":""
               },
               "photometry-wise-w3":{  
                  "value":"11.93",
                  "origin":"https://www.nasa.gov/mission_pages/WISE/main/index.html",
                  "units":""
               },
               "photometry-wise-w4":{  
                  "value":"\u003e8.63",
                  "origin":"https://www.nasa.gov/mission_pages/WISE/main/index.html",
                  "units":""
               },
               "photometry-2mass-ks":{  
                  "value":"",
                  "origin":"",
                  "units":""
               },
               "default-spectral-types":{  
                  "value":"Optical: L0.0 L0.0",
                  "origin":"http://simbad.u-strasbg.fr/simbad/sim-ref?bibcode=2014ApJ...794..143B",
                  "units":""
               },
               "default-alternate-designation":{  
                  "value":"SDSS J16585026+1820006",
                  "origin":"https://arxiv.org/abs/1408.3089",
                  "units":""
               }
            }
         },
         "links":{  
            "self":"/api/v1/lists/3093de1052c36fc07241f920fd0b284c/things/dd28b0ee6b5a3c8e3343ae97d2086d6d",
            "list":"/api/v1/lists/3093de1052c36fc07241f920fd0b284c"
         }
      }
   ],
   "links":{  

   }
}
```

### Accessing a single thing

A single `Thing` can also be accessed via a nested `List` URL, for example, for `Thing` ID `de562564270ce9135871db63c7d75908`:

```
curl -v -H "Accept: application/json" \
https://list.mast.stsci.edu/api/v1/lists/3093de1052c36fc07241f920fd0b284c/things/de562564270ce9135871db63c7d75908
```

```
HTTP/1.1 200 OK
X-Content-Type-Options: nosniff
Content-Type: application/json; charset=utf-8
Connection: close

{  
   "data":{  
      "id":"d7d5e7be104e2d828b7c45ce35e8d0f0",
      "type":"things",
      "attributes":{  
         "properties":{  
            "default-ra":{  
               "value":"202.953870",
               "origin":"",
               "units":"degrees"
            },
            "default-dec":{  
               "value":"-1.280556",
               "origin":"",
               "units":"degrees"
            },
            "default-distance":{  
               "value":"14.86",
               "origin":"",
               "units":"pc"
            },
            "photometry-sdss-g":{  
               "value":"25.50",
               "origin":"https://www.sdss.org/",
               "units":""
            },
            "photometry-sdss-i":{  
               "value":"20.67",
               "origin":"https://www.sdss.org/",
               "units":""
            },
            "photometry-sdss-r":{  
               "value":"22.87",
               "origin":"https://www.sdss.org/",
               "units":""
            },
            "photometry-sdss-u":{  
               "value":"23.72",
               "origin":"https://www.sdss.org/",
               "units":""
            },
            "photometry-sdss-z":{  
               "value":"18.08",
               "origin":"https://www.sdss.org/",
               "units":""
            },
            "default-short-name":{  
               "value":"1331-0116",
               "origin":"",
               "units":""
            },
            "photometry-2mass-h":{  
               "value":"14.47",
               "origin":"https://old.ipac.caltech.edu/2mass/",
               "units":""
            },
            "photometry-2mass-j":{  
               "value":"15.46",
               "origin":"https://old.ipac.caltech.edu/2mass/",
               "units":""
            },
            "photometry-wise-w1":{  
               "value":"14.08",
               "origin":"https://www.nasa.gov/mission_pages/WISE/main/index.html",
               "units":""
            },
            "photometry-wise-w2":{  
               "value":"13.78",
               "origin":"https://www.nasa.gov/mission_pages/WISE/main/index.html",
               "units":""
            },
            "photometry-wise-w3":{  
               "value":"11.93",
               "origin":"https://www.nasa.gov/mission_pages/WISE/main/index.html",
               "units":""
            },
            "photometry-wise-w4":{  
               "value":"\u003e8.63",
               "origin":"https://www.nasa.gov/mission_pages/WISE/main/index.html",
               "units":""
            },
            "photometry-2mass-ks":{  
               "value":"14.07",
               "origin":"https://old.ipac.caltech.edu/2mass/",
               "units":""
            },
            "default-spectral-types":{  
               "value":"Optical: L6.0 Infrared: T0.0",
               "origin":"http://simbad.u-strasbg.fr/simbad/sim-ref?bibcode=2014AJ....147...34S",
               "units":""
            },
            "default-alternate-designation":{  
               "value":"2MASS J13314894-0116500",
               "origin":"https://arxiv.org/abs/1408.3089",
               "units":""
            }
         }
      },
      "links":{  
         "self":"/api/v1/lists/3093de1052c36fc07241f920fd0b284c/things/d7d5e7be104e2d828b7c45ce35e8d0f0",
         "list":"/api/v1/lists/3093de1052c36fc07241f920fd0b284c"
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

For example, to find all `Things` (brown dwarfs in this case) for the `List` defined in the [worked example above](#a-worked-example), with ID `3093de1052c36fc07241f920fd0b284c`, with a RA greater than 20 degrees and a 2MASS J photometry brighter than 15th magnitude (assuming these are the units of a property):

```
curl -v -H "Accept: application/json" \
https://list.mast.stsci.edu/api/v1/lists/3093de1052c36fc07241f920fd0b284c/things/filter?default_ra=gte20&2mass_j=lte15
```

### Viewing a User and their public Lists

If you know a User's ID then you can view the user and access their public lists via the API:

```
curl -v -H "Accept: application/json" \
https://list.mast.stsci.edu/api/v1/users/57f78b082cda2952e59884e644eebbb6
```

```
HTTP/1.1 200 OK
X-Content-Type-Options: nosniff
Content-Type: application/json; charset=utf-8
Connection: close
{  
   "data":{  
      "id":"57f78b082cda2952e59884e644eebbb6",
      "type":"users",
      "attributes":{  
         "name":"Arfon Smith",
         "lists":[  
            {  
               "id":1,
               "name":"Arfon's Fantastic List of Brown Dwarfs",
               "sha":"3093de1052c36fc07241f920fd0b284c",
               "description":"Arfon's list of brown dwarfs. Hand-picked just for you.",
               "doi":null,
               "properties":[  
                  {  
                     "key":"default_short_name",
                     "kind":"String",
                     "name":"Short Name",
                     "group":"Default",
                     "units":"",
                     "required":"true"
                  },
                  {  
                     "key":"default_alternate_designation",
                     "kind":"String",
                     "name":"Alternate Designation",
                     "group":"Default",
                     "units":"",
                     "required":"true"
                  },
                  {  
                     "key":"default_distance",
                     "kind":"Decimal",
                     "name":"Distance",
                     "group":"Default",
                     "units":"pc",
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
                  },
                  {  
                     "key":"default_spectral_types",
                     "kind":"String",
                     "name":"Spectral Types",
                     "group":"Default",
                     "units":"",
                     "required":"true"
                  },
                  {  
                     "key":"photometry_sdss_u",
                     "kind":"decimal",
                     "name":"SDSS u",
                     "group":"Photometry",
                     "units":"",
                     "required":"false"
                  },
                  {  
                     "key":"photometry_sdss_g",
                     "kind":"decimal",
                     "name":"SDSS g",
                     "group":"Photometry",
                     "units":"",
                     "required":"false"
                  },
                  {  
                     "key":"photometry_sdss_r",
                     "kind":"decimal",
                     "name":"SDSS r",
                     "group":"Photometry",
                     "units":"",
                     "required":"false"
                  },
                  {  
                     "key":"photometry_sdss_i",
                     "kind":"decimal",
                     "name":"SDSS i",
                     "group":"Photometry",
                     "units":"",
                     "required":"false"
                  },
                  {  
                     "key":"photometry_sdss_z",
                     "kind":"decimal",
                     "name":"SDSS z",
                     "group":"Photometry",
                     "units":"",
                     "required":"false"
                  },
                  {  
                     "key":"photometry_2mass_j",
                     "kind":"decimal",
                     "name":"2MASS J",
                     "group":"Photometry",
                     "units":"",
                     "required":"false"
                  },
                  {  
                     "key":"photometry_2mass_h",
                     "kind":"decimal",
                     "name":"2MASS H",
                     "group":"Photometry",
                     "units":"",
                     "required":"false"
                  },
                  {  
                     "key":"photometry_2mass_ks",
                     "kind":"decimal",
                     "name":"2MASS Ks",
                     "group":"Photometry",
                     "units":"",
                     "required":"false"
                  },
                  {  
                     "key":"photometry_wise_w1",
                     "kind":"decimal",
                     "name":"WISE W1",
                     "group":"Photometry",
                     "units":"",
                     "required":"false"
                  },
                  {  
                     "key":"photometry_wise_w2",
                     "kind":"decimal",
                     "name":"WISE W2",
                     "group":"Photometry",
                     "units":"",
                     "required":"false"
                  },
                  {  
                     "key":"photometry_wise_w3",
                     "kind":"decimal",
                     "name":"WISE W3",
                     "group":"Photometry",
                     "units":"",
                     "required":"false"
                  },
                  {  
                     "key":"photometry_wise_w4",
                     "kind":"decimal",
                     "name":"WISE W4",
                     "group":"Photometry",
                     "units":"",
                     "required":"false"
                  }
               ],
               "user_id":1,
               "visible":true,
               "created_at":"2019-03-01T15:34:07.949Z",
               "updated_at":"2019-03-01T15:34:39.406Z"
            }
         ]
      },
      "relationships":{  
         "lists":{  
            "data":[  
               {  
                  "id":"3093de1052c36fc07241f920fd0b284c",
                  "type":"lists"
               }
            ]
         }
      },
      "links":{  
         "self":"/api/v1/users/57f78b082cda2952e59884e644eebbb6"
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
