defmodule Gatekeeper.PersonalisedManager do
  def handle(conn) do
    personalisation_level = route_level(conn.path_info)

    handle_level(conn, personalisation_level)
  end

  defp handle_level(conn, :none) do
    fetch(conn)
  end

  defp handle_level(conn, personalisation_level) do
    %{average: average} = Gatekeeper.SystemState.get(Gatekeeper.SystemState)

    fetch(level_exceeded?(personalisation_level, average), conn)
  end

  def fetch(_conn) do
    %Gatekeeper.Response{
      status_code: 200,
      body: "Non personalised content!",
      headers: [{"response-type", "non-personalised"}]
    }
  end

  defp fetch(false, _conn) do
    %Gatekeeper.Response{
      status_code: 200,
      body: "Personalised content!",
      headers: [{"response-type", "personalised"}]
    }
  end

  defp fetch(true, _conn) do
    %Gatekeeper.Response{
      status_code: 429,
      body: "Other content!",
      headers: [{"response-type", "limit-exceeded"}]
    }
  end

  defp level_exceeded?(:essential, average) when average > 3000, do: true
  defp level_exceeded?(:expected, average) when average > 2000, do: true
  defp level_exceeded?(:ideal, average) when average > 1000, do: true
  defp level_exceeded?(_, _), do: false

  defp route_level(["level", "essential" | _]), do: :essential
  defp route_level(["level", "expected" | _]), do: :expected
  defp route_level(["level", "ideal" | _]), do: :ideal
  defp route_level(["level", "none" | _]), do: :none
  defp route_level(_path_info), do: :none
end
