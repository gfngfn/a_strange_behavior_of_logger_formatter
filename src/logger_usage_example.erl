
-module(logger_usage_example).

-behaviour(gen_server).

-export([start_link/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/1]).

-define(SERVER, ?MODULE).

-define(INTERVAL_MS, 1000).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    {ok, 0, ?INTERVAL_MS}.

handle_call(Req, From, State) ->
    logger:warning("unexpected call (req: ~p)~n", [Req]),
    {reply, unexpected_call, State, ?INTERVAL_MS}.

handle_cast(Msg, State) ->
    logger:warning("unexpected cast (msg: ~p)~n", [Msg]),
    {noreply, State, ?INTERVAL_MS}.

handle_info(timeout, State0) ->
    State1 = State0 + 1,
    case State1 rem 2 of
        0 -> logger:info("count: ~p~n", [State1]);
        _ -> logger:info("count: ~p~n", [State1], #{ message_only => ok })
    end,
    {noreply, State1, ?INTERVAL_MS}.

terminate(State) ->
    logger:warning("terminate (last count: ~p)~n", [State]),
    ok.
