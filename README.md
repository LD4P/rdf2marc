# rdf2marc
A proof-of-concept RDF to MARC converter for use within the Sinopia ecosystem.


## Overview
In rdf2marc, the RDF is mapped to a model that represents the data found in a MARC record. The model is then mapped to a MARC record.

This enables supporting RDF variations, where each variation can have its own map to the model. In the context of Sinopia, this allows for supporting multiple resource templates. (This similarity between resource templates possibly allows for sharing mappings to models.)

The mapping is based on Library of Congress's [BIBFRAME 2.0 to MARC 21 Conversion Specifications](http://www.loc.gov/bibframe/bftm/).

When the RDF references an external resource, rdf2marc will attempt to resolve that resource and extract data for populating the model.

## Usage
Mapping to the model:
```
$ exe/rdf2model 
Usage: rdf2model <instance ttl file> <work ttl file?> <admin metadata ttl file?>
Usage: rdf2model <instance uri>
$ exe/rdf2model instance.ttl work.ttl admin_metadata.ttl
$ exe/rdf2model https://trellis.stage.sinopia.io/repository/stanford/70ac2ed7-95d0-492a-a300-050a40895b74
```

Mapping to MARC:
```
$ exe/rdf2marc
Usage: rdf2marc <instance ttl file> <work ttl file?> <admin metadata ttl file?>
Usage: rdf2marc <instance uri>
$ exe/rdf2marc instance.ttl work.ttl admin_metadata.ttl
$ exe/rdf2marc https://trellis.stage.sinopia.io/repository/stanford/70ac2ed7-95d0-492a-a300-050a40895b74
```

Note when using files:
* Currently, only turtle is supported.
* When copying turtle from Sinopia's RDF preview, the resource uri (`<>`) must be replaced by the actual uri (e.g., `https://trellis.stage.sinopia.io/repository/stanford/70ac2ed7-95d0-492a-a300-050a40895b74`)
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
* Only `id.loc.gov` external resources are resolved.
