use Mix.Config

config :gatekeeper,
  default_host: System.get_env("GATEKEEPER_HOST_DEFAULT"),
  personalised_host: System.get_env("GATEKEEPER_HOST_PERSONALISED"),
  exceeded_host: System.get_env("GATEKEEPER_HOST_EXCEEDED")
