defmodule NervesHomeAutomation.Simple433.PacketFactory do
  alias NervesHomeAutomation.Simple433.{Command, Transmitter, TransmitterCode, Receiver, State, ChannelUnitCode}
  @moduledoc """
    Creates full data-packets for sending out data, including pauses according to
    http://tech.jolowe.se/home-automation-rf-protocols/

    Packetformat
    Every packet consists of a sync bit followed by 26 + 2 + 4 (total 32 logical data part bits) and is ended by a pause bit.

    S HHHH HHHH HHHH HHHH HHHH HHHH HHGO CCEE P

    S = Sync bit.
    H = The first 26 bits are transmitter unique codes, and it is this code that the reciever "learns" to recognize.
        (in effect 52 bits, see TransmitterCode-module)
    G = Group code. Set to 0 for on, 1 for off.
    O = On/Off bit. Set to 0 for on, 1 for off.
    C = Channel bits. Proove/Anslut = 00, Nexa = 11.
    E = Unit bits. Device to be turned on or off.
    Proove/Anslut Unit #1 = 00, #2 = 01, #3 = 10.
    Nexa Unit #1 = 11, #2 = 10, #3 = 01.
    P = Pause bit.

    Timing = T (when sending, this will be a constant how long it will keep the GPIO high or low)
    In packet, high = 1, low = 0

    Sync-bit: 1*1T + 0*10T ( = high for 25ms, low for 250ms)
    Pause-bit = 1*1T + 0*40T
    '1'-bit: 1*1T + 0*1T
    '0'-bit: 1*1T + 0*5T

    every databit is represented as a tuple, with desired state and how many Ts to hold the state.
    So the Pause-bit is represented as [{1,1}, {0, 40}] (high for one T-period and low for 40 T-periods)

  """

  @doc """
    Will output a list of atoms for a high-level representation of the datasequence.
    Possible values in the list is:
    :sync  -> the staring syncbit
    :one   -> the '1' - bit
    :zero  -> the '0' - bit
    :pause -> the finishing pausebit
  """
  def create_datagram(%Command{ transmitter: %Transmitter{} = transmitter, desired_state: %State{} = state, receiver: %Receiver{} = receiver }) do
    datagram = [ :sync ] ++
      to_datagram(transmitter) ++
      [ to_datagram(state.group_code), to_datagram(state.on_off) ] ++
      to_datagram(receiver) ++ [:pause]
    {:ok, datagram}
  end
  def create_datagram(_), do: {:error, "Argument error, check input"}

  # Private parts


  defp to_datagram(list) when is_list(list), do: list |> Enum.map(&to_datagram/1)
  defp to_datagram(0), do: :zero
  defp to_datagram(1), do: :one
  defp to_datagram(:on), do: to_datagram(0)
  defp to_datagram(:off), do: to_datagram(1)
  defp to_datagram(%Receiver{ brand: brand, unit: unit}) do
    ChannelUnitCode.to_datastream!(brand, unit)
    |> to_datagram
  end
  defp to_datagram(%Transmitter{} = transmitter) do
    TransmitterCode.to_datastream!(transmitter)
    |> to_datagram
  end

end
