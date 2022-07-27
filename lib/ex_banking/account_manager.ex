defmodule ExBanking.AccountManager do
  @moduledoc """
  Dynamic worker handler to keep individual accounts live and manage
  """

  use DynamicSupervisor

  alias ExBanking.Account

  @process_name __MODULE__

  def start_link(_) do
    DynamicSupervisor.start_link(@process_name, [], name: @process_name)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def new_account(user) do
    DynamicSupervisor.start_child(@process_name, {Account, user})
  end
end
