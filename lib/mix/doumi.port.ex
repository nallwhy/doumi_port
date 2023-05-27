defmodule Mix.Doumi.Port do
  # Conveniences for Doumi.Port tasks.

  def no_umbrella!() do
    if Mix.Project.umbrella?() do
      Mix.raise(
        "Cannot run this task from umbrella project root. " <>
          "Change directory to one of the umbrella applications and try again"
      )
    end
  end

  def valid_port!(args, description) do
    if args not in ["python", "ruby"] do
      Mix.raise("""
      Port(python, ruby) should be provided.

      #{description}
      """)
    end
  end
end
