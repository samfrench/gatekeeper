defmodule Gatekeeper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, args) do
    # List all child processes to be supervised
    children =
      children(args) ++
        [
          # Starts a worker by calling: Gatekeeper.Worker.start_link(arg)
          # {Gatekeeper.Worker, arg}
          Plug.Cowboy.child_spec(
            scheme: scheme(System.get_env("GATEKEEPER_SCHEME")),
            plug: Gatekeeper.Router,
            options: options(System.get_env("GATEKEEPER_SCHEME"))
          ),
          Gatekeeper.Supervisor
        ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gatekeeper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp scheme("https"), do: :https
  defp scheme(_), do: :http

  defp options("https") do
    [
      port: 7443,
      certfile: Application.get_env(:gatekeeper, :certfile),
      keyfile: Application.get_env(:gatekeeper, :keyfile),
      cacertfile: Application.get_env(:gatekeeper, :cacertfile)
    ]
  end

  defp options(_), do: [port: 7080]

  defp children(env: :prod), do: []

  defp children(_) do
    [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Gatekeeper.TestServer,
        options: [port: 8095]
      )
    ]
  end
end
