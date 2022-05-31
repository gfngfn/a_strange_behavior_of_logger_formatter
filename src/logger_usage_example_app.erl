-module(logger_usage_example_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    logger_usage_example_sup:start_link().

stop(_State) ->
    ok.
