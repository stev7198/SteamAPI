#' steamR: An R Package for the Steam API Using httr2
#'
#' @description
#' The **steamR** package wraps key Steam Web API endpoints using httr2. It provides R functions to retrieve
#' user summaries, friend lists, owned games, game news, and global achievement statistics.
#' Each function performs the minimum wrangling necessary so that data is returned as a data frame or list.
#'
#' @details
#' This package requires a valid Steam API key to access the endpoints. It is cross-platform (Windows, Mac, and Linux).
#' All functions handle HTTP errors gracefully using httr2’s built-in retry and error handling. For more details on how
#' to use httr2, see its documentation.
#'
#' @section Future Plans:
#' \itemize{
#'   \item Expand support to include additional endpoints (e.g., Steam Store API for pricing and discount data).
#'   \item Implement caching and more sophisticated error logging.
#'   \item Develop interactive dashboards for data visualization.
#' }
#'
#' @name steamR
NULL

# Load required packages
if (!requireNamespace("httr2", quietly = TRUE)) {
  stop("Package 'httr2' is required. Please install it using install.packages('httr2').")
}
if (!requireNamespace("jsonlite", quietly = TRUE)) {
  stop("Package 'jsonlite' is required. Please install it using install.packages('jsonlite').")
}

#' Helper Function: steam_api_request
#'
#' This internal function creates and performs a GET request to the Steam API using httr2.
#' It adds query parameters, sets a retry policy, and parses the JSON response.
#'
#' @param url A character string with the API endpoint URL.
#' @param query_params A named list of query parameters.
#' @return A list with the parsed JSON response.
#' @keywords internal
# Helper Function: steam_api_request
# Helper Function: steam_api_request
steam_api_request <- function(url, query_params) {
  # Ensure all query parameters are named
  if (is.null(names(query_params)) || any(names(query_params) == "")) {
    stop("All components of query_params must be named.")
  }
  
  # Create the initial request object
  req <- httr2::request(url)
  
  # Use do.call() to pass the named query parameters into req_url_query
  req <- do.call(httr2::req_url_query, c(list(req), query_params))
  
  # Set a retry policy (up to 3 tries on transient errors)
  req <- httr2::req_retry(req, max_tries = 3)
  
  # Perform the request and capture the response
  resp <- httr2::req_perform(req)
  
  # Convert the response body to text and then parse the JSON
  content_text <- httr2::resp_body_string(resp)
  json_data <- jsonlite::fromJSON(content_text, simplifyDataFrame = TRUE)
  
  return(json_data)
}





#' Get Player Summaries
#'
#' Retrieves basic profile information (e.g., username, avatar, online status) for one or more Steam users.
#'
#' @param api_key Your Steam API key.
#' @param steam_ids A character vector of Steam IDs.
#' @return A list of player summaries.
#' @examples
#' \dontrun{
#'   get_player_summaries("YOUR_API_KEY", c("76561198000000000", "76561198000000001"))
#' }
#' @export
get_player_summaries <- function(api_key, steam_ids) {
  url <- "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/"
  query_params <- list(
    key = as.character(api_key),
    steamids = paste(as.character(steam_ids), collapse = ",") 
  )
  
  result <- steam_api_request(url, query_params)
  
  if (!is.null(result$response$players)) {
    return(result$response$players)
  } else {
    warning("No player summaries returned.")
    return(NULL)
  }
}


#' Get Friend List
#'
#' Retrieves the friend list for a specified Steam user. (Note: The user’s friend list must be public.)
#'
#' @param api_key Your Steam API key.
#' @param steam_id The Steam ID of the user.
#' @return A list of friend relationships.
#' @examples
#' \dontrun{
#'   get_friend_list("YOUR_API_KEY", "76561198000000000")
#' }
#' @export
get_friend_list <- function(api_key, steam_id) {
  url <- "http://api.steampowered.com/ISteamUser/GetFriendList/v0001/"
  query_params <- list(
    key = api_key,
    steamid = steam_id,
    relationship = "friend"
  )
  
  result <- steam_api_request(url, query_params)
  
  if (!is.null(result$friendslist$friends)) {
    return(result$friendslist$friends)
  } else {
    warning("No friend list returned.")
    return(NULL)
  }
}

