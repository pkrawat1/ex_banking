defmodule ExBanking.Validation do
  @moduledoc """
  Custom validations
  """
  def can_withdraw?(balance, amount) do
    Decimal.compare(balance, amount) != :lt
  end
end
