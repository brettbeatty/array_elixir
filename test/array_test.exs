defmodule ArrayTest do
  use ExUnit.Case, async: true

  describe "Array.new/0" do
    test "creates an empty array" do
      assert Array.new() == %Array{}
    end
  end

  describe "Array.push/2" do
    test "appends an element to an array" do
      array = %Array{elements: {nil, nil, :a, :b}, size: 2, start: 2}
      expected = %Array{elements: {:c, nil, :a, :b}, size: 3, start: 2}

      assert Array.push(array, :c) == expected
    end
  end

  describe "Collectable" do
    test "collects elements into an array" do
      array = %Array{elements: {nil, nil, nil, :a}, size: 1, start: 3}
      expected = %Array{elements: {:b, :c, nil, :a}, size: 3, start: 3}

      assert Enum.into([:b, :c], array) == expected
    end
  end
end
