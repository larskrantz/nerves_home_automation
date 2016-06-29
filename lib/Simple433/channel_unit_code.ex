defmodule NervesHomeAutomation.Simple433.ChannelUnitCode do

  @moduledoc """
    Creates the channel and unit-codes based on brand and unit-number
    Channel for Proove and Anslut is 00
    Channel for Nexa is 11
    Unit bits = device to be turned on or off:
    Proove/Anslut Unit #1 = 00, #2 = 01, #3 = 10.
    Nexa Unit #1 = 11, #2 = 10, #3 = 01.

    Datastream format is CCUU (2 bits for channel followed by 2 bits for unit)

    iex> NervesHomeAutomation.Simple433.ChannelUnitCode.to_datastream(:nexa, 2)
    {:ok, [1, 1, 1, 0]}

    iex> NervesHomeAutomation.Simple433.ChannelUnitCode.to_datastream(:nexa, 1)
    {:ok, [1, 1, 1, 1]}

    iex> NervesHomeAutomation.Simple433.ChannelUnitCode.to_datastream(:proove, 3)
    {:ok, [0, 0, 1, 0]}

    iex> NervesHomeAutomation.Simple433.ChannelUnitCode.to_datastream(:anslut, 3)
    {:ok, [0, 0, 1, 0]}

    iex> NervesHomeAutomation.Simple433.ChannelUnitCode.to_datastream(:anslut, 2)
    {:ok, [0, 0, 0, 1]}

    iex> NervesHomeAutomation.Simple433.ChannelUnitCode.to_datastream(:anslut, 1)
    {:ok, [0, 0, 0, 0]}

    iex> NervesHomeAutomation.Simple433.ChannelUnitCode.to_datastream(:anslut, 0)
    {:error, "Unsupported brand or unit"}
  """

  def to_datastream(:nexa, 1), do: {:ok, [1, 1, 1, 1]}
  def to_datastream(:nexa, 2), do: {:ok, [1, 1, 1, 0]}
  def to_datastream(:nexa, 3), do: {:ok, [1, 1, 0, 1]}
  def to_datastream(:proove, 1), do: {:ok, [0, 0, 0, 0]}
  def to_datastream(:proove, 2), do: {:ok, [0, 0, 0, 1]}
  def to_datastream(:proove, 3), do: {:ok, [0, 0, 1, 0]}
  def to_datastream(:anslut, unit), do: to_datastream(:proove, unit)
  def to_datastream(_,_), do: {:error, "Unsupported brand or unit"}

  def to_datastream!(brand, code) do
    {:ok, datastream} = to_datastream(brand, code)
    datastream
  end
 end
