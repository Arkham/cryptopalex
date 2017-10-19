defmodule FixedXor do
  @moduledoc """
  Documentation for FixedXor.
  """

  @doc """
  Hello world.

  ## Examples

      iex> FixedXor.hello
      :world

  """
  def hello do
    :world
  end

  def fixed_xor(string_one, string_two) do
    Enum.zip(parse_hex(string_one), parse_hex(string_two))
      |> (Enum.map fn {l, r} ->
        Enum.zip(to_bits(l), to_bits(r))
        |> Enum.map(&xor/1)
      end)
      |> Enum.map(&Integer.undigits(&1, 2))
      |> Enum.map(&Integer.to_charlist(&1, 16))
      |> Enum.join("")
      |> String.downcase
  end

  def parse_hex(string) when is_binary(string) do
    parse_hex(String.to_charlist(string))
  end
  def parse_hex([]) do
    []
  end
  def parse_hex([x, y | tail]) do
    [ to_int(x) * 16 + to_int(y) | parse_hex(tail) ]
  end

  def to_bits(int) when int in 0..255 do
    to_bits(int, [])
    |> pad_bits(8)
  end
  def to_bits(int, result) when int in 2..255 do
    to_bits(div(int, 2), [rem(int, 2) | result])
  end
  def to_bits(int, result) when int in 0..1 do
    [int | result]
  end

  defp pad_bits(list, len) when length(list) < len do
    pad_bits([0 | list], len)
  end
  defp pad_bits(list, _len), do: list

  defp to_int(c) when c in ?0..?9 do
    c - ?0
  end
  defp to_int(c) when c in ?a..?f do
    c - ?a + 10
  end
  defp to_int(c) when c in ?A..?F do
    c - ?A + 10
  end

  defp xor({1, 1}), do: 0
  defp xor({1, 0}), do: 1
  defp xor({0, 1}), do: 1
  defp xor({0, 0}), do: 0
end
