defmodule HexToBase64Test do
  use ExUnit.Case
  doctest HexToBase64

  test "converts hex string to base 64" do
    hex = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
    base64 = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

    assert HexToBase64.hexstring_to_base64(hex) == base64
  end

  test "parses a hex string" do
    assert HexToBase64.parse_hex("54") == [84]
  end

  test "parses simple charlists" do
    assert HexToBase64.charlist_to_base64('Man') == 'TWFu'
  end

  test "parses simple string" do
    assert HexToBase64.string_to_base64("Man") == "TWFu"
  end

  test "pads strings which are not long enough" do
    assert HexToBase64.string_to_base64("Ma") == "TWE="
    assert HexToBase64.string_to_base64("M") == "TQ=="
  end
end
