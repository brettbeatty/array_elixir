defmodule Array do
  @moduledoc """
  Array is an implementation of arrays in Elixir.

  This module is meant as a learning exercise, not an optimized data structure.
  """
  @type t() :: t(any())
  @type t(_element) :: %__MODULE__{
          elements: tuple(),
          size: non_neg_integer(),
          start: non_neg_integer()
        }

  defstruct elements: :erlang.make_tuple(8, nil), size: 0, start: 0

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
    %__MODULE__{}
  end

  @doc """
  Creates an array from an enumerable.

  ## Examples

      iex> Array.new([:a, :b, :c])
      #Array<[:a, :b, :c]>

  """
  @spec new(Enumerable.t()) :: t()
  def new(enumerable) do
    Enum.into(enumerable, new())
  end

  @doc """
  Appends an element to an array.

  ## Examples

      iex> array = Array.new([:a, :b])
      iex> Array.push(array, :c)
      #Array<[:a, :b, :c]>

  """
  @spec push(t(element), element) :: t(element) when element: var
  def push(array, element) do
    position = element_position(array, array.size)

    %{array | elements: put_elem(array.elements, position, element), size: array.size + 1}
  end

  @doc """
  Removes the first element from an array.

  Returns :error if array is empty.

  ## Examples

      iex> array = Array.new([:a, :b, :c])
      iex> {:a, new_array} = Array.shift(array)
      iex> new_array
      #Array<[:b, :c]>

      iex> array = Array.new()
      iex> Array.shift(array)
      :error

  """
  @spec shift(t(element)) :: {element, t(element)} | :error when element: var
  def shift(array)

  def shift(%{size: 0}) do
    :error
  end

  def shift(array) do
    element = elem(array.elements, array.start)
    new_array = %{array | size: array.size - 1, start: element_position(array, 1)}

    {element, new_array}
  end

  @doc """
  Converts an array to a list of its elements.

  ## Examples

      iex> array = Array.new([:a, :b, :c])
      iex> Array.to_list(array)
      [:a, :b, :c]

  """
  @spec to_list(t(element)) :: [element] when element: var
  def to_list(array) do
    Enum.to_list(array)
  end

  defimpl Collectable do
    @impl Collectable
    def into(array) do
      {array, &collect/2}
    end

    @spec collect(Array.t(element), Collectable.command()) :: Array.t(element) when element: var
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
      {:ok, array.size}
    end

    @impl Enumerable
    def member?(_array, _element) do
      {:error, __MODULE__}
    end

    @impl Enumerable
    def reduce(array, acc, fun)

    def reduce(_array, {:halt, acc}, _fun) do
      {:halted, acc}
    end

    def reduce(array, {:suspend, acc}, fun) do
      {:suspended, acc, &reduce(array, &1, fun)}
    end

    def reduce(array, {:cont, acc}, fun) do
      case Array.shift(array) do
        {element, new_array} ->
          reduce(new_array, fun.(element, acc), fun)

        :error ->
          {:done, acc}
      end
    end

    @impl Enumerable
    def slice(_array) do
      {:error, __MODULE__}
    end
  end
end
