defmodule Doumi.Port do
  defmacro __using__(opts) do
    quote do
      def child_spec(opts) do
        opts =
          unquote(opts)
          |> Keyword.merge(name: __MODULE__)
          |> Keyword.merge(opts)

        Doumi.Port.Pool.child_spec(opts)
      end

      def command(module, fun, args, opts \\ []) do
        Doumi.Port.Pool.command(__MODULE__, module, fun, args, opts)
      end
    end
  end
end
