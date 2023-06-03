defmodule Doumi.PortTest do
  use ExUnit.Case, async: true
  alias Doumi.Port.Adapter.Python

  defmodule TestPool do
    use Doumi.Port, port: {Python, python_path: ["#{__DIR__}/../support/python"]}
  end

  test "__using__/1" do
    children = [TestPool]

    assert {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)

    assert TestPool.command(:test, :hello, []) == "world"
  end
end
