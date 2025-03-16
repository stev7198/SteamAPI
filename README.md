# SteamAPI

Steam is a digital distribution platform mainly used for downloading, purchasing, and playing video games. You can also create games and join communities to discuss or play together. It combines aspects of a social network, video gaming, and video streaming. Steam is very popular, with a large user base and a wide variety of media available. Our proposal is to create and R package that will retrieve user data and relevant information from the site

## What It Needs:

1.  Steam API Key:

-    A valid Steam API key is required to authenticate requests to Steam’s Web API.

2.  R Environment & Dependencies:

-    The app is built using R and depends on httr2 and jsonlite libraries.

3.  Steam User Data:

-    To fetch personalized data (e.g., friend lists or owned games), the user’s Steam ID and appropriate privacy settings are necessary.

4.  Internet Connection:

-    Since the app interacts with remote API endpoints, a reliable internet connection is required.

## What It Does:

1.  Fetches Steam User Data:

-    Retrieves basic profile details using the GetPlayerSummaries endpoint.

2.  Retrieves Social Data:

-    Uses the GetFriendList endpoint to pull in a user’s friend network.

3.  Lists Owned Games:

-    Leverages the GetOwnedGames endpoint to display a user’s game library along with playtime statistics.

4.  Displays Game News:

-    Queries the GetNewsForApp endpoint to fetch the latest news or updates for a given game.

5.  Aggregates Achievement Information:

-    Utilizes endpoints like GetGlobalAchievementPercentagesForApp and GetPlayerAchievements to show both global and personal achievement data.

6.  Reports In-Game Statistics:

-    Calls the GetUserStatsForGame endpoint to gather detailed game statistics for the user.
