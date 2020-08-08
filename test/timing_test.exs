defmodule TimingTest do
  use ExUnit.Case

  test "timing data structure has defaults" do
    assert %Gatekeeper.Timing{} == %Gatekeeper.Timing{
             average: 0,
             count: 0,
             errors: 0,
             first: 0,
             last: 0,
             maximum: 0,
             minimum: 0
           }
  end
end
