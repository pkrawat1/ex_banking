defmodule ExBanking.Validation do
  def valid_user?(user), do: is_bitstring(user)
  def valid_currency?(currency), do: is_bitstring(currency)
end
