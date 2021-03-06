defmodule ArrayTest do
  use ExUnit.Case, async: true

  describe "new/0" do
    test "creates an empty array" do
      array = Array.new()

      assert Array.to_list(array) == []
    end
  end

  describe "new/1" do
    test "creates an array from an enumerable" do
      array = Array.new([:a, :b, :c])

      assert Array.to_list(array) == [:a, :b, :c]
    end
  end

  describe "push/2" do
    test "appends an element to an array" do
      array = Array.new([:a, :b])
      array = Array.push(array, :c)

      assert Array.to_list(array) == [:a, :b, :c]
    end

    test "scales up arrays at capacity" do
      capacity = tuple_size(Array.new().elements)

      array =
        0
        |> Range.new(capacity - 1)
        |> Array.new()
        |> Array.push(capacity)

      assert Array.to_list(array) == Enum.to_list(0..capacity)
    end
  end

  describe "shift/1" do
    test "shifts the first element off an array" do
      array = Array.new([:a, :b])

      assert {:ok, :a, new_array} = Array.shift(array)
      assert Array.to_list(new_array) == [:b]
    end

    test "returns :error when shifting off an empty array" do
      array = Array.new()

      assert Array.shift(array) == :error
    end
  end

  describe "size/1" do
    test "returns the size of the array" do
      array = Array.new([:a, :b])

      assert Array.size(array) == 2
    end
  end

  describe "slice/3" do
    test "returns a slice of an array" do
      array = Array.new([:d, :a, :b, :c])
      array = Array.slice(array, 1, 2)

      assert Array.to_list(array) == [:a, :b]
    end

    test "does not allow a slice past end of array" do
      array = Array.new([:a, :b, :c, :d])
      array = Array.slice(array, 2, 4)

      assert Array.to_list(array) == [:c, :d]
    end
  end

  describe "to_list/1" do
    test "converts an array to a list" do
      array = Array.new('bcd')

      assert Array.to_list(array) == 'bcd'
    end
  end

  describe "Collectable" do
    test "collects elements into an array" do
      array = Array.new([:a])
      new_array = Enum.into([:b, :c], array)

      assert Array.to_list(new_array) == [:a, :b, :c]
    end
  end

  describe "Enumerable" do
    test "count is accurate" do
      array = Array.new([nil])

      assert Enum.count(array) == 1
    end

    test "passes everything appropriately to reducer" do
      array = Array.new('abc')

      assert Enum.map(array, &(&1 + 4)) == 'efg'
    end

    test "halts early just fine" do
      array = Array.new('wxyz')

      assert Enum.take(array, 2) == 'wx'
    end

    test "suspends and resumes" do
      array = Array.new([:a, :b, :c])

      assert Enum.zip(array, 1..3) == [a: 1, b: 2, c: 3]
    end

    test "slices work as expected" do
      array = Array.new('cdab')

      assert Enum.slice(array, 1, 2) == 'da'
    end
  end
end
