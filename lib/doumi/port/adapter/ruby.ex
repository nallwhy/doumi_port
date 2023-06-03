defmodule Doumi.Port.Adapter.Ruby do
  use Doumi.Port.Adapter, erlport: :ruby

  def default_opts(nil) do
    [ruby: "ruby"]
  end

  def default_opts(otp_app) do
    [
      ruby: "ruby",
      ruby_lib: [
        [:code.priv_dir(otp_app), "ruby"] |> Path.join(),
        [:code.priv_dir(otp_app), "ruby", "lib"] |> Path.join()
      ]
    ]
  end
end
