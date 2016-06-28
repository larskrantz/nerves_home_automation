defmodule NervesHomeAutomation.Simple433.TransmitterCode do
  @maxpossibleaddress 0b11111111111111111111111111

  @moduledoc """
    Handles the 26-bit transmitter-codes
  """

  @doc """
    Converts an integer transmitter-code to a bitlist

    iex> NervesHomeAutomation.Simple433.TransmitterCode.to_bit_list(39291)
    {:ok, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1]}
  """
  def to_bit_list(code) when is_integer(code) and code > 0 and code <= @maxpossibleaddress do
    transmitter_code = code
    |> Integer.digits(2)
    |> fill_up_to_26_bits

    {:ok, transmitter_code}
  end
  def to_bit_list(_) do
    {:error, "not a valid code, must be a positive integer equal or less to #{@maxpossibleaddress}."}
  end

  defp fill_up_to_26_bits(list) when length(list) == 26, do: list
  defp fill_up_to_26_bits(list) do
    diff = 26 - length(list)
    List.duplicate(0, diff) ++ list
  end
end
