defmodule Gatekeeper.Plugs.ResponseTimes do
  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2]

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    start_time = :os.timestamp()

    register_before_send(conn, fn conn ->
      end_time = :os.timestamp()
      diff = :timer.now_diff(end_time, start_time)
      timing = diff / 1_000

      update(match?(conn), conn, timing)

      conn
    end)
  end

  defp match?(conn) do
    Map.get(conn, :path_info)
    |> List.first()
    |> String.equivalent?("private")
    |> Kernel.not()
  end

  defp update(false, _conn, _timing), do: nil

  defp update(true, conn, timing) do
    IO.inspect(conn)
    IO.inspect(timing)
    # @todo: Add timing to store
  end
end
