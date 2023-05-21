defmodule Doumi.Port.PoolTest do
  use ExUnit.Case
  alias Doumi.Port.{Pool, Python}

  describe "command/4" do
    test "without port options" do
      children = [{Pool, port: Python, name: PythonPool}]

      assert {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)

      assert Pool.command(PythonPool, :operator, :add, [1, 2]) == 3
      assert Pool.command(PythonPool, :operator, :add, [2, 3]) == 5
    end

    test "with port options" do
      python_path = ["#{__DIR__}/../../support/python"]
      children = [{Pool, port: {Python, python_path: python_path}, name: PythonPool}]

      assert {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)

      assert Pool.command(PythonPool, :test, :hello, []) == "world"
    end
  end
end
