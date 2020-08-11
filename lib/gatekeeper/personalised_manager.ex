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

    if personalised_only_error?(exceeded?, personalisation_level) do
      error_response()
    else
      response = Gatekeeper.ContentRenderer.render(exceeded?, conn)

      case response do
        %Gatekeeper.Response{status_code: 200} ->
          response

        _ ->
          if personalised_only_error?(true, personalisation_level) do
            error_response()
          else
            Gatekeeper.ContentRenderer.render(true, conn)
          end
      end
    end
  end

  defp error_response do
    %Gatekeeper.Response{
      status_code: 500,
      body: "There has been an error"
    }
  end

  defp personalised_only_error?(true, :essential), do: true
  defp personalised_only_error?(_, _), do: false

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
