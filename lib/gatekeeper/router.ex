defmodule Gatekeeper.Router do
  use Plug.Router

  plug(Gatekeeper.Plugs.ResponseTimes)
  plug(Plug.Static, at: "/static", from: :server)
  plug(:match)
  plug(:dispatch)

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

  get "/private/timings" do
    timings = Gatekeeper.SystemState.get(Gatekeeper.SystemState)
    json_response = Poison.encode!(timings)

    send_resp(conn, 200, json_response)
  end

  get "/*any" do
    response = Gatekeeper.PersonalisedManager.handle(conn)

    conn = %{conn | resp_headers: conn.resp_headers ++ response.headers}

    send_resp(conn, response.status_code, response.body)
  end

  match(_, do: send_resp(conn, 404, "404, error not found!"))
end
