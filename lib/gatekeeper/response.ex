defmodule Gatekeeper.Response do
  defstruct [
    :status_code,
    :body,
    headers: []
  ]
end
