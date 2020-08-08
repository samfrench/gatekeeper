defmodule Gatekeeper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Gatekeeper.Worker.start_link(arg)
      # {Gatekeeper.Worker, arg}
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Gatekeeper.Router,
        options: [port: 8000]
      ),
      Gatekeeper.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gatekeeper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
