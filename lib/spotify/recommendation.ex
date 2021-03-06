defmodule Spotify.Recommendation do
  @moduledoc """
  Spotify can make recommendations for you by providing seed data. The
  recommendation comes with tracks and the seed object

  *Note: The possibilities here are quite large. Please read the spotify documentation.

  https://developer.spotify.com/web-api/get-recommendations/
  """
  use Responder
  @behaviour Responder
  import Helpers
  alias Spotify.{Client, Seed, Recommendation, Track}
  defstruct ~w[tracks seeds]a

  @doc """
  Create a playlist-style listening experience based on seed artists, tracks and genres.

  **The response generated by this can vary. Your milage may vary. Because of this, you may want
  to use `get_recommendations_url` and use your own implementation for this function.**

  [Spotify Documentation](https://developer.spotify.com/web-api/get-recommendations/)

  **Method**: `GET`

  **Params**: **The params for this endpoint are complex. Refer to spotify docs**

      Spotify.Recommendation.get_recommendations(seed_artists: "1,2" energy: "6")
      # => { :ok, %Recommendation{tracks: tracks, seeds: seeds} }
  """
  def get_recommendations(conn, params) do
    url = get_recommendations_url(params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Create a playlist-style listening experience based on seed artists, tracks and genres.

      iex> Spotify.Recommendation.get_recommendations_url(limit: 5)
      "https://api.spotify.com/v1/recommendations?limit=5"
  """
  def get_recommendations_url(params) do
    "https://api.spotify.com/v1/recommendations" <> query_string(params)
  end

  @doc """
  Implements the hook required by the `Responder` behavior.
  """
  def build_response(body) do
    seeds = Enum.map(body["seeds"], &to_struct(Seed, &1))
    tracks = Enum.map(body["tracks"], &to_struct(Track, &1))

    %Recommendation{tracks: tracks, seeds: seeds}
  end
end

