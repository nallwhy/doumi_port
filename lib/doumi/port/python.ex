defmodule Doumi.Port.Python do
  @type name() :: {:global, atom()} | {:via, atom(), atom()} | atom()
  @type start_result() :: {:ok, pid()} | {:error, term}
  @type instance() :: pid() | name()

  alias Doumi.Port.Util

  @spec start(opts :: list()) :: start_result()
  def start(opts \\ []) when is_list(opts) do
    :python.start(Util.convert_options(opts))
  end

  @spec start(name :: name(), opts :: list()) :: start_result()
  def start(name, opts) when is_list(opts) do
    :python.start(maybe_wrap_local_name(name), Util.convert_options(opts))
  end

  @spec start_link(opts :: list()) :: start_result()
  def start_link(opts \\ []) when is_list(opts) do
    :python.start_link(Util.convert_options(opts))
  end

  @spec start_link(name :: name(), opts :: list()) :: start_result()
  def start_link(name, opts) when is_list(opts) do
    :python.start_link(maybe_wrap_local_name(name), Util.convert_options(opts))
  end

  @spec stop(instance :: instance()) :: :ok
  def stop(instance) do
    :python.stop(instance)
  end

  @spec call(
          instance :: instance(),
          module :: atom(),
          fun :: atom(),
          args :: list(),
          opts :: list()
        ) :: term()
  def call(instance, module, fun, args, opts \\ [])
      when is_atom(module) and is_atom(fun) and is_list(args) and is_list(opts) do
    :python.call(instance, module, fun, args, Util.convert_options(opts))
  end

  defp maybe_wrap_local_name(name) when is_atom(name), do: {:local, name}
  defp maybe_wrap_local_name(name), do: name
end
