defmodule Doumi.Port.Pool do
  @behaviour NimblePool

  @default_pool_timeout :timer.seconds(5)

  def child_spec(opts) do
    {port_opts, opts} = opts |> Keyword.pop!(:port)

    {port_module, _} =
      port_opts =
      case port_opts do
        {port_module, port_opts} -> {port_module, port_opts}
        port_module -> {port_module, []}
      end

    {restart, opts} = opts |> Keyword.pop(:restart, :permanent)
    {shutdown, opts} = opts |> Keyword.pop(:shutdown, 5_000)

    opts = opts |> Keyword.put(:worker, {__MODULE__, port_opts})
    opts = opts |> Keyword.put_new(:name, port_module)

    %{
      id: port_module,
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
      fn _from, %{port_module: port_module, port: port} ->
        result = port_module.call(port, module, fun, args, opts)

        {result, :ok}
      end,
      pool_timeout
    )
  end

  @impl NimblePool
  def init_worker({port_module, port_opts} = pool_state) do
    {:ok, port} = port_module.start(port_opts)

    {:ok, %{port_module: port_module, port: port}, pool_state}
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
  def terminate_worker(_reason, %{port_module: port_module, port: port}, pool_state) do
    port_module.stop(port)

    {:ok, pool_state}
  end
end
