defmodule Doumi.Port.Adapter.RubyTest do
  use ExUnit.Case
  alias Doumi.Port.Adapter.Ruby

  describe "start, call, stop" do
    test "without name" do
      assert {:ok, pid} = Ruby.start()
      assert Ruby.call(pid, :"", :Integer, ["2"]) == 2
      assert :ok = Ruby.stop(pid)
      assert Process.alive?(pid) == false
    end

    test "with name" do
      name = :instance_name
      assert {:ok, pid} = Ruby.start(name, [])
      assert Ruby.call(pid, :"", :Integer, ["2"]) == 2
      assert :ok = Ruby.stop(name)
      assert Process.alive?(pid) == false
    end

    test "with duplicated name" do
      name = :instance_name
      {:ok, pid} = Ruby.start(name, [])
      assert {:error, {:already_started, ^pid}} = Ruby.start(name, [])
      assert Process.alive?(pid) == true
      assert :ok = Ruby.stop(name)
    end
  end

  describe "start_link, call, stop" do
    test "without name" do
      assert {:ok, pid} = Ruby.start_link()
      assert Ruby.call(pid, :"", :Integer, ["2"]) == 2
      assert :ok = Ruby.stop(pid)
      assert Process.alive?(pid) == false
    end

    test "with local name" do
      name = :instance_name
      assert {:ok, pid} = Ruby.start_link(name, [])
      assert Ruby.call(pid, :"", :Integer, ["2"]) == 2
      assert :ok = Ruby.stop(name)
      assert Process.alive?(pid) == false
    end

    test "with duplicated name" do
      name = :instance_name
      {:ok, pid} = Ruby.start_link(name, [])
      assert {:error, {:already_started, ^pid}} = Ruby.start_link(name, [])
      assert Process.alive?(pid) == true
      assert :ok = Ruby.stop(name)
    end
  end
end
