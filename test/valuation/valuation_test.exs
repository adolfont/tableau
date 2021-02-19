defmodule ValuationTest do
  use ExUnit.Case

  def assert_key(map, key, expected) do
    assert Map.get(map, key) == expected
    map
  end

  test "Create an empty valuation" do
    v = Valuation.new()

    p = Formula.new(:atomic, :p)
    assert Valuation.value(v, p) == nil
  end

  test "Create a valuation for a formula" do
    p = Formula.new(:atomic, :p)
    v = Valuation.new(p, :t)

    assert Valuation.value(v, p) == :t
  end

  test "Create a valuation for two formulas" do
    p = Formula.new(:atomic, :p)
    q = Formula.new(:atomic, :q)
    v = Valuation.new(p, :t)
    v = Valuation.add(v, q, :f)

    assert Valuation.value(v, p) == :t
    assert Valuation.value(v, q) == :f

    # changes the valuation
    v = Valuation.add(v, p, :f)
    assert Valuation.value(v, p) == :f
  end

  test "Create a valuation for three formulas" do
    p = Formula.new(:atomic, :p)
    q = Formula.new(:atomic, :q)
    r = Formula.new(:atomic, :r)

    v =
      Valuation.new()
      |> Valuation.add(p, :t)
      |> assert_key(p, :t)
      |> Valuation.add(q, :f)
      |> assert_key(q, :f)
      |> Valuation.add(r, :t)
      |> assert_key(r, :t)
  end
end
