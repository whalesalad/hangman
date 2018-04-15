defmodule TextClient.Interact do
  alias TextClient.{Player, State}

  def start() do
    Hangman.new_game
    |> setup_state
    |> play
  end

  def play(game) do
    Player.play(game)
  end

  defp setup_state(game) do
    %State{
      game_service: game,
      tally: Hangman.tally(game)
    }
  end
end
