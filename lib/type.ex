defmodule ExBanking.Type do
  @type error_code ::
          :wrong_arguments
          | :user_already_exists
          | :user_does_not_exist
          | :too_many_requests_to_user
          | :not_enough_money
          | :sender_does_not_exist
          | :receiver_does_not_exist
          | :too_many_requests_to_sender
          | :too_many_requests_to_receiver
end
