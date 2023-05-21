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
end
