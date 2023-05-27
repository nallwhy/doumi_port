defmodule Mix.Tasks.Doumi.Port.Init do
  use Mix.Task

  @shortdoc "Init Doumi.Port"

  @switchs [
    port: :string,
    path: :string
  ]

  @impl Mix.Task
  def run(args) do
    no_umbrella!()

    {opts, _, _} = OptionParser.parse(args, strict: @switchs)

    port = Keyword.get(opts, :port)
    path = Keyword.get(opts, :path, "priv/#{port}")

    valid_port!(port)

    File.mkdir_p!(path)

    case port do
      "python" ->
        requirements_path = "#{path}/requirements.txt"
        gitignore_path = "#{path}/.gitignore"

        if !File.exists?(requirements_path) do
          File.touch!(requirements_path)
        end

        if !File.exists?(gitignore_path) do
          File.write!(gitignore_path, """
          lib
          __pycache__
          """)
        end

      "ruby" ->
        gemfile_path = "#{path}/Gemfile"
        gemfile_lock_path = "#{path}/Gemfile.lock"
        gitignore_path = "#{path}/.gitignore"

        if !File.exists?(gemfile_path) do
          File.write!(gemfile_path, """
          source 'https://rubygems.org'

          """)
        end

        if !File.exists?(gemfile_lock_path) do
          File.touch!(gemfile_lock_path)
        end

        if !File.exists?(gitignore_path) do
          File.write!(gitignore_path, """
          lib
          .bundle
          """)
        end
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
