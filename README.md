# Lists

This is Lists<sup>\*</sup>, a really simple service for creating and maintaining lists of astronomical things. It's an experimental service created by the team at MAST.

## Getting started

First visit [`http://list.mast.stsci.edu`](http://list.mast.stsci.edu) to get started - you'll need an ORCID account to sign in.

## Configuration

## Creating a list

A `List` belongs to one or more individuals. Lists need _at a minimum_ a name, and a short description. Lists can be public or private.

Each `List` is composed of multiple (currently limited to 10,000) `Things`. Each `Thing` has custom user-defined properties.

**Defining properties for you thing**

How do we do this?

### Adding things to your list

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

### API

---------------------------------------
<sup>\*</sup>Formerly known as Listicles
