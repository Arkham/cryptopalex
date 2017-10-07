defmodule HexToBase64 do
  @moduledoc """
  Documentation for HexToBase64.
  """

  @uppercase_chars ?A..?Z
  @lowercase_chars ?a..?z
  @digits ?0..?9
  @special_chars [?+, ?/]

  @numbers_to_base64 [
    @uppercase_chars,
    @lowercase_chars,
    @digits,
    @special_chars
  ]
  |> Enum.map(&Enum.to_list/1)
  |> List.flatten()
  |> Enum.with_index()
  |> Enum.map(fn {c, i} -> {i, c} end)
  |> Enum.into(%{})

  def num_to_base64(number) do
    Map.get(@numbers_to_base64, number)
  end

  @doc """
  Convert hex to base 64

  ## Examples

      iex> HexToBase64.hexstring_to_base64("49276d")
      "SSdt"

  """
  def hexstring_to_base64(string) do
    string
    |> parse_hex()
    |> charlist_to_base64()
    |> to_string()
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

  defp to_int(c) when c in ?0..?9 do
    c - ?0
  end
  defp to_int(c) when c in ?a..?f do
    c - ?a + 10
  end
  defp to_int(c) when c in ?A..?F do
    c - ?A + 10
  end

  def string_to_base64(string) when is_binary(string) do
    string
    |> String.to_charlist()
    |> charlist_to_base64()
    |> to_string()
  end

  def charlist_to_base64([]), do: []
  def charlist_to_base64([first, second, third | rest]) do
    parse_three_chars(first, second, third) ++ charlist_to_base64(rest)
  end
  def charlist_to_base64([first, second]) do
    [ res1, res2, res3,  _ ] = parse_three_chars(first, second, 0)
    [ res1, res2, res3, ?= ]
  end
  def charlist_to_base64([first]) do
    [ res1, res2,  _,  _ ] = parse_three_chars(first, 0, 0)
    [ res1, res2, ?=, ?= ]
  end

  def parse_three_chars(first, second, third) do
    [first, second, third]
    |> Enum.map(&char_to_bitlist/1)
    |> List.flatten()
    |> Enum.chunk_every(6)
    |> Enum.map(& Integer.undigits(&1, 2))
    |> Enum.map(&num_to_base64/1)
  end

  defp char_to_bitlist(char) do
    pad_with_leading_zeros(Integer.digits(char, 2), 8)
  end

  defp pad_with_leading_zeros(list, len) when length(list) < len do
    pad_with_leading_zeros([0 | list], len)
  end
  defp pad_with_leading_zeros(list, _len), do: list
end
