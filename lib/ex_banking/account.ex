defmodule ExBanking.Account do
  @moduledoc """
  Holds Customer Account
  """
  use GenServer

  @process_name __MODULE__

  def start_link(user) do
    GenServer.start_link(@process_name, %{"default" => 0.00}, name: user)
  end

  def account_balance(name, currency) do
    GenServer.call(:"#{name}", {:balance, currency})
  end

  def deposit(name, amount, currency) do
    GenServer.call(:"#{name}", {:deposit, currency, amount})
  end

  # Callbacks

  @impl true
  def init(account) do
    {:ok, account}
  end

  @impl true
  def handle_call({:balance, currency}, _from, account) do
    {:reply, {:ok, money_format(account[currency])}, account}
  end

  @impl true
  def handle_call({:deposit, currency, amount}, _from, account) do
    updated_account = Map.merge(account, %{currency => Decimal.add(account[currency] || 0, amount)})
    {:reply, {:ok, money_format(updated_account[currency]) }, updated_account}
  end

  defp money_format(money), do: Decimal.new("#{money || 0}") |> Decimal.to_float |> Float.round(2)
end
