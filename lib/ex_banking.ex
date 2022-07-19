defmodule ExBanking do
  @moduledoc """
  Documentation for `ExBanking`.
  """
  alias ExBanking.Type
  alias ExBanking.Bank
  alias ExBanking.Account
  alias ExBanking.AccountManager
  alias ExBanking.Validation

  @doc """
  Function creates new user in the system
  New user has zero balance of any currency

  ## Examples

      iex> ExBanking.create_user("new")
      :ok
      iex> ExBanking.create_user("new")
      {:error, :user_already_exists}
      iex> ExBanking.create_user(1)
      {:error, :wrong_arguments}

  """
  @spec create_user(user :: String.t()) :: :ok | {:error, Type.error_code()}
  def create_user(user) do
    with true <- Validation.valid_user?(user),
         {:account_exists, false} <- Bank.account_exists(user),
         :ok <- Bank.create_account(user),
         {:ok, _} <- AccountManager.new_account(user) do
      :ok
    else
      false -> {:error, :wrong_arguments}
      {:account_exists, true} -> {:error, :user_already_exists}
    end
  end

  @doc """
  Increases user’s balance in given currency by amount value
  Returns new_balance of the user in given format
  """
  @spec deposit(user :: String.t(), amount :: number, currency :: String.t()) ::
          {:ok, new_balance :: number} | {:error, Type.error_code()}
  def deposit(user, amount, currency) do
    with true <- Validation.valid_arguments?(user, currency),
         {:account_exists, true} <- Bank.account_exists(user) do
      Account.deposit(user, amount, currency)
    else
      false -> {:error, :wrong_arguments}
      {:account_exists, false} -> {:error, :user_does_not_exist}
    end
  end

  @doc """
  Decreases user’s balance in given currency by amount value
  Returns new_balance of the user in given format
  """
  @spec withdraw(user :: String.t(), amount :: number, currency :: String.t()) ::
          {:ok, new_balance :: number} | {:error, Type.error_code()}
  def withdraw(user, amount, currency) do
  end

  @doc """
  Returns balance of the user in given format
  """
  @spec get_balance(user :: String.t(), currency :: String.t()) ::
          {:ok, balance :: number} | {:error, Type.error_code()}
  def get_balance(user, currency) do
    with true <- Validation.valid_arguments?(user, currency),
         {:account_exists, true} <- Bank.account_exists(user) do
      Account.account_balance(user, currency)
    else
      false -> {:error, :wrong_arguments}
      {:account_exists, false} -> {:error, :user_does_not_exist}
    end
  end

  @doc """
  Decreases from_user’s balance in given currency by amount value
  Increases to_user’s balance in given currency by amount value
  Returns balance of from_user and to_user in given format
  """
  @spec send(
          from_user :: String.t(),
          to_user :: String.t(),
          amount :: number,
          currency :: String.t()
        ) ::
          {:ok, from_user_balance :: number, to_user_balance :: number}
          | {:error, Type.error_code()}
  def send(from_user, to_user, amount, currency) do
  end
end
