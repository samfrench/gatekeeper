defmodule Gatekeeper.HttpClient do
  def fetch(url) do
    Mojito.request(method: :get, url: url, opts: http_opts(String.starts_with?(url, "https")))
    |> handle()
  end

  # Verify none to remove certificate trust to allow for testing various origins
  defp http_opts(true), do: [transport_opts: [verify: :verify_none]]
  defp http_opts(false), do: []

  defp handle({:ok, response}) do
    %Gatekeeper.Response{
      status_code: response.status_code,
      body: response.body,
      headers: response.headers
    }
  end

  defp handle({:error, _response}) do
    # Error handling should log error
    %Gatekeeper.Response{status_code: 500, body: "Something went wrong", headers: []}
  end
end
