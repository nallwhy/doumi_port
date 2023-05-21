defmodule Doumi.Port.MixProject do
  use Mix.Project

  @source_url "https://github.com/nallwhy/doumi_port"
  @version "0.1.0"

  def project do
    [
      app: :doumi_port,
      version: @version,
      elixir: "~> 1.7",
      name: "Doumi.Port",
      description: "A helper library that facilitates the usage of Python in Elixir.",
      deps: deps(),
      package: package()
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
      # https://github.com/erlport/erlport/pull/13
      {:erlport, github: "nallwhy/erlport", ref: "6f5cb45"},
      {:nimble_pool, "~> 1.0"}
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
end
