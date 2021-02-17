defmodule FormulaTest do
  use ExUnit.Case

  test "Creating new atomic formulas" do
    assert Formula.new(:atomic, :p) == :p
    assert Formula.new(:atomic, :q) == :q
  end

  test "Creating new negated formulas" do
    not_p = Formula.new(:not, :p)

    assert not_p == {:not, :p}

    assert Formula.new(:not, not_p) == {:not, {:not, :p}}
  end
end
