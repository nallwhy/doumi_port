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
    Mix.Doumi.Port.no_umbrella!()

    {opts, _, _} = OptionParser.parse(args, strict: @switchs)

    port = Keyword.get(opts, :port)
    path = Keyword.get(opts, :path, "priv/#{port}")

    Mix.Doumi.Port.valid_port!(port, "ex) mix doumi.port.setup --port python")

    case port do
      "python" ->
        pip = Keyword.get(opts, :pip, "pip3")

        System.cmd(pip, ~w(install -r requirements.txt -t ./lib), cd: path)

      "ruby" ->
        System.cmd("bundle", ~w(install --path ./lib), cd: path)
    end

    :ok
  end
end
