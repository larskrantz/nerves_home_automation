if :prod != Mix.env do
  defmodule Nerves.Networking do
    require Logger
    use GenServer

    @moduledoc """
    Does nothing. Stands in for https://github.com/nerves-project/nerves_io_ethernet
    during development. Partial implementation for now.
    """

    def setup interface, opts \\ [] do
      GenServer.start_link(__MODULE__, {interface, opts}, [name: :ethernet])
    end

    def init(_args) do
      if Application.get_env(:nerves_home_automation, :kill_dummy_ethernet) do
        send(self, :crash)
      end
      {:ok, []}
    end

    def handle_info(:crash, state) do
      Logger.info("Ethernet crashing")
      {:noreply, :kill, state}
    end
  end
end
