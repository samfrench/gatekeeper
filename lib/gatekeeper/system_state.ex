defmodule Gatekeeper.SystemState do
  use GenServer

  # Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get(server) do
    GenServer.call(server, :get)
  end

  def update(server, timing) do
    GenServer.cast(server, {:update, timing})
  end

  def reset(server) do
    GenServer.cast(server, :reset)
  end

  # Server

  def init(_) do
    {:ok, %{timing: 0}}
  end

  def handle_call(:get, _state, state) do
    {:reply, state, state}
  end

  def handle_cast({:update, timing}, state) do
    state = Map.put(state, :timing, timing)
    {:noreply, state}
  end

  def handle_cast(:reset, state) do
    state = Map.put(state, :timing, 0)
    {:noreply, state}
  end
end
