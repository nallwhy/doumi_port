defmodule Doumi.Port do
  defmacro __using__(opts) do
    quote do
      def child_spec(opts) do
        opts =
          unquote(opts)
          |> Keyword.merge(name: __MODULE__)
          |> Keyword.merge(opts)

        {adapter, opts} = opts |> Keyword.pop!(:adapter)

        {adapter_mod, adapter_opts} =
          case adapter do
            {adapter_mod, adapter_opts} -> {adapter_mod, adapter_opts}
            adapter_mod -> {adapter_mod, []}
          end

        otp_app = Keyword.get(opts, :otp_app)
        adapter_opts = Keyword.merge(adapter_mod.default_opts(otp_app), adapter_opts)

        opts = opts |> Keyword.put(:adapter, {adapter_mod, adapter_opts})

        Doumi.Port.Pool.child_spec(opts)
      end

      def command(module, fun, args, opts \\ []) do
        Doumi.Port.Pool.command(__MODULE__, module, fun, args, opts)
      end
    end
  end
end
