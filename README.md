# rdf2marc
A proof-of-concept RDF to MARC converter for use within the Sinopia ecosystem.


## Overview
In rdf2marc, the RDF is mapped to a model that represents the data found in a MARC record. The model is then mapped to a MARC record.

This enables supporting RDF variations, where each variation can have its own map to the model. In the context of Sinopia, this allows for supporting multiple resource templates. (This similarity between resource templates possibly allows for sharing mappings to models.)

The mapping is based on Library of Congress's [BIBFRAME 2.0 to MARC 21 Conversion Specifications](http://www.loc.gov/bibframe/bftm/).

## Usage
Mapping to the model:
```
$ exe/rdf2model instance.ttl work.ttl
```

Mapping to MARC:
```
$ exe/rdf2marc instance.ttl work.ttl
```

## Limitations
* Only some fields are mapped.
* Only `ld4p:RT:bf2:Monograph:Instance:Un-nested` and `ld4p:RT:bf2:Monograph:Work:Un-nested` are supported.

## To consider
* To what degree is there overlap between different resource templates? Does this enable code re-use?
* Resolving resources.