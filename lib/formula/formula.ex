defmodule Formula do
  def new(:atomic, atom) when is_atom(atom) do
    atom
  end

  def new(:not, formula) do
    {:not, formula}
  end
end
