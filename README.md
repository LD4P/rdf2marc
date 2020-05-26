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
Usage: rdf2model <instance ttl file> <work ttl file> <admin metadata ttl file>
Usage: rdf2model <instance uri>
$ exe/rdf2model instance.ttl work.ttl admin_metadata.ttl
$ exe/rdf2model https://trellis.stage.sinopia.io/repository/stanford/70ac2ed7-95d0-492a-a300-050a40895b74
```

Mapping to MARC:
```
$ exe/rdf2marc
Usage: rdf2marc <instance ttl file> <work ttl file> <admin metadata ttl file>
Usage: rdf2marc <instance uri>
$ exe/rdf2marc instance.ttl work.ttl admin_metadata.ttl
$ exe/rdf2marc https://trellis.stage.sinopia.io/repository/stanford/70ac2ed7-95d0-492a-a300-050a40895b74
```

Note when using files:
* Currently, only turtle is supported.
* When copying turtle from Sinopia's RDF preview, the resource uri (`<>`) must be replaced by the actual uri (e.g., `https://trellis.stage.sinopia.io/repository/stanford/70ac2ed7-95d0-492a-a300-050a40895b74`) 

Note when using Instance uri:
* The Instance must contain a `bf:instanceOf` that references the Work.

## Current limitations
* Only some fields are mapped.
* Only `ld4p:RT:bf2:Monograph:Instance:Un-nested` and `ld4p:RT:bf2:Monograph:Work:Un-nested` are supported.
* Only `id.loc.gov` external resources are resolved.

## To consider
* To what degree is there overlap between different resource templates? Does this enable code re-use?
