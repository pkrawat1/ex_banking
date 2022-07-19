defmodule ExBankingTest do
  use ExUnit.Case
  doctest ExBanking

  test "create user" do
    assert ExBanking.Bank.account_exists("new_user") == {:account_exists, false}
    assert ExBanking.create_user("new_user") == :ok
    assert ExBanking.Bank.account_exists("new_user") == {:account_exists, true}
    assert ExBanking.create_user("new_user") == {:error, :user_already_exists}
    assert ExBanking.deposit("new_user", 20, "usd") == {:ok, 20.0}
    assert ExBanking.get_balance("new_user", "usd") == {:ok, 20.0}
    assert ExBanking.get_balance("new_user", "inr") == {:ok, 0.0}
  end
end
