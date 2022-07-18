defmodule ExBanking do
  @moduledoc """
  Documentation for `ExBanking`.
  """
  alias ExBanking.Type
  alias ExBanking.Bank

  @doc """
  Function creates new user in the system
  New user has zero balance of any currency

  ## Examples

      iex> ExBanking.create_user("new")
      :ok

  """
  @spec create_user(user :: String.t) :: :ok | {:error, Type.error_code}
  def create_user(user) do
    Bank.create_account(user)
  end

  @doc """
  Increases user’s balance in given currency by amount value
  Returns new_balance of the user in given format
  """
  @spec deposit(user :: String.t, amount :: number, currency :: String.t) :: {:ok, new_balance :: number} | {:error, Type.error_code}
  def deposit(user, amount, currency) do
  end

  @doc """
  Decreases user’s balance in given currency by amount value
  Returns new_balance of the user in given format
  """
  @spec withdraw(user :: String.t, amount :: number, currency :: String.t) :: {:ok, new_balance :: number} | {:error, Type.error_code}
  def withdraw(user, amount, currency) do
  end

  @doc """
  Returns balance of the user in given format
  """
  @spec get_balance(user :: String.t, currency :: String.t) :: {:ok, balance :: number} | {:error, Type.error_code}
  def get_balance(user, currency) do
  end

  @doc """
  Decreases from_user’s balance in given currency by amount value
  Increases to_user’s balance in given currency by amount value
  Returns balance of from_user and to_user in given format
  """
  @spec send(from_user :: String.t, to_user :: String.t, amount :: number, currency :: String.t) :: {:ok, from_user_balance :: number, to_user_balance :: number} | {:error, Type.error_code}
  def send(from_user, to_user, amount, currency) do
  end
end
