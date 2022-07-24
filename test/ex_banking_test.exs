defmodule ExBankingTest do
  use ExUnit.Case
  doctest ExBanking

  setup_all do
    assert ExBanking.create_user("user1") == :ok
    assert ExBanking.create_user("user2") == :ok
    :ok
  end

  test "create user" do
    assert ExBanking.Bank.account_exists("new_user") == {:account_exists, false}
    assert ExBanking.create_user("new_user") == :ok
    assert ExBanking.Bank.account_exists("new_user") == {:account_exists, true}
    assert ExBanking.create_user("new_user") == {:error, :user_already_exists}
  end

  test "deposit money" do
    assert ExBanking.deposit("user1", 20, "usd") == {:ok, 20.0}
    assert ExBanking.get_balance("user1", "usd") == {:ok, 20.0}
    assert ExBanking.get_balance("user1", "inr") == {:ok, 0.0}
  end

  test "withdraw money" do
    assert ExBanking.withdraw("user1", 2, "usd") == {:ok, 18.0}
    assert ExBanking.get_balance("user1", "usd") == {:ok, 18.0}
  end
end
