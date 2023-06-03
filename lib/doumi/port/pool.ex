defmodule Doumi.Port.Pool do
  @behaviour NimblePool

  @default_pool_timeout :timer.seconds(5)

  def child_spec(opts) do
    {adater, opts} = opts |> Keyword.pop!(:adapter)

    {adapter_mod, _} =
      adapter =
      case adater do
        {adater_mod, adater_opts} -> {adater_mod, adater_opts}
        adater_mod -> {adater_mod, []}
      end

    {restart, opts} = opts |> Keyword.pop(:restart, :permanent)
    {shutdown, opts} = opts |> Keyword.pop(:shutdown, 5_000)

    opts = opts |> Keyword.put(:worker, {__MODULE__, adapter})
    opts = opts |> Keyword.put_new(:name, adapter_mod)

    %{
      id: adapter_mod,
      start: {NimblePool, :start_link, [opts]},
      shutdown: shutdown,
      restart: restart
    }
  end

  def command(pool_name, module, fun, args, opts \\ [])
      when is_atom(module) and is_atom(fun) and is_list(args) and is_list(opts) do
    {pool_timeout, opts} = opts |> Keyword.pop(:pool_timeout, @default_pool_timeout)

    NimblePool.checkout!(
      pool_name,
      :checkout,
      fn _from, %{adapter_mod: adapter_mod, port: port} ->
        result = adapter_mod.call(port, module, fun, args, opts)

        {result, :ok}
      end,
      pool_timeout
    )
  end

  @impl NimblePool
  def init_worker({adapter_mod, port_opts} = pool_state) do
    {:ok, port} = adapter_mod.start(port_opts)

    {:ok, %{adapter_mod: adapter_mod, port: port}, pool_state}
  end

  @impl NimblePool
  def handle_checkout(:checkout, _from, worker_state, pool_state) do
    {:ok, worker_state, worker_state, pool_state}
  end

  @impl NimblePool
  def handle_checkin(:ok, _from, worker_state, pool_state) do
    {:ok, worker_state, pool_state}
  end

  @impl NimblePool
  def terminate_worker(_reason, %{adapter_mod: adapter_mod, port: port}, pool_state) do
    adapter_mod.stop(port)

    {:ok, pool_state}
  end
end
