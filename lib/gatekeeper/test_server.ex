defmodule Gatekeeper.TestServer do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/level/essential" do
    send_resp(conn, 200, "Personalised content essential!")
  end

  get "/level/expected" do
    send_resp(conn, 200, "Personalised content expected!")
  end

  get "/level/ideal" do
    send_resp(conn, 200, "Personalised content ideal!")
  end

  get "/level/none" do
    send_resp(conn, 200, "Non personalised content!")
  end

  match(_, do: send_resp(conn, 404, "404, error not found!"))
end
