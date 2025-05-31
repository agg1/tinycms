A software supplier of [German Aerospace Center](https://www.dlr.de/en) requested improvements for their [full-text-search](https://en.wikipedia.org/wiki/Full-text_search) system with various [natural-language-processing](https://en.wikipedia.org/wiki/Natural_Language_Processing) extensions. Besides regular full-text-search operations the system had to provide automated document-categorization and classification algorithms. Although few technical aspects were involved with the traditional fields of ["Artificial Intelligence (AI)"](https://en.wikipedia.org/wiki/Artificial_Intelligence) this term is referred to by marketing inflationary.[^NNP]

A reference implementation for full-text-search and document categorization was provided by a scientist from Munich technical universtity, based on [Apache Solr](https://solr.apache.org) integrated with a [Java Spring-Framework](https://en.wikipedia.org/wiki/Spring_Framework) [MVC](https://en.wikipedia.org/wiki/MVC_architecture) architecture and little documentation provided. Runtime performance and features had to be improved upon and management proposed to deploy an [Elasticsearch NoSQL Cluster](https://www.elastic.co/elasticsearch) with some algorithms and extensions re-implemented instead.

The project then involved:

- An initial concept paper
- Specification and full re-implementation of automated document categorization, text analysis, classification
- Implementation and integration of web-crawlers, document format adapters and text-content extractors
- Scalable multi-threaded text analysis algorithms
- Re-integration of components with Spring-Framework for the Elasticsearch cluster frontend nodes
- Extension of the [JSON/REST](https://en.wikipedia.org/wiki/REST) web service API for ease of use
- Release management, software deployment, cluster administration
- Testing with pharmacovigilance data, BAfS data, GEO location service

In essence document-categorization is a reverse-function of matching search terms against an index, then instead proposing a search-term vector for a document-corpus and matching those term-token-vectors against each other for categorization with use-cases such as:

- ["predictive profiling"](https://en.wikipedia.org/wiki/Predictive_policing)
- matching of documents against pre-trained topic-trees
- automated text-content summary
- furthermore optional automated translations to match and categorize foreign-language texts

Software-Architecture, run-time performance, features were significantly improved upon. In principle run-time performance and scalability are highly critical with these types of system and algorithms.

As a future prospect components implemented in C language could be preferrable:

- Although Elasticseach implements sophisticated NLP-features and clustering
- PostgreSQL with FTS-extensions (written in C) could be used instead of Elasticsearch (Java)
- Utilizing Perl or Lua inside PostgreSQL database core with [PL/Perl](https://www.postgresql.org/docs/current/plperl.html)
- Avoiding data aggregation inside a Java Persistence Layer (Spring-Framework is slow) outside database-core, to improve upon run-time performance with stored-procedures instead

***Finally all sources and documentation were handed over and contracting did not permit me to keep any sources and documentation of mine.***
Accounting for total hours of time and work invested salary remained **below** minimum wage for this and subsequent contracting denied at "labor market", meanwhile "entrepreneus" affiliated with EU made a billion cash business out of it to benefit shareholder value of theirs.

[^NNP]: [Neural Network Perceptrons](https://en.wikipedia.org/wiki/Perceptron) implemented with [Machine Learning Algorithms](https://en.wikipedia.org/wiki/Machine_Learning) for [Pattern Recognition](https://en.wikipedia.org/wiki/Pattern_recognition) are not in the scope of natural-language-processing (NLP) almost always. It is important to distinguish terms for NLP from Neural Network Perceptrons (NNP) with "AI", since rarely ever these scientific fields of studies intersected but are confused by the marketing fuzz surrounding "AI".

