defmodule Mix.Tasks.Doumi.Port.Setup do
  use Mix.Task

  @shortdoc "Setup Doumi.Port"

  @switchs [
    port: :string,
    path: :string,
    pip: :string
  ]

  @impl Mix.Task
  def run(args) do
    no_umbrella!()

    {opts, _, _} = OptionParser.parse(args, strict: @switchs)

    port = Keyword.get(opts, :port)
    path = Keyword.get(opts, :path, "priv/#{port}")

    valid_port!(port)

    case port do
      "python" ->
        pip = Keyword.get(opts, :pip, "pip3")

        System.cmd(pip, ~w(install -r requirements.txt -t ./lib), cd: path)

      "ruby" ->
        System.cmd("bundle", ~w(install --path ./lib), cd: path)
    end

    :ok
  end

  defp no_umbrella!() do
    if Mix.Project.umbrella?() do
      Mix.raise(
        "Cannot run task doumi.port.setup from umbrella project root. " <>
          "Change directory to one of the umbrella applications and try again"
      )
    end
  end

  defp valid_port!(args) do
    if args not in ["python", "ruby"] do
      Mix.raise("""
      Port(python, ruby) should be provided.

      ex) mix doumi.port.setup --port python
      """)
    end
  end
end
