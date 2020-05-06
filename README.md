# rdf2marc
A proof-of-concept RDF to MARC converter for use within the Sinopia ecosystem.

## Overview
In rdf2marc, the RDF is mapped to a model that represents the data found in a MARC record. The model is then mapped to a MARC record.

This enables supporting RDF variations, where each variation can have its own map to the model. In the context of Sinopia, this allows for supporting multiple resource templates. (This similarity between resource templates possibly allows for sharing mappings to models.)

Though not strictly required, the mapping to the model is performed using SPARQL on the assumption that familiarity with SPARQL is a reasonable expectation of a linked data practitioner.

## Usage
Mapping to the model:
```
$ exe/rdf2model instance.ttl
{
  "title_statement": {
    "title": "Raven black"
  }
}
```

Mapping to MARC:
```
$ exe/rdf2marc instance.ttl
LEADER           22        4500
245    $a Raven black 
```

## To consider
* Can / is there value in moving SPARQL statements to configuration?
* Can the SPARQL statements be simplified to remove redundancy?
* To what degree is there overlap between different resource templates? Does this enable code re-use?
* Stitching together works and instances.
* Resolving resources.