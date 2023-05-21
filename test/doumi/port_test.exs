defmodule Doumi.PortTest do
  use ExUnit.Case
  doctest Doumi.Port

  test "greets the world" do
    assert Doumi.Port.hello() == :world
  end
end
