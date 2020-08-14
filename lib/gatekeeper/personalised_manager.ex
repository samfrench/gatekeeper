defmodule Gatekeeper.PersonalisedManager do
  def handle(conn) do
    personalisation_level = route_level(conn.path_info)

    handle_level(conn, personalisation_level)
  end

  defp handle_level(conn, :none) do
    Gatekeeper.ContentRenderer.render(conn)
  end

  defp handle_level(conn, personalisation_level) do
    %{average: average} = Gatekeeper.SystemState.get(Gatekeeper.SystemState)

    exceeded? = level_exceeded?(personalisation_level, average)

    response = personalised_request(exceeded?, personalisation_level, conn)

    cond do
      %Gatekeeper.Response{status_code: 200} ->
        response

      exceeded? ->
        error_response()

      true ->
        personalised_request(true, personalisation_level, conn)
    end
  end

  defp personalised_request(true, :essential, _conn), do: error_response()

  defp personalised_request(exceeded?, _personalisation_level, conn) do
    Gatekeeper.ContentRenderer.render(exceeded?, conn)
  end

  defp error_response do
    %Gatekeeper.Response{
      status_code: 202,
      body: "There has been an error"
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
