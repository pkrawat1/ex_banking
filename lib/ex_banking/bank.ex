defmodule ExBanking.Bank do
  @moduledoc """
  Holds Bank Accounts list
  """
  use GenServer

  @process_name __MODULE__

  def start_link(_) do
    GenServer.start_link(@process_name, MapSet.new(), name: @process_name)
  end

  def create_account(user) do
    GenServer.cast(@process_name, {:add, user})
  end

  def account_exists(user) do
    GenServer.call(@process_name, {:exists, user})
  end

  def list_accounts do
    GenServer.call(@process_name, :list)
  end

  # Callbacks

  @impl true
  def init(accounts) do
    {:ok, accounts}
  end

  @impl true
  def handle_call({:exists, user}, _from, accounts) do
    {:reply, {:account_exists, user in accounts, user}, accounts}
  end

  @impl true
  def handle_call(:list, _, accounts) do
    {:reply, accounts, accounts}
  end

  @impl true
  def handle_cast({:add, user}, accounts) do
    {:noreply, MapSet.put(accounts, user)}
  end
end
