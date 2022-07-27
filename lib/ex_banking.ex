defmodule ExBanking do
  @moduledoc """
  Documentation for `ExBanking`.
  """
  alias ExBanking.Type
  alias ExBanking.Bank
  alias ExBanking.Account
  alias ExBanking.AccountManager

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
  def create_user(user) when is_bitstring(user) do
    with {:account_exists, false, _} <- Bank.account_exists(user),
         :ok <- Bank.create_account(user),
         {:ok, _} <- AccountManager.new_account(user) do
      :ok
    else
      _ -> {:error, :user_already_exists}
    end
  end

  def create_user(_), do: {:error, :wrong_arguments}

  @doc """
  Increases user’s balance in given currency by amount value
  Returns new_balance of the user in given format
  """
  @spec deposit(user :: String.t(), amount :: number, currency :: String.t()) ::
          {:ok, new_balance :: number} | {:error, Type.error_code()}
  def deposit(user, amount, currency)
      when is_bitstring(user) and is_bitstring(currency) and amount > 0 do
    with {:account_exists, true, _} <- Bank.account_exists(user),
         {:ok, balance} <- Account.deposit(user, amount, currency) do
      {:ok, balance}
    else
      {:account_exists, false, _} -> {:error, :user_does_not_exist}
      :too_many_requests_to_user -> {:error, :too_many_requests_to_user}
    end
  end

  def deposit(_, _, _), do: {:error, :wrong_arguments}

  @doc """
  Decreases user’s balance in given currency by amount value
  Returns new_balance of the user in given format
  """
  @spec withdraw(user :: String.t(), amount :: number, currency :: String.t()) ::
          {:ok, new_balance :: number} | {:error, Type.error_code()}
  def withdraw(user, amount, currency)
      when is_bitstring(user) and is_bitstring(currency) and amount > 0 do
    with {:account_exists, true, _} <- Bank.account_exists(user),
         {:ok, balance} <- Account.withdraw(user, amount, currency) do
      {:ok, balance}
    else
      {:account_exists, false, _} -> {:error, :user_does_not_exist}
      :not_enough_money -> {:error, :not_enough_money}
      :too_many_requests_to_user -> {:error, :too_many_requests_to_user}
    end
  end

  def withdraw(_, _, _), do: {:error, :wrong_arguments}

  @doc """
  Returns balance of the user in given format
  """
  @spec get_balance(user :: String.t(), currency :: String.t()) ::
          {:ok, balance :: number} | {:error, Type.error_code()}
  def get_balance(user, currency) when is_bitstring(user) and is_bitstring(currency) do
    with {:account_exists, true, _} <- Bank.account_exists(user),
         {:ok, balance} <- Account.account_balance(user, currency) do
      {:ok, balance}
    else
      {:account_exists, false, _} -> {:error, :user_does_not_exist}
      :too_many_requests_to_user -> {:error, :too_many_requests_to_user}
    end
  end

  def get_balance(_, _), do: {:error, :wrong_arguments}

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
  def send(from_user, to_user, amount, currency)
      when is_bitstring(from_user) and is_bitstring(currency) and from_user !== to_user and
             is_bitstring(to_user) and
             amount > 0 do
    with {:account_exists, true, _} <- Bank.account_exists(from_user),
         {:account_exists, true, _} <- Bank.account_exists(to_user),
         {:ok, from_user_balance, to_user_balance} <-
           Account.fund_transfer(from_user, to_user, amount, currency) do
      {:ok, from_user_balance, to_user_balance}
    else
      {:account_exists, false, ^from_user} -> {:error, :sender_does_not_exist}
      {:account_exists, false, ^to_user} -> {:error, :receiver_does_not_exist}
      :too_many_requests_to_user -> {:error, :too_many_requests_to_sender}
      :too_many_requests_to_receiver -> {:error, :too_many_requests_to_receiver}
    end
  end

  def send(_, _, _, _), do: {:error, :wrong_arguments}
end
