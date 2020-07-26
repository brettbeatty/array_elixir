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

  @initial_capacity 8

  defstruct ~W[elements size start]a

  @doc """
  Deletes an element from an array by its index.

  Does nothing if index is out of bounds.

  ## Examples

      iex> array = Array.new([:a, :b, :c])
      iex> Array.delete(array, 1)
      #Array<[:a, :c]>

  """
  @spec delete(t(element), integer()) :: t(element) when element: var
  def delete(array, index) do
    size = array.size

    case normalize_index(array, index) do
      {:ok, index} when index * 2 < size ->
        shift_right(array, index - 1, element_position(array, index))

      {:ok, index} ->
        shift_left(array, index + 1, element_position(array, index))

      :error ->
        array
    end
  end

  @spec shift_right(t(element), integer(), non_neg_integer()) :: t(element) when element: var
  defp shift_right(array, index, prior_position)

  defp shift_right(array, -1, _prior_position) do
    %{array | size: array.size - 1, start: element_position(array, 1)}
  end

  defp shift_right(array, index, prior_position) do
    position = element_position(array, index)
    element = elem(array.elements, position)
    elements = put_elem(array.elements, prior_position, element)

    shift_right(%{array | elements: elements}, index - 1, position)
  end

  @spec shift_left(t(element), integer(), non_neg_integer()) :: t(element) when element: var
  defp shift_left(array, index, prior_position)

  defp shift_left(array = %{size: size}, size, _prior_position) do
    %{array | size: size - 1}
  end

  defp shift_left(array, index, prior_position) do
    position = element_position(array, index)
    element = elem(array.elements, position)
    elements = put_elem(array.elements, prior_position, element)

    shift_left(%{array | elements: elements}, index + 1, position)
  end

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
  Fetches an element from an array by its index.

  Array indices are integers. Fetching an index greater than or equal to the
  array's size or less than the size negative will return `:error`. Negative
  indices count from the end of the array.

  ## Examples

      iex> array = Array.new([:a, :b, :c])
      iex> Array.fetch(array, 2)
      {:ok, :c}

      iex> array = Array.new([:a, :b, :c])
      iex> Array.fetch(array, 3)
      :error

  """
  @spec fetch(t(element), integer()) :: {:ok, element} | :error when element: var
  def fetch(array, index) do
    case normalize_index(array, index) do
      {:ok, index} ->
        {:ok, elem(array.elements, element_position(array, index))}

      :error ->
        :error
    end
  end

  @spec normalize_index(t(), integer()) :: {:ok, non_neg_integer()} | :error
  defp normalize_index(array, index)

  defp normalize_index(_array, index) when not is_integer(index) do
    raise ArgumentError, "array indices must be integers, got: #{inspect(index)}"
  end

  defp normalize_index(%{size: size}, index) when index >= -size and index < 0 do
    {:ok, index + size}
  end

  defp normalize_index(%{size: size}, index) when index >= 0 and index < size do
    {:ok, index}
  end

  defp normalize_index(_array, _index) do
    :error
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

  @spec make_array(pos_integer()) :: t()
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
  @spec new(Enumerable.t()) :: t()
  def new(enumerable) do
    Enum.into(enumerable, new())
  end

  @doc """
  Pops an element from an array by its index.

  ## Examples

      iex> array = Array.new([:a, :b, :c])
      iex> {:b, new_array} = Array.pop(array, 1)
      iex> new_array
      #Array<[:a, :c]>

  """
  @spec pop(t(element), integer()) :: {element | nil, t(element)} when element: var
  def pop(array, index) do
    {array[index], delete(array, index)}
  end

  @doc """
  Appends an element to an array.

  ## Examples

      iex> array = Array.new([:a, :b])
      iex> Array.push(array, :c)
      #Array<[:a, :b, :c]>

  """
  @spec push(t(element), element) :: t(element) when element: var
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
  Puts an element into an array at an index.

  Does nothing if index is out of array bounds.

  ## Examples

      iex> array = Array.new([:a, :a, :c])
      iex> Array.put(array, 1, :b)
      #Array<[:a, :b, :c]>

      iex> array = Array.new([:a, :b, :c])
      iex> Array.put(array, 3, :d)
      #Array<[:a, :b, :c]>

  """
  @spec put(t(element), integer(), element) :: t(element) when element: var
  def put(array, index, element) do
    case normalize_index(array, index) do
      {:ok, index} ->
        position = element_position(array, index)
        elements = put_elem(array.elements, position, element)
        %{array | elements: elements}

      :error ->
        array
    end
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

  defimpl Inspect do
    import Inspect.Algebra, only: [concat: 1, to_doc: 2]

    @impl Inspect
    def inspect(array, opts) do
      concat(["#Array<", to_doc(Array.to_list(array), opts), ">"])
    end
  end
end
