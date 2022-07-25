defmodule ExBankingTest do
  use ExUnit.Case
  doctest ExBanking, async: false

  test "create user" do
    assert ExBanking.Bank.account_exists("new_user") == {:account_exists, false, "new_user"}
    assert ExBanking.create_user("new_user") == :ok
    assert ExBanking.Bank.account_exists("new_user") == {:account_exists, true, "new_user"}
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
    assert ExBanking.withdraw("withdraw_user", 20, "usd") == {:error, :not_enough_money}
  end

  test "too_many_requests_to_user" do
    assert ExBanking.create_user("too_many_requests_to_user") == :ok
    Enum.each(0..9, fn _ -> ExBanking.get_balance("too_many_requests_to_user", "usd") end)

    assert ExBanking.get_balance("too_many_requests_to_user", "usd") ==
             {:error, :too_many_requests_to_user}
  end

  test "fund transfer" do
    assert ExBanking.create_user("from_user") == :ok
    assert ExBanking.create_user("to_user") == :ok
    assert ExBanking.deposit("from_user", 20, "usd") == {:ok, 20.0}
    assert ExBanking.send("from_user", "to_user", 10, "usd") == {:ok, 10.0, 10.0}

    Enum.each(0..9, fn _ -> ExBanking.get_balance("from_user", "usd") end)

    assert ExBanking.send("from_user", "to_user", 10, "usd") ==
             {:error, :too_many_requests_to_sender}

    :timer.sleep(100)

    Enum.each(0..9, fn _ -> ExBanking.get_balance("to_user", "usd") end)

    assert ExBanking.send("from_user", "to_user", 10, "usd") ==
             {:error, :too_many_requests_to_receiver}

    :timer.sleep(100)
    assert ExBanking.get_balance("from_user", "usd") == {:ok, 10.0}
    assert ExBanking.get_balance("to_user", "usd") == {:ok, 10.0}
  end
end
