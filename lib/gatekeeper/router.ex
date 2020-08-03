defmodule Gatekeeper.Router do
  use Plug.Router

  plug :match
  plug :dispatch
  plug Plug.Static, at: "/static", from: :server

  get "/hello" do
    send_resp(conn, 200, "Hello world!")
  end

  get "/hello/:user_name" do
    send_resp(conn, 200, "Hello, #{String.capitalize(user_name)}!")
  end

  get "/static" do
    conn = put_resp_content_type(conn, "text/html")
    send_file(conn, 200, "ext/static/file.html")
  end

  get "/timings" do
    # Probably a gen server for timings
    timings = %{average: 100}
    json_response = Poison.encode!(timings)

    send_resp(conn, 200, json_response)
  end

  match _, do: send_resp(conn, 404, "404, error not found!")
end
