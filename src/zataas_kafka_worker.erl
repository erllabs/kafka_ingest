-module(zataas_kafka_worker).

-behaviour(gen_server).


-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3
         ]).

-export([start_link/0,
         send_event/1
        ]).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

send_event(Event) ->
  wpool:cast(zataas_kafka_pool, {send_event_to_mq, Event}).

init(_Args) ->
  {ok, []}.

handle_call(_, _From, State) ->
  {noreply, State}.

handle_cast({send_event_to_mq, Event}, State) ->
  zataas_kafka_brod_if:send(Event),
  {noreply, State};

handle_cast(stop, State) ->
    {stop, normal, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_, State) ->
  {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

terminate(normal, _State) ->
  ok.











% -export([start_link/1]).

% %% gen_server callbacks
% -export([init/1,
%          handle_call/3,
%          handle_cast/2,
%          handle_info/2,
%          terminate/2,
%          code_change/3]).

% -define(MQ_TABLE,mq_pool_table).

% -record(state,{
% 	worker_id
% 	}).


% start_link(I)->
% 	gen_server:start_link({local,I},?MODULE,[I],[]).


% %%exported functions
% send_event_to_mq(Event)->
% 	case get_worker_id() of 
% 	gen_server:handle_call()

% %%Init() callback module
% init(WorkerId)->
% 	%start_connector(WorkerId),
% 	ets:insert(?MQ_TABLE,{WorkerId,self()}),
% 	%If the process registred globally then we can access it with its name
% 	%TODO:remove the ets for pooling the mq pids
% 	{ok,#state{worker_id=WorkerId}}.

% %%--------------------------------------------------------------------
% %% @private
% %% @doc
% %% Handling call messages
% %%
% %% @spec handle_call(Request, From, State) ->
% %%                                   {reply, Reply, State} |
% %%                                   {reply, Reply, State, Timeout} |
% %%                                   {noreply, State} |
% %%                                   {noreply, State, Timeout} |
% %%                                   {stop, Reason, Reply, State} |
% %%                                   {stop, Reason, State}
% %% @end
% %%--------------------------------------------------------------------
% handle_call(_Request, _From, State) ->
%     {reply, ok, State}.
 
% %%--------------------------------------------------------------------
% %% @private
% %% @doc
% %% Handling cast messages
% %%
% %% @spec handle_cast(Msg, State) -> {noreply, State} |
% %%                                  {noreply, State, Timeout} |
% %%                                  {stop, Reason, State}
% %% @end
% %%--------------------------------------------------------------------
% handle_cast(_Request, State) ->
%     {noreply, State}.

% %%--------------------------------------------------------------------
% %% @private
% %% @doc
% %% Handling all non call/cast messages
% %%
% %% @spec handle_info(Info, State) -> {noreply, State} |
% %%                                   {noreply, State, Timeout} |
% %%                                   {stop, Reason, State}
% %% @end
% %%--------------------------------------------------------------------
% handle_info(_Info, State) ->
%     {noreply, State}.

% %%--------------------------------------------------------------------
% %% @private
% %% @doc
% %% This function is called by a gen_server when it is about to
% %% terminate. It should be the opposite of Module:init/1 and do any
% %% necessary cleaning up. When it returns, the gen_server terminates
% %% with Reason. The return value is ignored.
% %%
% %% @spec terminate(Reason, State) -> void()
% %% @end
% %%--------------------------------------------------------------------
% terminate(_Reason, _State) ->
%      ets:delete(?MQ_TABLE,self()),
%     ok.

% %%--------------------------------------------------------------------
% %% @private
% %% @doc
% %% Convert process state when code is changed
% %%
% %% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
% %% @end
% %%--------------------------------------------------------------------
% code_change(_OldVsn, State, _Extra) ->
%     {ok, State}.

% %%%===================================================================
% %%% Internal functions
% %%%===================================================================

% start_connector(WorkerId)->
% 	io:format("The start_connector- worker_id:~p",[WorkerId]),
% 	zataas_kafka_brod_if:start(WorkerId).

