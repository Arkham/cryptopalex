defmodule FixedXorTest do
  use ExUnit.Case
  doctest FixedXor

  test "the truth" do
    assert 1 + 1 == 2
  end
  test "" do
    string_one = "1c0111001f010100061a024b53535009181c"
    string_two = "686974207468652062756c6c277320657965"
    result = "746865206b696420646f6e277420706c6179"
    assert FixedXor.fixed_xor(string_one, string_two) == result
  end
end
