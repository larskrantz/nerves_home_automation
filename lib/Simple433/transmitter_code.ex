defmodule NervesHomeAutomation.Simple433.TransmitterCode do
  @maxpossibleaddress 0b11111111111111111111111111

  @moduledoc """
    Handles the 26-bit transmitter-codes
  """

  @doc """
    Converts an integer transmitter-code to a bitlist.
    Datastream is encoded to 2 bits, where the first bit is the data bit, and second bit is the first inverted.
    So [0,1] will be encoded to [0,1,1,0]

    iex> NervesHomeAutomation.Simple433.TransmitterCode.to_datastream(39291)
    {:ok, [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0]}
  """
  def to_datastream(code) when is_integer(code) and code > 0 and code <= @maxpossibleaddress do
    transmitter_code = code
    |> Integer.digits(2)
    |> fill_up_to_26_bits
    |> to_send_data
    {:ok, transmitter_code}
  end
  def to_datastream(_) do
    {:error, "not a valid code, must be a positive integer equal or less to #{@maxpossibleaddress}."}
  end

  defp to_send_data(bitlist), do: to_send_data(bitlist, [])
  defp to_send_data([], state), do: state
  defp to_send_data([0 | rest], state), do: to_send_data(rest, state ++ [0, 1])
  defp to_send_data([1 | rest], state), do: to_send_data(rest, state ++ [1, 0])

  defp fill_up_to_26_bits(list) when length(list) == 26, do: list
  defp fill_up_to_26_bits(list) do
    diff = 26 - length(list)
    List.duplicate(0, diff) ++ list
  end
end
