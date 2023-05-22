defmodule Doumi.Port.MixProject do
  use Mix.Project

  @source_url "https://github.com/nallwhy/doumi_port"
  @version "0.3.0"

  def project do
    [
      app: :doumi_port,
      version: @version,
      elixir: "~> 1.7",
      name: "Doumi.Port",
      description: "A helper library that makes it easier to use Python, Ruby in Elixir.",
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:erlport, "~> 0.10"},
      {:nimble_pool, "~> 1.0"},
      {:ex_doc, "~> 0.29", only: :docs}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      maintainers: ["Jinkyou Son(nallwhy@gmail.com)"],
      files: ~w(lib mix.exs README.md LICENSE.md),
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: [
        "README.md": [title: "Overview"],
        "LICENSE.md": [title: "License"]
      ]
    ]
  end
end
