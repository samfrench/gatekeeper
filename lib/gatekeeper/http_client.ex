defmodule Gatekeeper.HttpClient do
  def fetch(url) do
    # Verify none to remove certificate trust to allow for testing various origins
    Mojito.request(method: :get, url: url, opts: [transport_opts: [verify: :verify_none]])
    |> handle()
  end

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
