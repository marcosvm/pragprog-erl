%% P = spawn(message_router, route_messages, [])
%% MFA format: module, function, arguments

-module(message_router).

-export([send_message/3,route_messages/0, start/0, stop/1]).

start() ->
  spawn(message_router, route_messages, []).

stop(RouterPid) ->
  RouterPid ! shutdown.

send_message(RouterPid, Addressee, MessageBody) ->
  RouterPid ! {send_chat_msg, Addressee, MessageBody}.

route_messages() ->
  receive
    {send_chat_msg, Addressee, MessageBody} ->
      Addressee ! {recv_chat_msg, MessageBody};
    {recv_chat_msg, MessageBody} ->
      io:format("Received: ~p~n", [MessageBody]);
    shutdown ->
      io:format("Shutting down~n");
    Oops ->
      io:format("Warning! Received: ~p~n", [Oops]),
      route_messages()
  end.
