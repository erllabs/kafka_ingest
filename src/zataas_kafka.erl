-module(zataas_kafka).

-export([
         start_link/0,
         send_event_to_mq/1
        ]).

start_link() ->
    ok = zataas_kafka_brod_if:start(),
    {ok,_} = zataas_iq_layer:init_tables(),
    {ok,WorkersAmount} = application:get_env(zataas,kafka_workers_amount),
    wpool:start_pool(
        zataas_kafka_pool,
        [{workers, WorkersAmount}, {worker, {zataas_kafka_worker, []}}]
    ).

send_event_to_mq(Event) ->
    zataas_kafka_worker:send_event(Event).


