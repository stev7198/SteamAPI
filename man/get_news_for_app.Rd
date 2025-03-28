% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/steamR.R
\name{get_news_for_app}
\alias{get_news_for_app}
\title{Get News for a Game}
\usage{
get_news_for_app(app_id, count = 3, maxlength = 300)
}
\arguments{
\item{app_id}{The application ID of the game.}

\item{count}{The number of news items to retrieve (default is 3).}

\item{maxlength}{Maximum length in characters for each news item.}
}
\value{
A data frame containing the news items.
}
\description{
Retrieves the latest news items for a specified game using its app ID.
}
\examples{
\dontrun{
  get_news_for_app("440", count = 5, maxlength = 300)
}
}
