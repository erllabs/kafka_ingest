%%%-------------------------------------------------------------------
%% @doc zataas top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(zataas_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

-define(CHILD(I,Type,Args),{I,{I,start_link,Args},
	permanent,5000,Type,[I]}).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    ElliOpts = [{callback, zataas_http_handler}, {port, 3000}],
    ElliSpec = {
        zataas_http_handler,
        {elli, start_link, [ElliOpts]},
        permanent,
        5000,
        worker,
        [elli]},

    {ok, { {one_for_one, 5, 10}, [
    		ElliSpec,
    		?CHILD(zataas_kafka,worker,[])
    		]} }.

%%====================================================================
%% Internal functions
%%====================================================================
