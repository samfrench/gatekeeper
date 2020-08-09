defmodule Gatekeeper.ContentRenderer do
  @default_host Application.get_env(:gatekeeper, :default_host)
  @personalised_host Application.get_env(:gatekeeper, :personalised_host)
  @exceeded_host Application.get_env(:gatekeeper, :exceeded_host)

  def render(conn) do
    url = @default_host <> conn.request_path

    Gatekeeper.HttpClient.fetch(url)
    |> add_response_type_header("non-personalised")
  end

  def render(false, conn) do
    url = @personalised_host <> conn.request_path

    Gatekeeper.HttpClient.fetch(url)
    |> add_response_type_header("personalised")
  end

  def render(true, conn) do
    url = @exceeded_host <> conn.request_path

    Gatekeeper.HttpClient.fetch(url)
    |> add_response_type_header("limit-exceeded")
  end

  defp add_response_type_header(response, response_type) do
    %{response | headers: response.headers ++ [{"response-type", response_type}]}
  end
end
