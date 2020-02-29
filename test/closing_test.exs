defmodule ClosingTest do
  use ExUnit.Case

  test "All tests related to Closing.are_opposite?" do
    assert Closing.are_opposite?({:t, :a}, {:f, :a})
    assert Closing.are_opposite?({:f, :a}, {:t, :a})
    assert not Closing.are_opposite?({:f, :a}, {:t, :b})
    assert not Closing.are_opposite?({:t, :a}, {:t, :b})
  end

  test "All tests related to Closing.is_closed?" do
    assert not Closing.is_closed?([{:t, :a}, {:t, :b}])
    assert Closing.is_closed?([{:t, :a}, {:t, :b}, {:f, :a}])
    assert not Closing.is_closed?([{:t, :a}, {:t, :b}, {:f, :c}])
    assert Closing.is_closed?([{:t, :a}, {:t, :b}, {:f, :c}, {:f, :b}])
  end
end
