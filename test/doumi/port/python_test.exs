defmodule Doumi.Port.PythonTest do
  use ExUnit.Case
  alias Doumi.Port.Python

  describe "start, call, stop" do
    test "without name" do
      assert {:ok, pid} = Python.start()
      assert Python.call(pid, :"os.path", :splitext, ["name.ext"]) == {"name", ".ext"}
      assert :ok = Python.stop(pid)
      assert Process.alive?(pid) == false
    end

    test "with name" do
      name = :instance_name
      assert {:ok, pid} = Python.start(name, [])
      assert Python.call(name, :"os.path", :splitext, ["name.ext"]) == {"name", ".ext"}
      assert :ok = Python.stop(name)
      assert Process.alive?(pid) == false
    end

    test "with duplicated name" do
      name = :instance_name
      {:ok, pid} = Python.start(name, [])
      assert {:error, {:already_started, ^pid}} = Python.start(name, [])
      assert Process.alive?(pid) == true
      assert :ok = Python.stop(name)
    end
  end

  describe "start_link, call, stop" do
    test "without name" do
      assert {:ok, pid} = Python.start_link()
      assert Python.call(pid, :"os.path", :splitext, ["name.ext"]) == {"name", ".ext"}
      assert :ok = Python.stop(pid)
      assert Process.alive?(pid) == false
    end

    test "with local name" do
      name = :instance_name
      assert {:ok, pid} = Python.start_link(name, [])
      assert Python.call(name, :"os.path", :splitext, ["name.ext"]) == {"name", ".ext"}
      assert :ok = Python.stop(name)
      assert Process.alive?(pid) == false
    end

    test "with duplicated name" do
      name = :instance_name
      {:ok, pid} = Python.start_link(name, [])
      assert {:error, {:already_started, ^pid}} = Python.start_link(name, [])
      assert Process.alive?(pid) == true
      assert :ok = Python.stop(name)
    end
  end
end
