defmodule Doumi.Port.Adapter.Python do
  use Doumi.Port.Adapter, erlport: :python

  def default_opts(nil) do
    [python: "python3"]
  end

  def default_opts(otp_app) when is_atom(otp_app) do
    [
      python: "python3",
      python_path: [
        [:code.priv_dir(otp_app), "python"] |> Path.join(),
        [:code.priv_dir(otp_app), "python", "lib"] |> Path.join()
      ]
    ]
  end
end
