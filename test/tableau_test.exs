defmodule TableauTest do
  use ExUnit.Case
  doctest Tableau
  doctest Linear

  test "apply all linear rules to a list" do
    linear_example = [
      {:t, {:not, :a}},
      {:f, {:not, :a}},
      {:t, {:c, :and, :d}},
      {:f, {:e, :or, :g}},
      {:f, {:h, :implies, :i}}
    ]

    expected_result = [f: :a, t: :a, t: :c, t: :d, f: :e, f: :g, t: :h, f: :i]

    assert Linear.apply_all_linear_once(linear_example) == expected_result
  end

  test "apply all linear rules recursively" do
    linear_example_2 = [
      {:t, {:not, {:not, :a}}},
      {:t, {:c, :and, {:d, :and, :g}}},
      {:f, {:u, :and, :u}}
    ]

    expected_result = [
      t: {:not, {:not, :a}},
      t: {:c, :and, {:d, :and, :g}},
      f: {:u, :and, :u},
      f: {:not, :a},
      t: :c,
      t: {:d, :and, :g},
      t: :a,
      t: :d,
      t: :g
    ]

    assert Linear.apply_all_linear_recursively(linear_example_2) == expected_result
  end
end
