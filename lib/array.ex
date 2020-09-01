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

  @doc """
  Returns the size of an array.

  ## Examples

      iex> array = Array.new([:a, :b, :c])
      iex> Array.size(array)
      3

  """
  @spec size(array :: t()) :: non_neg_integer()
  def size(array) do
    array.size
  end

  @doc """
  Slices an array with `size` elements from the old array starting at `index`.

  ## Examples

      iex> array = Array.new([:y, :z, :a, :b, :c, :d])
      iex> Array.slice(array, 2, 3)
      #Array<[:a, :b, :c]>

      iex> array = Array.new([:z, :a, :b, :c])
      iex> Array.slice(array, 1, 7)
      #Array<[:a, :b, :c]>

  """
  @spec slice(array :: t(element), start :: non_neg_integer(), size :: non_neg_integer()) ::
          t(element)
        when element: var
  def slice(array, start, size) do
    %{array | start: element_position(array, start), size: min(size, array.size - start)}
  end

  defimpl Enumerable do
    @impl Enumerable
    def count(array) do
      {:ok, Array.size(array)}
    end

    @impl Enumerable
    def member?(_array, _element) do
      {:error, __MODULE__}
    end

    @impl Enumerable
    def reduce(array, acc, fun)

    def reduce(array, {:cont, acc}, fun) do
      case Array.shift(array) do
        {:ok, element, new_array} ->
          reduce(new_array, fun.(element, acc), fun)

        :error ->
          {:done, acc}
      end
    end

    def reduce(_array, {:halt, acc}, _fun) do
      {:halted, acc}
    end

    def reduce(array, {:suspend, acc}, fun) do
      {:suspended, acc, &reduce(array, &1, fun)}
    end

    @impl Enumerable
    def slice(_array) do
      {:error, __MODULE__}
    end
  end
end
