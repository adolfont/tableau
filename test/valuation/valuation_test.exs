defmodule ValuationTest do
  use ExUnit.Case

  test "Create a valuation for a formula" do
    p = Formula.new(:atomic, :p)
    v = Valuation.new(p, :t)

    assert Valuation.value(v, p) == :t
  end
end
