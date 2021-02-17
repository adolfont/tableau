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

  test "Creating new binary formulas" do
    p = Formula.new(:atomic, :p)
    q = Formula.new(:atomic, :q)
    assert Formula.new(p, :and, q) == {:p, :and, :q}
    assert Formula.new(p, :or, q) == {:p, :or, :q}
    assert Formula.new(p, :implies, q) == {:p, :implies, :q}
  end

  test "Verifies if an expression is a well-formed formula" do
    p = Formula.new(:atomic, :p)
    q = Formula.new(:atomic, :q)
    assert Formula.well_formed_formula?(Formula.new(p, :and, q))
    refute Formula.well_formed_formula?({p, q})
  end
end
