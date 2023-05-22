defmodule Doumi.Port do
  @type name() :: {:global, atom()} | {:via, atom(), atom()} | atom()
  @type instance() :: pid() | name()
  @type start_result() :: {:ok, pid()} | {:error, term}

  @callback start(opts :: list()) :: start_result()
  @callback start(name :: name(), opts :: list()) :: start_result()
  @callback start_link(opts :: list()) :: start_result()
  @callback start_link(name :: name(), opts :: list()) :: start_result()
  @callback call(
              instance :: instance(),
              module :: atom(),
              fun :: atom(),
              args :: list(),
              opts :: list()
            ) :: term()
  @callback stop(instance :: instance()) :: :ok

  defmacro __using__(opts) do
    erlport_module = Keyword.get(opts, :erlport)

    quote do
      @type name() :: Doumi.Port.name()
      @type instance() :: Doumi.Port.instance()
      @type start_result() :: Doumi.Port.start_result()

      @behaviour Doumi.Port

      alias Doumi.Port.Util

      @impl Doumi.Port
      @spec start(opts :: list()) :: start_result()
      def start(opts \\ []) when is_list(opts) do
        unquote(erlport_module).start(Util.convert_options(opts))
      end

      @impl Doumi.Port
      @spec start(name :: name(), opts :: list()) :: start_result()
      def start(name, opts) when is_list(opts) do
        unquote(erlport_module).start(maybe_wrap_local_name(name), Util.convert_options(opts))
      end

      @impl Doumi.Port
      @spec start_link(opts :: list()) :: start_result()
      def start_link(opts \\ []) when is_list(opts) do
        unquote(erlport_module).start_link(Util.convert_options(opts))
      end

      @impl Doumi.Port
      @spec start_link(name :: name(), opts :: list()) :: start_result()
      def start_link(name, opts) when is_list(opts) do
        unquote(erlport_module).start_link(
          maybe_wrap_local_name(name),
          Util.convert_options(opts)
        )
      end

      @impl Doumi.Port
      @spec stop(instance :: instance()) :: :ok
      def stop(instance) do
        unquote(erlport_module).stop(instance)
      end

      @impl Doumi.Port
      @spec call(
              instance :: instance(),
              module :: atom(),
              fun :: atom(),
              args :: list(),
              opts :: list()
            ) :: term()
      def call(instance, module, fun, args, opts \\ [])
          when is_atom(module) and is_atom(fun) and is_list(args) and is_list(opts) do
        unquote(erlport_module).call(instance, module, fun, args, Util.convert_options(opts))
      end

      defp maybe_wrap_local_name(name) when is_atom(name), do: {:local, name}
      defp maybe_wrap_local_name(name), do: name
    end
  end
end
