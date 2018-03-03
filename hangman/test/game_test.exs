defmodule GameTest do
  use ExUnit.Case
  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "state isn't changed for :won or :lost state" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert ^game = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()
    |> Game.make_move("x")

    assert game.game_state != :already_used
  end

  test "second occurrence of letter is already used" do
    game = Game.new_game()
    |> Game.make_move("x")
    |> Game.make_move("x")

    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    |> Game.make_move("w")

    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a win is recognized" do
    game = Game.new_game("wibble")
    |> Game.make_move("w")
    |> Game.make_move("i")
    |> Game.make_move("b")
    |> Game.make_move("b")
    |> Game.make_move("l")
    |> Game.make_move("e")

    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "a bad guess is recognized" do
    game = Game.new_game("z")
    |> Game.make_move("a")
    |> Game.make_move("b")
    |> Game.make_move("c")
    |> Game.make_move("d")
    |> Game.make_move("e")
    |> Game.make_move("f")
    |> Game.make_move("g")

    assert game.game_state == :lost
    assert game.turns_left == 0
  end

end