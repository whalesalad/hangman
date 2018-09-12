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
      assert {^game, _} = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()
    {game, _} = Game.make_move(game, "x")

    assert game.game_state != :already_used
  end

  test "second occurrence of letter is already used" do
    game = Game.new_game()
    {game, _} = Game.make_move(game, "x")
    {game, _} = Game.make_move(game, "x")

    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    {game, _} = Game.new_game("wibble")
    |> Game.make_move("w")

    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a win is recognized" do
    game = Game.new_game("wibble")
    {game, _} = Game.make_move(game, "w")
    {game, _} = Game.make_move(game, "i")
    {game, _} = Game.make_move(game, "b")
    {game, _} = Game.make_move(game, "b")
    {game, _} = Game.make_move(game, "l")
    {game, _} = Game.make_move(game, "e")

    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "a bad guess is recognized" do
    game = Game.new_game("z")
    {game, _} = Game.make_move(game, "a")
    {game, _} = Game.make_move(game, "b")
    {game, _} = Game.make_move(game, "c")
    {game, _} = Game.make_move(game, "d")
    {game, _} = Game.make_move(game, "e")
    {game, _} = Game.make_move(game, "f")
    {game, _} = Game.make_move(game, "g")

    assert game.game_state == :lost
    assert game.turns_left == 0
  end

end
