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
    {:ok, %Gatekeeper.Timing{}}
  end

  def handle_call(:get, _state, state) do
    {:reply, state, state}
  end

  def handle_cast({:update, timing}, state) do
    state = Map.merge(state, calculate(timing, state))
    {:noreply, state}
  end

  def handle_cast(:reset, state) do
    state = %{state | timing: 0}
    {:noreply, state}
  end

  defp calculate(update = %Gatekeeper.Timing{last: current}, %Gatekeeper.Timing{count: 0}) do
    update = %{update | first: current}
    update = %{update | minimum: current}
    update = %{update | maximum: current}
    update = %{update | average: current}
    %{update | count: 1}
  end

  defp calculate(update = %Gatekeeper.Timing{last: current}, %Gatekeeper.Timing{
         count: count,
         average: average,
         first: first,
         maximum: maximum,
         minimum: minimum
       }) do
    update = %{update | first: first}
    update = %{update | minimum: min(current, minimum)}
    update = %{update | maximum: max(current, maximum)}
    update = %{update | average: (average + current) / 2}
    %{update | count: count + 1}
  end
end
