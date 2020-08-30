defmodule Array do
  @moduledoc """
  Array is an implementation of arrays in Elixir.

  This module is meant as a learning exercise, not an optimized data structure.
  """

  @typedoc """
  An array with elements of type `element`.
  """
  @opaque t(element) :: %__MODULE__{
            elements: {element} | tuple(),
            size: non_neg_integer(),
            start: non_neg_integer()
          }
  @typedoc """
  An array with elements of any type.
  """
  @type t() :: t(any())

  defstruct ~W[elements size start]a

  @spec element_position(t(), integer()) :: non_neg_integer()
  defp element_position(array, index) do
    capacity = tuple_size(array.elements)

    case rem(array.start + index, capacity) do
      remainder when remainder >= 0 ->
        remainder

      remainder ->
        remainder + capacity
    end
  end

  @doc """
  Shifts the first element from an array, returning it and the updated array.

  Returns :error if array is empty.

  ## Examples

      iex> array = Array.new([:z, :a, :b, :c])
      iex> {:ok, :z, new_array} = Array.shift(array)
      iex> new_array
      #Array<[:a, :b, :c]>

      iex> array = Array.new()
      iex> Array.shift(array)
      :error

  """
  @spec shift(array :: t(element)) :: {:ok, element, t(element)} | :error when element: var
  def shift(array)

  def shift(%{size: 0}) do
    :error
  end

  def shift(array) do
    element = elem(array.elements, array.start)
    new_array = %{array | size: array.size - 1, start: element_position(array, 1)}

    {:ok, element, new_array}
  end
end
