-module(utils).

-export([random/0]).

random()->
	get_uuid().

get_uuid() ->
    Uuid = uuid:uuid_to_string(uuid:get_v4()),
    re:replace(Uuid, "-", "", [global, {return, binary}]).
