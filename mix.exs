defmodule Doumi.Port.MixProject do
  use Mix.Project

  def project do
    [
      app: :doumi_port,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
end
