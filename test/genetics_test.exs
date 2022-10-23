defmodule GeneticsTest do
  use ExUnit.Case
  doctest Genetics

  test "greets the world" do
    assert Genetics.hello() == :world
  end
end
