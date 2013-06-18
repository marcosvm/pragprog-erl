-module(chat_client).

-export([handle_messages/1, unregister_nickname/1, register_nickname/1, send_message/2, start_router/0]).

register_nickname(Nickname) ->
  Pid = spawn(chat_client, handle_messages, [Nickname]),
  message_router:register_nick(Nickname, Pid).

unregister_nickname(Nickname) ->
  message_router:unregister_nick(Nickname).

send_message(Addressee, MessageBody) ->
  message_router:send_message(Addressee, MessageBody).

handle_messages(Nickname) ->
  receive
    {print_msg, MessageBody} ->
      io:format("~p received: ~p~n", [Nickname, MessageBody]),
      handle_messages(Nickname);
    stop ->
      ok
  end.

start_router() ->
  message_router:start().
