This small application exemplifies a somewhat strange behavior of `logger_formatter`. It just counts up a number and emits logs every second.

The application has the following configuration for `config/sys.config`:

```erlang
[
    {kernel, [
        {logger_level, debug},
        {logger, [
            {handler, default, logger_std_h, #{
                formatter =>
                    {logger_formatter, #{
                        template =>
                            %% The following does NOT work as intended:
                            [
                                {message_only,
                                    ["*", msg, "\n"],
                                    [time, " [", level, "] ", file, ":", line, " ", pid, " ", msg, "\n"]
                                }
                            ]
                            %% while the following does work:
                            %[
                            %   {message_only,
                            %       ["*"],
                            %       [time, " [", level, "] ", file, ":", line, " ", pid, " "]
                            %   },
                            %   msg, "\n"
                            %]
                    }}
            }}
        ]}
    ]}
].
```

As commented above, using the former list for the logger template does NOT work as intended, while the latter one does.

You can compile and run this application by:

```console
$ rebar3 shell
```

and can see how logs are emitted. Using the former one, logs look like:

```console
*
2022-05-31T09:58:33.889089+09:00 [info] : <0.142.0>
*
2022-05-31T09:58:35.890979+09:00 [info] : <0.142.0>
*
2022-05-31T09:58:37.892774+09:00 [info] : <0.142.0>
*
2022-05-31T09:58:39.894887+09:00 [info] : <0.142.0>
```

that is, `msg` is substituted with empty strings.

On the other hand, the latter template produces logs that look like:

```console
*count: 1
2022-05-31T10:00:48.543986+09:00 [info] : <0.142.0> count: 2
*count: 3
2022-05-31T10:00:50.545941+09:00 [info] : <0.142.0> count: 4
*count: 5
2022-05-31T10:00:52.547992+09:00 [info] : <0.142.0> count: 6
*count: 7
```

which reflects the intention correctly.
