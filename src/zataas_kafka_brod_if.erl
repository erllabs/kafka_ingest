-module(zataas_kafka_brod_if).

-export([start/0,send/1]).

start() ->
	brod:start_producer(brod_client, <<"Vokalanalytics">>, []),
    ok.	

send(Value) ->
    Key = utils:random(),
    Json = jsx:encode(Value),
    case erlang:get(kafka_brod_client) of
    	true ->
		    try    
		    	brod:produce(brod_client,
		                 <<"Vokalanalytics">>,
		                 0,
		                 Key,
		                 Json) of
		    	_ ->
		    		ok    	
		    catch 
		    	_:_ ->
		    		erlang:put(kafka_brod_client,false),
		    		zataas_iq_layer:push_to_queue(Value),
		    		zataas_mail_if:inform_devops(<<"kafka Connection Down">>),
		    		ok
		    end;
		_ ->
			zataas_iq_layer:push_to_iq(Value),
			ok
	end.
