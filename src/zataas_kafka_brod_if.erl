-module(zataas_kafka_brod_if).

-export([start/0,send/2]).

start() ->
	brod:start_producer(brod_client, <<"Vokalanalytics">>, []),
    ok.	

send(Value,Topic) ->
	Key = utils:random(),
    Json = jsx:encode(Value),
    {ok,Topics} = application:get_env(zataas,kafka_topics),
    {ok,Index} = application:get_env(zataas,kafka_key),
    Index1 = proplists:get_value(Index,Value,0),
    TotalP = proplists:get_value(Topic,Topics),
    Partition = erlang:phash2(Index1,TotalP),
    brod:produce(brod_client,
		                 Topic,
		                 Partition,
		                 Key,
		                 Json),
    ok.
			
 %    case erlang:get(kafka_brod_client) of
 %    	true ->
	% 	    try    
	% 	    	brod:produce(brod_client,
	% 	                 Topic,
	% 	                 Partition,
	% 	                 Key,
	% 	                 Json) of
	% 	    	_ ->
	% 	    		ok    	
	% 	    catch 
	% 	    	_:_ ->
	% 	    		%erlang:put(kafka_brod_client,false),
	% 	    		zataas_iq_layer:push_to_queue(Value),
	% 	    		zataas_mail_if:inform_devops(<<"kafka Connection Down">>),
	% 	    		ok
	% 	    end;
	% 	_ ->
	% 		brod:produce(brod_client,
	% 	                 Topic,
	% 	                 Partition,
	% 	                 Key,
	% 	                 Json)
	% 		%zataas_iq_layer:push_to_iq(Value),
	% 		ok
	% end.
