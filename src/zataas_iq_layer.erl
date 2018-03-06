-module(zataas_iq_layer).

-export([init_tables/0,create_tables/0]).

-export([push_to_iq/1]).

-record(iq_events_table,{
			event_id,
			timestamp,
			payload
	}).

init_tables()->
	mnesia:stop(),
	case mnesia:create_schema([node()]) of
		ok ->
			io:format("in the atomic"),
			mnesia:start(),
			create_tables(),
			{ok,created_tables};
		_ ->
			io:format("in default"),
			mnesia:start(),
			{ok,tables_are_already_exist}
	end.

create_tables()->
	mnesia:create_table(iq_events_table,
                         [
                          {index, []},
                          {type, bag},
                          {disc_copies, [node()]},
                          {attributes, record_info(fields,
						   iq_events_table)}]).

push_to_iq(Event)->
	Rec = #iq_events_table{
							event_id = utils:random(),
							timestamp = os:system_time(),
							payload = Event },
	zataas_mnesia_if:write(Rec).

run_events_from_iq()->
	Events = zataas_mnesia_if:read_all(iq_events_table),
	clear_iq_layer(),
	[zataas_kafka_brod_if:send(X)|| {_,_,X} <- Events].

clear_iq_layer()->
	zataas_mnesia_if:delete_all().