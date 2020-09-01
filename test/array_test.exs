defmodule ArrayTest do
  use ExUnit.Case, async: true

  describe "shift/1" do
    test "shifts the first element off an array" do
      array = %Array{elements: {:b, :a}, size: 2, start: 1}

      assert {:ok, :a, new_array} = Array.shift(array)
      assert Array.to_list(new_array) == [:b]
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

  describe "slice/3" do
    test "returns a slice of an array" do
      array = %Array{elements: {:a, :b, :c, :d}, size: 4, start: 3}
      array = Array.slice(array, 1, 2)

      assert Array.to_list(array) == [:a, :b]
    end

    test "does not allow a slice past end of array" do
      array = %Array{elements: {:a, :b, :c, :d}, size: 4, start: 0}
      array = Array.slice(array, 2, 4)

      assert Array.to_list(array) == [:c, :d]
    end
  end

  describe "to_list/1" do
    test "converts an array to a list" do
      array = %Array{elements: {?a, ?b, ?c, ?d}, size: 3, start: 1}

      assert Array.to_list(array) == 'bcd'
    end
  end

  describe "Enumerable" do
    test "count is accurate" do
      array = %Array{elements: {nil, nil, nil, nil}, size: 1, start: 0}

      assert Enum.count(array) == 1
    end

    test "passes everything appropriately to reducer" do
      array = %Array{elements: {?c, ?d, ?a, ?b}, size: 3, start: 2}

      assert Enum.map(array, &(&1 + 4)) == 'efg'
    end

    test "halts early just fine" do
      array = %Array{elements: {?w, ?x, ?y, ?z}, size: 4, start: 0}

      assert Enum.take(array, 2) == 'wx'
    end

    test "slices work as expected" do
      array = %Array{elements: {?a, ?b, ?c, ?d}, size: 4, start: 2}

      assert Enum.slice(array, 1, 2) == 'da'
    end
  end
end
