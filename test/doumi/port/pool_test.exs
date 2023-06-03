defmodule Doumi.Port.PoolTest do
  use ExUnit.Case
  alias Doumi.Port.Pool
  alias Doumi.Port.Adapter

  describe "command/4" do
    test "with adapter options" do
      python_path = ["#{__DIR__}/../../support/python"]
      children = [{Pool, adapter: {Adapter.Python, python_path: python_path}, name: PythonPool}]

      assert {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)

      assert Pool.command(PythonPool, :test, :hello, []) == "world"
    end
  end
end
