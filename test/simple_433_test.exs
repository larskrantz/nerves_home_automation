defmodule Simple433Test do
  use ExUnit.Case
  doctest NervesHomeAutomation.Simple433.TransmitterCode
  doctest NervesHomeAutomation.Simple433.ChannelUnitCode

  setup_all do
    transmitter_code = 1
    brand = :nexa
    unit = 2
    transmitter = %NervesHomeAutomation.Simple433.Transmitter{ transmitter_code: transmitter_code }
    receiver = %NervesHomeAutomation.Simple433.Receiver{ brand: brand, unit: unit }
    state = %NervesHomeAutomation.Simple433.State{ group_code: :off, on_off: :on }
    command = %NervesHomeAutomation.Simple433.Command{ transmitter: transmitter, receiver: receiver, desired_state: state}
    {:ok, [command: command]}
  end
  describe "when creating a datagram" do
    setup(context) do
      {:ok, datagram} = NervesHomeAutomation.Simple433.PacketFactory.create_datagram(context[:command])
      {:ok, [datagram: datagram]}
    end
    test "should return an array with high-level data for the command", context do
      assert context[:datagram] == [:sync, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :zero, :one, :one, :zero, :one, :zero, :one, :one, :one, :zero, :pause]
    end
    test "total datagram length should be 60", context do
      assert length(context[:datagram]) == 60
    end
  end

  describe "when creating a packet" do
    setup(context) do
      timing_ms = 25
      {:ok, datagram} = NervesHomeAutomation.Simple433.PacketFactory.create_datagram(context[:command])
      {:ok, packet} = NervesHomeAutomation.Simple433.PacketFactory.create_packet(datagram, timing_ms)
      {:ok, [packet: packet, timing_ms: timing_ms]}
    end
    test "sync should be {1, timing_ms * 1}, {0, timing_ms * 10}", context do
      timing_ms = context[:timing_ms]
      sync = Enum.take(context[:packet], 2)
      assert sync == [{ 1, timing_ms }, { 0, timing_ms * 10 }]
    end
    test "pause should be {1, timing_ms * 1}, {0, timing_ms * 40}", context do
      timing_ms = context[:timing_ms]
      pause = context[:packet] |> Enum.reverse |> Enum.take(2) |> Enum.reverse
      assert pause == [{ 1, timing_ms }, { 0, timing_ms * 40 }]
    end
    test ":zero at datagram position 2 should be {1, timing_ms * 1}, {0, timing_ms * 5}", context do
      timing_ms = context[:timing_ms]
      zero = Enum.slice(context[:packet], 2..3)
      assert zero == [{ 1, timing_ms }, { 0, timing_ms * 5 }]
    end
    test ":one at datagram position 3 should be {1, timing_ms * 1}, {0, timing_ms * 1}", context do
      timing_ms = context[:timing_ms]
      one = Enum.slice(context[:packet], 4..5)
      assert one == [{ 1, timing_ms }, { 0, timing_ms * 1 }]
    end
    test "total packet length should be 120", context do
      assert length(context[:packet]) == 120
    end
  end
end
