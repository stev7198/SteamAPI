% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/steamR.R
\name{get_user_stats_for_game}
\alias{get_user_stats_for_game}
\title{Get User Stats for a Game}
\usage{
get_user_stats_for_game(api_key, steam_id, app_id)
}
\arguments{
\item{api_key}{Your Steam API key.}

\item{steam_id}{The Steam ID of the user.}

\item{app_id}{The application ID of the game.}
}
\value{
A list of user statistics.
}
\description{
Retrieves in-game statistics for a Steam user for a specific game.
}
\examples{
\dontrun{
  get_user_stats_for_game("YOUR_API_KEY", "76561198000000000", "440")
}
}
