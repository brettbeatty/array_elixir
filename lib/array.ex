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
end
