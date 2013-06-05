-module(chat_client).

-export([send_chat_message/3]).

send_chat_message(RouterPid, Addressee, MessageBody) ->
  message_router:send_message(RouterPid, Addressee, MessageBody).
