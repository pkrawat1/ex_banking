defmodule ExBankingTest do
  use ExUnit.Case
  doctest ExBanking

  test "create user" do
    assert ExBanking.Bank.account_exists("new_user") == {:account_exists, false}
    assert ExBanking.create_user("new_user") == :ok
    assert ExBanking.Bank.account_exists("new_user") == {:account_exists, true}
    assert ExBanking.create_user("new_user") == {:error, :user_already_exists}
  end
end
