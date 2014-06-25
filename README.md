Twitter
=

A simple iOS 7 Twitter client. It allows you to view your home timeline (with infinite scrolling), compose new tweets, and view/reply to existing tweets.

Time spent: ~10 hours

Completed user stories
-

 * [x] Required: User can sign in using OAuth login flow
 * [x] Required: User can view last 20 tweets from their home timeline
 * [x] Required: The current signed in user will be persisted across restarts
 * [x] Required: In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
 * [x] Required: User can pull to refresh
 * [x] Required: User can compose a new tweet by tapping on a compose button.
 * [x] Required: User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
 * [x] Optional: When composing, you should have a countdown in the upper right for the tweet limit.
 * [x] Optional: After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
 * [x] Optional: When composing, you should have a countdown in the upper right for the tweet limit.
 * [x] Optional: Replies should be prefixed with the username and the reply_id should be set when posting the tweet.
 * [x] Optional: User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

Notes
-

- I didn't handle network errors but tried to put in TODOs explaining what I would have done.
- I implemented a separate function for different types of home timeline API requests (initial load, refreshing the top of the list, and loading more at the bottom). I'm not sure if having a single function that takes in params would have been preferable.
- Some of my client methods got pretty ugly with lots of nesting. Is that generally expected or is it standard to separate out some of the inner stuff into separate functions?

CocoaPods
-

- AFNetworking (for API requests and image loading)
- BDBOAuth1Manager (for authentication)
- Mantle (for model classes)
- MBProgressHUD (for loading spinner)
- DateTools (for date formatting)
- SVPullToRefresh (for pull to refresh and infinite scroll)

Walkthrough
-

![Video Walkthrough](demo.gif)
