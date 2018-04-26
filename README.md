Kafka Ingest
=====

Kafka Ingest is a kafka universal connector.It is built over HTTP so any application can directly call the API for producing the data to the Kafka.

Features
--------
1. Universal Kafka Connector over HTTP
2. Soft reconnecting capabilities
3. Built in queuing machanism When kafka cluster failure
4. Asynchronous independent producer worker pool  
5. Monitoring kafka producers .


Build
-----
Building the Kafka Ingest package 

    $ rebar3 compile
    $ rebar3 release
    
Starting the Kafka Ingest package

    $ cd _build/rel/zataas/
    $ ./bin/zataas start

Support
------
1. For any queries - http://erllabs.com
2. Email Support - support@erllabs.com

Copyright and License
---------------------
(c) 2018, Erllabs private Limited.
