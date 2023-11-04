defmodule Doumi.Port.PoolTest do
  use ExUnit.Case
  alias Doumi.Port.Pool
  alias Doumi.Port.Adapter

  describe "command/4" do
    test "with adapter options" do
      python_path = ["#{__DIR__}/../../support/python"]
      children = [{Pool, adapter: {Adapter.Python, python_path: python_path}, name: PythonPool}]

      assert {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)

      assert {:ok, "world"} = Pool.command(PythonPool, :test, :hello, [])

      Supervisor.stop(pid)
    end

    test "when an error happens" do
      python_path = ["#{__DIR__}/../../support/python"]
      children = [{Pool, adapter: {Adapter.Python, python_path: python_path}, name: PythonPool}]

      assert {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)

      assert {:error, _} = Pool.command(PythonPool, :invalid, :invalid, [])

      Supervisor.stop(pid)
    end
  end
end
