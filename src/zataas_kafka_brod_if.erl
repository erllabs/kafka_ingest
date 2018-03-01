-module(zataas_kafka_brod_if).

-export([start/0,send/1]).

start() ->
	io:format("The module info:~p~n",[brod:module_info()]),
	%_ClientConfig = [{reconnect_cool_down_seconds, 10}],
	%ok = brod:start_client([{"localhost", 9092}],WorkerId),
    brod:start_producer(brod_client, <<"Vokalanalytics">>, []),
    %KafkaBootstrapEndpoints = [{"localhost", 9092}],
    %ok = brod:start_client(KafkaBootstrapEndpoints, WorkerId),
    ok.	

send(Value) ->
    Key = utils:random(),
    Json = jsx:encode(Value),
    brod:produce(brod_client,
                 <<"Vokalanalytics">>,
                 0,
                 Key,
                 Json).
