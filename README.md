[![CircleCI Build](https://circleci.com/gh/LD4P/rdf2marc/tree/main.svg?style=svg)](https://circleci.com/gh/LD4P/rdf2marc/tree/main)
[![Maintainability](https://api.codeclimate.com/v1/badges/ca0cdca6df5ec474e3f0/maintainability)](https://codeclimate.com/github/LD4P/rdf2marc/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/ca0cdca6df5ec474e3f0/test_coverage)](https://codeclimate.com/github/LD4P/rdf2marc/test_coverage)

# rdf2marc
A Bibframe RDF to MARC conversion library for use within the Sinopia ecosystem.

rdf2marc is currently available as a commandline utility and deployed within Sinopia as an AWS lamda (see CircleCI configuration).

## Overview
In rdf2marc, the RDF is mapped to a model that represents the data found in a MARC record. The model is then mapped to a MARC record.

This enables supporting RDF variations, where each variation can have its own map to the model. In the context of Sinopia, this allows for supporting multiple resource templates. (This similarity between resource templates possibly allows for sharing mappings to models.)

The mapping is based on Library of Congress's [BIBFRAME 2.0 to MARC 21 Conversion Specifications](http://www.loc.gov/bibframe/bftm/).

When the RDF references an external resource, rdf2marc will attempt to resolve that resource and extract data for populating the model.

## Ruby version
As [specified in the AWS lambda](https://github.com/sul-dlss/terraform-aws/blob/main/organizations/production/sinopia/sinopia-marc-lambda.tf#L70), rdf2marc used Ruby 2.7.

## Usage
Mapping to the model:
```
$ exe/rdf2model
Usage: rdf2model <instance ttl file> <work ttl file?> <admin metadata ttl file?>
Usage: rdf2model <instance uri>
$ exe/rdf2model instance.ttl work.ttl admin_metadata.ttl
$ exe/rdf2model https://api.stage.sinopia.io/resource/70ac2ed7-95d0-492a-a300-050a40895b74
$ exe/rdf2model https://api.development.sinopia.io/resource/83fe8c98-e34b-42aa-b6d3-07cc11c3faa6
```

Mapping to MARC:
```
$ exe/rdf2marc
Usage: rdf2marc <instance ttl file> <work ttl file?> <admin metadata ttl file?>
Usage: rdf2marc <instance uri>
$ exe/rdf2marc instance.ttl work.ttl admin_metadata.ttl
$ exe/rdf2marc https://api.stage.sinopia.io/resource/70ac2ed7-95d0-492a-a300-050a40895b74
$ exe/rdf2marc https://api.development.sinopia.io/resource/83fe8c98-e34b-42aa-b6d3-07cc11c3faa6
```

In addition to printing the MARC record, this will also output a binary MARC record (`record.mar`).

Note when using files:
* Currently, only turtle is supported.
* When copying turtle from Sinopia's RDF preview, the resource uri (`<>`) must be replaced by the actual uri (e.g., `https://api.stage.sinopia.io/resource/70ac2ed7-95d0-492a-a300-050a40895b74`)
* At least the instance ttl file. The Work ttl and Admin Metadata ttl files are optional if they are nested via a blank node in the Instance ttl file.

Note when using Instance uri:
* The Instance must contain a `bf:instanceOf` that references the Work or nests the Work via a blank node.
* The Instance must contain a `bf:adminMetadata` that references the Admin Metadata or nests the Admin Metadata via a blank node.

## Caching
Resolving external resources is slow. To speed this up, responses can be cached. The following caches are supported.
* `Rdf2marc::Caches::NullCache`: No caching (the default).
* `Rdf2marc::Caches::FileSystemCache`: Cache to the file system.
* `Rdf2marc::Caches::S3Cache`: Cache to an S3 bucket.

Example configuration:
```
Rdf2marc::Cache.configure(Rdf2marc::Caches::FileSystemCache.new)
Rdf2marc::Cache.configure(Rdf2marc::Caches::S3Cache.new('rdf2marc-development'))
```

## Current limitations
* Only some fields are mapped.
* Optimized for `ld4p:RT:bf2:*`resource templates, with a focus on Monographs.
* Only `id.loc.gov` and FAST external resources are resolved.
