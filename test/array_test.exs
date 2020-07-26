defmodule ArrayTest do
  use ExUnit.Case, async: true

  describe "Array.new/0" do
    test "creates an empty array" do
      assert Array.new() == %Array{}
    end
  end
end
