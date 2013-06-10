%% P = spawn(message_router, route_messages, [])
%% MFA format: module, function, arguments

-module(message_router).

%% defines a constant to reference the message_router
-define(SERVER, message_router).

-export([send_message/2,route_messages/1, start/1, stop/0]).

start(PrintFun) ->
  Pid = spawn(message_router, route_messages, [PrintFun]),
  erlang:register(?SERVER, Pid),
  Pid.

stop() ->
  ?SERVER ! shutdown.

send_message(Addressee, MessageBody) ->
  ?SERVER ! {send_chat_msg, Addressee, MessageBody}.

route_messages(PrintFun) ->
  receive
    {send_chat_msg, Addressee, MessageBody} ->
      Addressee ! {recv_chat_msg, MessageBody},
      route_messages(PrintFun);
    {recv_chat_msg, MessageBody} ->
      PrintFun(MessageBody);
    shutdown ->
      io:format("Shutting down~n");
    Oops ->
      io:format("Warning! Received: ~p~n", [Oops]),
      route_messages(PrintFun)
  end.
