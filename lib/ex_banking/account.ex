defmodule ExBanking.Account do
  @moduledoc """
  Holds Customer Account
  """
  use GenServer
  alias ExBanking.Validation

  @process_name __MODULE__
  @action_timeout 100
  @max_operations 10
  @pending_operations "pending_operations"

  def start_link(user) do
    GenServer.start_link(
      @process_name,
      %{"default" => 0.00, @pending_operations => 0, "user" => user},
      name: :"#{user}"
    )
  end

  def account_balance(name, currency) do
    GenServer.call(:"#{name}", {:balance, currency})
  end

  def deposit(name, amount, currency) do
    GenServer.call(:"#{name}", {:deposit, currency, amount})
  end

  def withdraw(name, amount, currency) do
    GenServer.call(:"#{name}", {:withdraw, currency, amount})
  end

  def fund_transfer(from_user, to_user, amount, currency) do
    GenServer.call(:"#{from_user}", {:fund_transfer, to_user, currency, amount})
  end

  # Callbacks

  @impl true
  def init(account) do
    {:ok, account}
  end

  @impl true
  def handle_call({:balance, currency}, _from, account = %{@pending_operations => ops})
      when ops < @max_operations do
    start_operation_callback()
    updated_account = Map.update(account, @pending_operations, 1, &(&1 + 1))
    {:reply, {:ok, money_format(updated_account[currency])}, updated_account}
  end

  @impl true
  def handle_call({:deposit, currency, amount}, _from, account = %{@pending_operations => ops})
      when ops < @max_operations do
    start_operation_callback()

    updated_account =
      account
      |> Map.update(currency, amount, &Decimal.add(&1 || 0, amount))
      |> Map.update(@pending_operations, 0, &(&1 + 1))

    {:reply, {:ok, money_format(updated_account[currency])}, updated_account}
  end

  @impl true
  def handle_call({:withdraw, currency, amount}, _from, account = %{@pending_operations => ops})
      when ops < @max_operations do
    start_operation_callback()

    with true <- Validation.can_withdraw?(account, currency, amount) do
      updated_account =
        account
        |> Map.update(currency, amount, &Decimal.sub(&1 || 0, amount))
        |> Map.update(@pending_operations, 0, &(&1 + 1))

      {:reply, {:ok, money_format(updated_account[currency])}, updated_account}
    else
      false -> {:reply, :not_enough_money, account}
    end
  end

  @impl true
  def handle_call({:fund_transfer, to_user, currency, amount}, _from, account = %{@pending_operations => ops}) when ops < @max_operations do
    start_operation_callback()

    with true <- Validation.can_withdraw?(account, currency, amount),
         {:ok, to_user_balance} <- deposit(to_user, amount, currency) do
      updated_account =
        account
        |> Map.update(currency, amount, &Decimal.sub(&1 || 0, amount))
        |> Map.update(@pending_operations, 0, &(&1 + 1))

      {:reply, {:ok, money_format(updated_account[currency]), to_user_balance}, updated_account}
    else
      false -> {:reply, :not_enough_money, account}
      :too_many_requests_to_user -> {:reply, :too_many_requests_to_receiver, account}
    end
  end

  @impl true
  def handle_call(_, _, account), do: {:reply, :too_many_requests_to_user, account}

  @impl true
  def handle_info(:reduce_pending_operations, account),
    do: {:noreply, Map.update(account, @pending_operations, 0, &(&1 - 1))}

  defp start_operation_callback(),
    do: Process.send_after(self(), :reduce_pending_operations, @action_timeout)

  defp money_format(money),
    do: Decimal.new("#{money || 0}") |> Decimal.to_float() |> Float.round(2)
end
