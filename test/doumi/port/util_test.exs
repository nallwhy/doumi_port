defmodule Doumi.Port.UtilTest do
  use ExUnit.Case, async: true
  alias Doumi.Port.Util

  describe "convert_options/1" do
    test "with {atom, integer}" do
      assert Util.convert_options({:buffer_size, 65536}) == {:buffer_size, 65536}
    end

    test "with {atom, atom}" do
      assert Util.convert_options({:timeout, :infinity}) == {:timeout, :infinity}
    end

    test "with {atom, string}" do
      assert Util.convert_options({:cd, "/app/bin"}) == {:cd, '/app/bin'}
    end

    test "with {atom, [{string, string}]}" do
      assert Util.convert_options({:env, [{"PATH", "/usr/bin"}]}) ==
               {:env, [{'PATH', '/usr/bin'}]}
    end

    test "with {atom, [string]}" do
      assert Util.convert_options({:python_path, ["/python/path"]}) ==
               {:python_path, ['/python/path']}
    end

    test "with atom" do
      assert Util.convert_options(:use_stdio) == :use_stdio
    end

    test "with multiple options" do
      assert Util.convert_options([
               {:buffer_size, 65536},
               {:timeout, :infinity},
               {:cd, "/app/bin"},
               {:env, [{"PATH", "/usr/bin"}]},
               {:python_path, ["/python/path"]},
               :use_stdio
             ]) == [
               {:buffer_size, 65536},
               {:timeout, :infinity},
               {:cd, '/app/bin'},
               {:env, [{'PATH', '/usr/bin'}]},
               {:python_path, ['/python/path']},
               :use_stdio
             ]
    end
  end
end
