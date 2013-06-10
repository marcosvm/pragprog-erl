-module(chat_client).

-export([send_message/2, print_message/1, start_router/0]).

send_message(Addressee, MessageBody) ->
  message_router:send_message(Addressee, MessageBody).

print_message(MessageBody) ->
  io:format("Received: ~p~n", [MessageBody]).

start_router() ->
  message_router:start(fun chat_client:print_message/1).
