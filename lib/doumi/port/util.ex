defmodule Doumi.Port.Util do
  # http://erlport.org/docs/python.html#python-start-0

  def convert_options(opts) when is_list(opts) do
    opts |> Enum.map(&convert_options/1)
  end

  def convert_options({key, value}) do
    {convert_options(key), convert_options(value)}
  end

  def convert_options(value) when is_binary(value) do
    value |> String.to_charlist()
  end

  def convert_options(value) do
    value
  end
end
