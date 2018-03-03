defmodule Dictionary do
  def word_list do
    "../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split()
  end

  def random_word do
    Enum.random(word_list())
  end
end
