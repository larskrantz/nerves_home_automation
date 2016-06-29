defmodule Simple433Test do
  use ExUnit.Case
  doctest NervesHomeAutomation.Simple433.TransmitterCode
  doctest NervesHomeAutomation.Simple433.ChannelUnitCode

  describe "when creating a datagram" do
    test "should return an array with high-level data for the command" do
      transmitter_code = 1
      brand = :nexa
      unit = 2
      transmitter = %NervesHomeAutomation.Simple433.Transmitter{ transmitter_code: transmitter_code }
      receiver = %NervesHomeAutomation.Simple433.Receiver{ brand: brand, unit: unit }
      state = %NervesHomeAutomation.Simple433.State{ group_code: :off, on_off: :on }
      command = %NervesHomeAutomation.Simple433.Command{ transmitter: transmitter, receiver: receiver, desired_state: state}
      {:ok, datagram} = NervesHomeAutomation.Simple433.PacketFactory.create_datagram(command)
      assert [:sync, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :one, :zero, :one, :zero, :one, :one, :one, :zero, :pause] == datagram
    end
  end
end
