# Doumi.Port

[![Hex Version](https://img.shields.io/hexpm/v/doumi_port.svg)](https://hex.pm/packages/doumi_port)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/doumi_port/)
[![License](https://img.shields.io/hexpm/l/doumi_port.svg)](https://github.com/nallwhy/doumi_port/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/nallwhy/doumi_port.svg)](https://github.com/nallwhy/doumi_port/commits/main)

<!-- MDOC !-->

`Doumi.Port` is a helper library that makes it easier to use Python, Ruby in Elixir powered by [Erlport](https://github.com/erlport/erlport), [NimblePool](https://github.com/dashbitco/nimble_pool).

**도우미(Doumi)** means "helper" in Korean.

## Why pool?

https://medium.com/stuart-engineering/how-we-use-python-within-elixir-486eb4d266f9

> Every time we run Python code through ErlPort, ErlPort starts an OS process, this is rather inefficient and expensive. To avoid this trap, we went looking for some pooling mechanism ...

## Why [NimblePool](https://github.com/dashbitco/nimble_pool)?

https://github.com/dashbitco/nimble_pool#nimblepool

> You should consider using NimblePool whenever you have to manage sockets, **ports**, or NIF resources and you want the client to perform one-off operations on them. For example, NimblePool is a good solution to manage HTTP/1 connections, ports that need to communicate with long-running programs, etc.

## Usage

### Call Python function via Pool

```elixir
defmodule MyApp.PythonPool do
  use Doumi.Port.Pool,
    port: {
      Doumi.Port.Python,
      python_path: [
        [:code.priv_dir(:my_app), "python"] |> Path.join(),
        [:code.priv_dir(:my_app), "python", "lib"] |> Path.join()
      ]
    },
    pool_size: 4
end

defmodule MyApp.Application do
  ...

  @impl true
  def start(_type, _args) do
    children = [
      ...
      MyApp.PythonPool
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: MyApp.Supervisor)
  end
end

defmodule MyApp.Native do
  def add(a, b) do
    MyApp.PythonPool.command(:operator, :add, [a, b])
  end
end
```

### Init and Setup Python in Elixir application

```shell
# Create requirements.txt, .gitignores to ./priv/python
mix doumi.port.init --port python

# Add Python dependency
echo "pypdf2==3.0.1" >> ./priv/python/requirements.txt

# Install Python dependecies
mix doumi.port.setup --port python
```

You can install Python dependencies to your release with `mix doumi.port.setup`.

```elixir
defmodule MyApp.MixProject do
  defp aliases do
    [
      ...,
      "release.setup": ["doumi.port.setup --port python", ...]
    ]
  end
end
```

```dockerfile
...

# release setup (ex. install Python dependencies, compile assets)
RUN mix release.setup

...
```

## Installation

The package can be installed by adding `doumi_port` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:doumi_port, "~> 0.3.0"},
    # To support Python >= 3.11, erlport should be overridden
    # https://github.com/erlport/erlport/pull/13
    {:erlport, github: "nallwhy/erlport", ref: "6f5cb45", override: true}
  ]
end
```

## TODO

- [x] Support use macro
- [x] Support Ruby
- [x] Support mix tasks that help setup Python in applications
- [ ] Support mix tasks that help setup Ruby in applications

<!-- MDOC !-->

## Doumi\*

All **Doumi** libraries:

- [Doumi.Phoenix.SVG](https://github.com/nallwhy/doumi_phoenix_svg): A helper library that generates Phoenix function components from SVG files.
- [Doumi.Phoenix.Params](https://github.com/nallwhy/doumi_phoenix_params): A helper library that supports converting form to params and params to form
- [Doumi.URI.Query](https://github.com/nallwhy/doumi_uri_query): A helper library that encode complicated query of URI.

## Copyright and License

Copyright (c) 2023 Jinkyou Son (Json)

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the [LICENSE.md](./LICENSE.md) file for more details.
