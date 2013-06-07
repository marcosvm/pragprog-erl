%% P = spawn(message_router, route_messages, [])
%% MFA format: module, function, arguments

-module(message_router).

-export([send_message/3,route_messages/1, start/1, stop/1]).

start(PrintFun) ->
  spawn(message_router, route_messages, [PrintFun]).

stop(RouterPid) ->
  RouterPid ! shutdown.

send_message(RouterPid, Addressee, MessageBody) ->
  RouterPid ! {send_chat_msg, Addressee, MessageBody}.

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
