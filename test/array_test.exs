defmodule ArrayTest do
  use ExUnit.Case, async: true
  doctest Array

  describe "Array.delete/2" do
    test "can delete from start of array" do
      array =
        ?a..?e
        |> Array.new()
        |> Array.delete(0)

      assert Array.to_list(array) == 'bcde'
    end

    test "can delete from front half of array" do
      array =
        ?a..?e
        |> Array.new()
        |> Array.delete(1)

      assert Array.to_list(array) == 'acde'
    end

    test "can delete from middle of array" do
      array =
        ?a..?e
        |> Array.new()
        |> Array.delete(2)

      assert Array.to_list(array) == 'abde'
    end

    test "can delete from back half of array" do
      array =
        ?a..?e
        |> Array.new()
        |> Array.delete(3)

      assert Array.to_list(array) == 'abce'
    end

    test "can delete from end of array" do
      array =
        ?a..?e
        |> Array.new()
        |> Array.delete(4)

      assert Array.to_list(array) == 'abcd'
    end

    test "leaves array alone if index out of bounds" do
      array =
        ?a..?e
        |> Array.new()
        |> Array.delete(5)

      assert Array.to_list(array) == 'abcde'
    end

    test "allows deleting from negative index" do
      array =
        ?a..?e
        |> Array.new()
        |> Array.delete(-2)

      assert Array.to_list(array) == 'abce'
    end

    test "raises ArgumentError for non-integer indices" do
      array = Array.new([:a, :b, :c])

      assert_raise ArgumentError, "array indices must be integers, got: :b", fn ->
        Array.delete(array, :b)
      end
    end
  end

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

  describe "Array.get_and_update/3" do
    test "allows getting and updating a value" do
      array = Array.new([:a, :d, :c])

      assert {"d", new_array} = Array.get_and_update(array, 1, &{to_string(&1), :b})
      assert Array.to_list(new_array) == [:a, :b, :c]
    end

    test "allows popping a value" do
      array = Array.new([:a, :b, :c])

      assert {:c, new_array} = Array.get_and_update(array, -1, fn _element -> :pop end)
      assert Array.to_list(new_array) == [:a, :b]
    end

    test "does not update array when index is out of bounds" do
      array = Array.new([:a, :b, :c])

      assert Array.get_and_update(array, 3, &{to_string(&1), :d}) == {"", array}
    end

    test "raises ArgumentError for non-integer indices" do
      array = Array.new([:a, :b, :c])

      assert_raise ArgumentError, "array indices must be integers, got: {}", fn ->
        Array.get_and_update(array, {}, &{inspect(&1), :d})
      end
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

  describe "Array.pop/2" do
    test "pops an element from an array by its index" do
      array = Array.new(?a..?e)

      assert {?b, new_array} = Array.pop(array, 1)
      assert Array.to_list(new_array) == 'acde'
    end

    test "allows popping by a negative index" do
      array = Array.new(?a..?e)

      assert {?d, new_array} = Array.pop(array, -2)
      assert Array.to_list(new_array) == 'abce'
    end

    test "returns {nil, array} when index is out of bounds" do
      array = Array.new(?a..?e)

      assert Array.pop(array, 5) == {nil, array}
    end

    test "raises ArgumentError for non-integer indices" do
      array = Array.new(?a..?e)

      assert_raise ArgumentError, "array indices must be integers, got: []", fn ->
        Array.pop(array, [])
      end
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

  describe "Array.put/3" do
    test "puts an element to an existing index" do
      array =
        [:a, :b, :d]
        |> Array.new()
        |> Array.put(2, :c)

      assert Array.to_list(array) == [:a, :b, :c]
    end

    test "allows putting to a negative index" do
      array =
        [:b, :b, :c]
        |> Array.new()
        |> Array.put(-3, :a)

      assert Array.to_list(array) == [:a, :b, :c]
    end

    test "does nothing if index out of bounds" do
      array =
        [:a, :b, :c]
        |> Array.new()
        |> Array.put(3, :d)

      assert Array.to_list(array) == [:a, :b, :c]
    end

    test "raises ArgumentError for non-integer indices" do
      array = Array.new([:a, :b, :c])

      assert_raise ArgumentError, "array indices must be integers, got: %{}", fn ->
        Array.put(array, %{}, :d)
      end
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
