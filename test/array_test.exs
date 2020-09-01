defmodule ArrayTest do
  use ExUnit.Case, async: true

  describe "shift/1" do
    test "shifts the first element off an array" do
      array = %Array{elements: {:b, :a}, size: 2, start: 1}
      expected_array = %Array{elements: {:b, :a}, size: 1, start: 0}

      assert {:ok, :a, ^expected_array} = Array.shift(array)
    end

    test "returns :error when shifting off an empty array" do
      array = %Array{elements: {nil, nil}, size: 0, start: 0}

      assert Array.shift(array) == :error
    end
  end

  describe "size/1" do
    test "returns the size of the array" do
      array = %Array{elements: {?a, ?b, ?c, ?d}, size: 2, start: 1}

      assert Array.size(array) == 2
    end
  end

  describe "Enumerable" do
    test "passes everything appropriately to reducer" do
      array = %Array{elements: {?c, ?d, ?a, ?b}, size: 3, start: 2}

      assert Enum.map(array, &(&1 + 4)) == 'efg'
    end

    test "halts early just fine" do
      array = %Array{elements: {?w, ?x, ?y, ?z}, size: 4, start: 0}

      assert Enum.take(array, 2) == 'wx'
    end
  end
end
