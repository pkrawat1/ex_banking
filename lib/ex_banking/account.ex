defmodule ExBanking.Account do
  @moduledoc """
  Holds Customer Account
  """
  use GenServer

  @process_name __MODULE__

  def start_link(user) do
    GenServer.start_link(@process_name, %{"default" => 0}, name: user)
  end

  def account_balance(name, currency) do
    GenServer.call(name, {:balance, currency})
  end

  # Callbacks
  
  @impl true
  def init(account) do
    {:ok, account}
  end

  @impl true
  def handle_call({:balance, currency}, _from, account) do
    {:reply, {:ok, account[currency]}, account}
  end
end
