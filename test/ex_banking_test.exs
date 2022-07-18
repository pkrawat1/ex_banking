defmodule ExBankingTest do
  use ExUnit.Case
  doctest ExBanking

  test "create user" do
    assert ExBanking.create_user("new_user") == :ok
    assert ExBanking.Bank.account_exists("new_user")
  end
end
