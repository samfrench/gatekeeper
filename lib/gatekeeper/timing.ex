defmodule Gatekeeper.Timing do
  defstruct average: 0,
            count: 0,
            first: 0,
            last: 0,
            maximum: 0,
            minimum: 0,
            errors: 0
end
