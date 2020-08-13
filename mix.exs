defmodule Gatekeeper.MixProject do
  use Mix.Project

  def project do
    [
      app: :gatekeeper,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug, :plug_cowboy],
      mod: {Gatekeeper.Application, [env: Mix.env()]}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:plug_cowboy, "~> 2.0"},
      # Fix cowlib due to issue with later version affecting cowboy
      {:cowlib, "~> 2.8.0"},
      {:poison, "~> 3.1"},
      {:mojito, "~> 0.7.1"},
      {:observer_cli, "~> 1.5"},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
