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

  @tag timeout: :infinity
  test "Only for visual debugging" do
    assert Tableau.prove([{:t, {:not, {:not, :a}}}, {:t, {:a, :implies, :b}}, {:f, :b}]) ==
             %Proof{
               branches: [
                 %Proof{
                   branches: [],
                   formulas: [
                     t: {:not, {:not, :a}},
                     t: {:a, :implies, :b},
                     f: :b,
                     f: {:not, :a},
                     t: :a,
                     f: :a
                   ],
                   status: :closed
                 },
                 %Proof{
                   branches: [],
                   formulas: [
                     t: {:not, {:not, :a}},
                     t: {:a, :implies, :b},
                     f: :b,
                     f: {:not, :a},
                     t: :a,
                     t: :b
                   ],
                   status: :closed
                 }
               ],
               formulas: [
                 t: {:not, {:not, :a}},
                 t: {:a, :implies, :b},
                 f: :b,
                 f: {:not, :a},
                 t: :a
               ],
               status: :closed
             }

    assert Tableau.prove(ProblemGenerator.php(3)).status == :closed

    php_3 = ProblemGenerator.php(3)
    assert Tableau.prove(php_3 -- [Enum.random(php_3)]).status == :open

    # IO.inspect(
    #   Printing.show_proof(Tableau.prove([{:t, {:a, :implies, :b}}, {:t, {:c, :implies, :d}}]))
    # )

    # assert Printing.show_proof(
    #          Tableau.prove([{:t, {:a, :implies, :b}}, {:t, {:c, :implies, :d}}])
    #        ) ==
    #          "oi"

    # assert Printing.show_proof(
    #         Tableau.prove([{:t, {:not, {:not, :a}}}, {:f, :a}, {:t, {:a, :implies, :b}}, {:f, :b}])
    #       ) == []

    # |> IO.inspect()

    # Tableau.prove([{:t, {:not, {:not, :b}}}, {:t, {:a, :implies, :b}}, {:f, :b}])
    # |> IO.inspect()
  end
end
