defmodule ExBanking.Validation do
  def valid_user?(user), do: is_bitstring(user)
  def valid_currency?(currency), do: is_bitstring(currency)

  def valid_arguments?(user, currency) do
    valid_user?(user) && valid_currency?(currency)
  end

  def can_withdraw?(account, currency, amount) do
    Decimal.compare(account[currency] || 0, amount) != :lt
  end
end
