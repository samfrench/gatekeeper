defmodule GatekeeperTest do
  use ExUnit.Case
  doctest Gatekeeper

  test "greets the world" do
    assert Gatekeeper.hello() == :world
  end
end
