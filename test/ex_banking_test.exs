defmodule ExBankingTest do
  use ExUnit.Case
  doctest ExBanking, async: false

  test "create user" do
    assert ExBanking.Bank.account_exists("new_user") == {:account_exists, false}
    assert ExBanking.create_user("new_user") == :ok
    assert ExBanking.Bank.account_exists("new_user") == {:account_exists, true}
    assert ExBanking.create_user("new_user") == {:error, :user_already_exists}
  end

  test "deposit money" do
    assert ExBanking.create_user("deposit_user") == :ok
    assert ExBanking.deposit("deposit_user", 20, "usd") == {:ok, 20.0}
    assert ExBanking.get_balance("deposit_user", "usd") == {:ok, 20.0}
    assert ExBanking.get_balance("deposit_user", "inr") == {:ok, 0.0}
  end

  test "withdraw money" do
    assert ExBanking.create_user("withdraw_user") == :ok
    assert ExBanking.deposit("withdraw_user", 20, "usd") == {:ok, 20.0}
    assert ExBanking.withdraw("withdraw_user", 2, "usd") == {:ok, 18.0}
    assert ExBanking.get_balance("withdraw_user", "usd") == {:ok, 18.0}
  end

  test "too_many_requests_to_user" do
    assert ExBanking.create_user("too_many_requests_to_user") == :ok
    Enum.each(0..9, fn _ -> ExBanking.get_balance("too_many_requests_to_user", "usd") end)

    assert ExBanking.get_balance("too_many_requests_to_user", "usd") ==
             {:error, :too_many_requests_to_user}
  end
end
