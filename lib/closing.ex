defmodule Closing do
  def are_opposite?({:t, formula}, {:f, formula}) do
    true
  end

  def are_opposite?({:f, formula}, {:t, formula}) do
    true
  end

  def are_opposite?(_, _), do: false

  def is_closed?([_]) do
    false
  end

  def is_closed?([head | tail]) do
    Enum.any?(tail, fn formula -> are_opposite?(head, formula) end) or
      is_closed?(tail)
  end
end

# Closing.are_opposite?({:t, :a}, {:f, :a})
# Closing.are_opposite?({:f, :a}, {:t, :a})
# Closing.are_opposite?({:f, :a}, {:t, :b})
# Closing.are_opposite?({:t, :a}, {:t, :b})
# Closing.is_closed?([{:t, :a}, {:t, :b}])
# Closing.is_closed?([{:t, :a}, {:t, :b}, {:f, :a}])
# Closing.is_closed?([{:t, :a}, {:t, :b}, {:f, :c}])
# Closing.is_closed?([{:t, :a}, {:t, :b}, {:f, :c}, {:f, :b}])