#' Get Owned Games
#'
#' Retrieves the list of games owned by a Steam user, including playtime data.
#'
#' @param api_key Your Steam API key.
#' @param steam_id The Steam ID of the user.
#' @param include_appinfo Logical; if TRUE, includes additional game details.
#' @return A data frame containing the user's owned games.
#' @examples
#' \dontrun{
#'   get_owned_games("YOUR_API_KEY", "76561198000000000", include_appinfo = TRUE)
#' }
#' @export
get_owned_games <- function(api_key, steam_id, include_appinfo = TRUE) {
  url <- "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/"
  query_params <- list(
    key = api_key,
    steamid = steam_id,
    include_appinfo = as.integer(include_appinfo),
    format = "json"
  )
  
  result <- steam_api_request(url, query_params)
  
  if (!is.null(result$response$games)) {
    games_df <- as.data.frame(result$response$games, stringsAsFactors = FALSE)
    return(games_df)
  } else {
    warning("No owned games returned.")
    return(NULL)
  }
}

#' Get News for a Game
#'
#' Retrieves the latest news items for a specified game using its app ID.
#'
#' @param app_id The application ID of the game.
#' @param count The number of news items to retrieve (default is 3).
#' @param maxlength Maximum length in characters for each news item.
#' @return A data frame containing the news items.
#' @examples
#' \dontrun{
#'   get_news_for_app("440", count = 5, maxlength = 300)
#' }
#' @export
get_news_for_app <- function(app_id, count = 3, maxlength = 300) {
  url <- "http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/"
  query_params <- list(
    appid = app_id,
    count = count,
    maxlength = maxlength,
    format = "json"
  )
  
  result <- steam_api_request(url, query_params)
  
  if (!is.null(result$appnews$newsitems)) {
    news_df <- as.data.frame(result$appnews$newsitems, stringsAsFactors = FALSE)
    return(news_df)
  } else {
    warning("No news items returned.")
    return(NULL)
  }
}

#' Get Global Achievement Percentages for a Game
#'
#' Retrieves global achievement statistics for a specified game.
#'
#' @param app_id The application ID of the game.
#' @return A data frame containing achievement percentages.
#' @examples
#' \dontrun{
#'   get_global_achievement_percentages_for_app("440")
#' }
#' @export
get_global_achievement_percentages_for_app <- function(app_id) {
  url <- "http://api.steampowered.com/ISteamUserStats/GetGlobalAchievementPercentagesForApp/v0002/"
  query_params <- list(
    gameid = app_id,
    format = "json"
  )
  
  result <- steam_api_request(url, query_params)
  
  if (!is.null(result$achievementpercentages$achievements)) {
    achievements_df <- as.data.frame(result$achievementpercentages$achievements, stringsAsFactors = FALSE)
    return(achievements_df)
  } else {
    warning("No global achievement percentages returned.")
    return(NULL)
  }
}

#' Get Player Achievements
#'
#' Retrieves the achievements of a Steam user for a specific game.
#'
#' @param api_key Your Steam API key.
#' @param steam_id The Steam ID of the user.
#' @param app_id The application ID of the game.
#' @param language The language code for achievement names (default is "en").
#' @return A list of player achievements.
#' @examples
#' \dontrun{
#'   get_player_achievements("YOUR_API_KEY", "76561198000000000", "440")
#' }
#' @export
get_player_achievements <- function(api_key, steam_id, app_id, language = "en") {
  url <- "http://api.steampowered.com/ISteamUserStats/GetPlayerAchievements/v0001/"
  query_params <- list(
    key = api_key,
    steamid = steam_id,
    appid = app_id,
    l = language
  )
  
  result <- steam_api_request(url, query_params)
  
  if (!is.null(result$playerstats$achievements)) {
    return(result$playerstats$achievements)
  } else {
    warning("No player achievements returned.")
    return(NULL)
  }
}

#' Get User Stats for a Game
#'
#' Retrieves in-game statistics for a Steam user for a specific game.
#'
#' @param api_key Your Steam API key.
#' @param steam_id The Steam ID of the user.
#' @param app_id The application ID of the game.
#' @return A list of user statistics.
#' @examples
#' \dontrun{
#'   get_user_stats_for_game("YOUR_API_KEY", "76561198000000000", "440")
#' }
#' @export
get_user_stats_for_game <- function(api_key, steam_id, app_id) {
  url <- "http://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v0002/"
  query_params <- list(
    key = api_key,
    steamid = steam_id,
    appid = app_id,
    format = "json"
  )
  
  result <- steam_api_request(url, query_params)
  
  if (!is.null(result$playerstats$stats)) {
    return(result$playerstats$stats)
  } else {
    warning("No user stats returned.")
    return(NULL)
  }
}
