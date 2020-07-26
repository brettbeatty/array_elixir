defmodule ArrayTest do
  use ExUnit.Case, async: true
  doctest Array

  describe "Array.fetch/2" do
    test "fetches an element by its index" do
      array = Array.new([:a, :b, :c])

      assert Array.fetch(array, 1) == {:ok, :b}
    end

    test "negative indices count from end of array" do
      array = Array.new([:a, :b, :c])

      assert Array.fetch(array, -1) == {:ok, :c}
    end

    test "raises ArgumentError for non-integer indices" do
      array = Array.new([:a, :b, :c])

      assert_raise ArgumentError, "array indices must be integers, got: 1.0", fn ->
        Array.fetch(array, 1.0)
      end
    end

    test "index (-size - 1) is out of bounds" do
      array = Array.new([:a, :b, :c])

      assert Array.fetch(array, -4) == :error
    end

    test "index (-size) is in bounds" do
      array = Array.new([:a, :b, :c])

      assert Array.fetch(array, -3) == {:ok, :a}
    end

    test "index (size - 1) is in bounds" do
      array = Array.new([:a, :b, :c])

      assert Array.fetch(array, 2) == {:ok, :c}
    end

    test "index (size) is out of bounds" do
      array = Array.new([:a, :b, :c])

      assert Array.fetch(array, 3) == :error
    end
  end

  describe "Array.new/0" do
    test "creates an empty array" do
      array = Array.new()

      assert Array.to_list(array) == []
    end
  end

  describe "Array.new/1" do
    test "creates an array from an enumerable" do
      array = Array.new([:a, :b, :c])

      assert Array.to_list(array) == [:a, :b, :c]
    end
  end

  describe "Array.push/2" do
    test "appends an element to an array" do
      array =
        [:a, :b]
        |> Array.new()
        |> Array.push(:c)

      assert Array.to_list(array) == [:a, :b, :c]
    end

    test "automatically scales up array at capacity" do
      capacity = tuple_size(Array.new().elements)

      array =
        0
        |> Range.new(capacity - 1)
        |> Array.new()
        |> Array.push(capacity)

      assert Array.to_list(array) == Enum.to_list(0..capacity)
    end
  end

  describe "Array.shift/1" do
    test "removes the first element from an array" do
      array = Array.new([:a, :b, :c])

      assert {:a, new_array} = Array.shift(array)
      assert Array.to_list(new_array) == [:b, :c]
    end

    test "returns :error if array is empty" do
      array = Array.new()

      assert Array.shift(array) == :error
    end
  end

  describe "Array.to_list/1" do
    test "converts an array to a list of its elements" do
      array = Array.new([:a, :b, :c])

      assert Array.to_list(array) == [:a, :b, :c]
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
    test "enumerates elements of an array" do
      array = Array.new([:a, :b, :c])

      assert Enum.to_list(array) == [:a, :b, :c]
    end

    test "accurately counts array elements" do
      array = Array.new([:a, :b, :c])

      assert Enum.count(array) == 3
    end
  end

  describe "Inspect" do
    test "looks like an array, not a struct" do
      array = Array.new([:a, :b, :c])

      assert inspect(array) == "#Array<[:a, :b, :c]>"
    end
  end
end
