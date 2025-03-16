# tests/test_all.R

# Load the SteamAPI package
library(steamR)
print("If the test shows 403 Error, remember to use your own")
# Set your API key and Steam ID for testing
api_key <- "2E603E850E37D5636F36F229777BDB15"  # Replace with your actual API key
steam_id <- "76561198105405940"

cat("===== Testing get_player_summaries =====\n")
player_summaries <- get_player_summaries(api_key, steam_id)
print(player_summaries)

cat("\n===== Testing get_friend_list =====\n")
friend_list <- get_friend_list(api_key, steam_id)
print(friend_list)

cat("\n===== Testing get_owned_games =====\n")
owned_games <- get_owned_games(api_key, steam_id, include_appinfo = TRUE)
print(owned_games)

# For testing news and achievement endpoints, we need a valid app ID.
# We'll use app 440 (Team Fortress 2) as an example.
app_id <- "440"

cat("\n===== Testing get_news_for_app (app_id = 440) =====\n")
news <- get_news_for_app(app_id, count = 3, maxlength = 300)
print(news)

cat("\n===== Testing get_global_achievement_percentages_for_app (app_id = 440) =====\n")
global_achievements <- get_global_achievement_percentages_for_app(app_id)
print(global_achievements)

cat("\n===== Testing get_player_achievements (app_id = 440) =====\n")
player_achievements <- get_player_achievements(api_key, steam_id, app_id, language = "en")
print(player_achievements)

cat("\n===== Testing get_user_stats_for_game (app_id = 440) =====\n")
user_stats <- get_user_stats_for_game(api_key, steam_id, app_id)
print(user_stats)

cat("\n===== All tests completed. =====\n")
