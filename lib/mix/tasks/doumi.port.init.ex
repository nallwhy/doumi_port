defmodule Mix.Tasks.Doumi.Port.Init do
  use Mix.Task

  @shortdoc "Init Doumi.Port"

  @switchs [
    port: :string,
    path: :string
  ]

  @impl Mix.Task
  def run(args) do
    Mix.Doumi.Port.no_umbrella!()

    {opts, _, _} = OptionParser.parse(args, strict: @switchs)

    port = Keyword.get(opts, :port)
    path = Keyword.get(opts, :path, "priv/#{port}")

    Mix.Doumi.Port.valid_port!(port, "ex) mix doumi.port.setup --port python")

    File.mkdir_p!(path)

    case port do
      "python" ->
        "#{path}/requirements.txt"
        |> do_if_not_exist(&File.touch!(&1))

        "#{path}/.gitignore"
        |> do_if_not_exist(
          &File.write!(&1, """
          lib
          __pycache__
          """)
        )

      "ruby" ->
        "#{path}/Gemfile"
        |> do_if_not_exist(
          &File.write!(&1, """
          source 'https://rubygems.org'

          """)
        )

        "#{path}/Gemfile.lock"
        |> do_if_not_exist(&File.touch!(&1))

        "#{path}/.gitignore"
        |> do_if_not_exist(
          &File.write!(&1, """
          lib
          .bundle
          """)
        )
    end

    :ok
  end

  defp do_if_not_exist(path, fun) when is_function(fun, 1) do
    if !File.exists?(path) do
      fun.(path)
    end
  end
end
