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

  @initial_capacity 8

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
  Creates an empty array.

  ## Examples

      iex> Array.new()
      #Array<[]>

  """
  @spec new() :: t()
  def new do
    make_array(@initial_capacity)
  end

  @spec make_array(capacity :: non_neg_integer()) :: t()
  defp make_array(capacity) do
    %__MODULE__{
      elements: :erlang.make_tuple(capacity, nil),
      size: 0,
      start: 0
    }
  end

  @doc """
  Creates an array from an enumerable.

  ## Examples

      iex> Array.new([:a, :b, :c])
      #Array<[:a, :b, :c]>

  """
  @spec new(enumerable :: Enumerable.t()) :: t()
  def new(enumerable) do
    Enum.into(enumerable, new())
  end

  @doc """
  Pushes an element to the end of an array.

  ## Examples

      iex> array = Array.new([:a, :b])
      iex> Array.push(array, :c)
      #Array<[:a, :b, :c]>

  """
  @spec push(array :: t(element), element :: element) :: t(element) when element: var
  def push(array, element)

  def push(array = %{elements: elements, size: size}, element)
      when size == tuple_size(elements) do
    array
    |> Enum.into(make_array(size * 2))
    |> push(element)
  end

  def push(array, element) do
    position = element_position(array, array.size)

    %{array | elements: put_elem(array.elements, position, element), size: array.size + 1}
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

  @doc """
  Converts an array to a list.

  ## Examples

      iex> array = Array.new([:a, :b, :c])
      iex> Array.to_list(array)
      [:a, :b, :c]

  """
  @spec to_list(array :: t(element)) :: [element] when element: var
  def to_list(array) do
    Enum.to_list(array)
  end

  defimpl Collectable do
    @impl Collectable
    def into(array) do
      {array, &collect/2}
    end

    @spec collect(array :: Array.t(element), command :: Collectable.command()) :: Array.t(element)
          when element: var
    defp collect(array, command)

    defp collect(array, {:cont, element}) do
      Array.push(array, element)
    end

    defp collect(array, command) when command in [:done, :halt] do
      array
    end
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
    def slice(array) do
      {:ok, Array.size(array), &Array.to_list(Array.slice(array, &1, &2))}
    end
  end
end
