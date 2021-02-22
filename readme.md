
<p align="center">
<image src="https://i.ibb.co/BZSJh1s/Aspose-Words-861e54ae-b5f3-4bb3-8ae0-6f70c28c4a1b-001.png" />

<image src="https://i.ibb.co/0VHjscJ/Aspose-Words-861e54ae-b5f3-4bb3-8ae0-6f70c28c4a1b-002.png" />

</p>




# Connect4

To begin with, a few ideas were taken from the bubble dropping app that was done in class as a demon- stration. It provided the ideas behind the behaviors of tokens being dropped down. This app is based on the API provided by the AlphaConnect4 framework and that is basically responsible for handling the game session within the app.

The app has three screens, the initial screen where the user can play, a table view of past games and a replay screen where the user can see a replay of their games. When the user opens the app, they're invited to pick whether they would like to start or let the bot play, after which the user is guided using a white border outside the two circles below as to whose turn it is at the current time.

## The Board

The board is drawn using a CALayer. It has the width set to the width of the user's screen and height set to the height of six tokens. This allows the board to scale based on device. The wall has a corner radius to give it the rounded edges look.

After drawing the square for the board, I've utilised a mask layer over the board layer comprised of circles to cut holes in the layer, I've inversed the mask layer using llRule in order to make the areas that have circles be made transparent or more so invisible. This allows the tokens to be seen as they are falling down and have landed. When adding tokens to the view, they're sent behind the board layer.

I've used two functions, one is responsible for returning the paths for the vertical walls and the other for drawing the path of the base and returning it, this allows me to add physical barriers in order to enable collission.



When it is the user's turn, the tokens are dropped based on where the user clicks, this x-coordinate is converted to a column using basic maths and the move is then called to the game session. This makes the game feel more realistic with the bouncing o the walls when the user's placement is not exactly in the middle.

## Turn Indicator

There are two circles on the screen below the board that allows the user to see whose turn it is, the user is let known whose turn it is to play based on a border around the circle of the colour of the player. This app assumes that the bot is always playing red and that the user is playing yellow. For example, when it is the user's turn, the yellow circle becomes highlighted.

![](https://i.ibb.co/71yh3S2/Aspose-Words-861e54ae-b5f3-4bb3-8ae0-6f70c28c4a1b-005.png)

AnimatorDidPause (adp)

One of the core parts of this app is the animatordidpause, it allows me to know that the board is ready to continue. This is how the board knows when the bot should play. When it is the user's turn and the user has played and the (adp) has been called again, it makes the bot play. This is also how I verify if the tokens have nished falling post reset.

This section also handles when the game is nished, it takes a screenshot and calls the function that saves the game as a game object. This is also where the tokens are highlighted when the game is nished. This is done by calling a method on the view that adds a label to the token.

The screenshot is taken using a method that extends the UIView, this was found on stackoverow: https://stackoverow.com/a/52857151/3083988

Instead of taking the screenshot of the entire view, it was modied to take the screenshot of a subsec- tion of the view, otherwise this would have whitespace above and below. Providing the rect as an 'of' allows me to take a screenshot of only the board and save it.

This, along with other information of the game such as who won, how many turns did the user take and the list of tokens played are saved into core data at this time.

## Swipe to Reset

The game can be reset at any time using the swipe action or by pressing the refresh button on the top right of the screen, this removes all the barriers on the screen and drops all the tokens then it lets the user choose who gets to play, it resets the entire game. Instead of adding these through storyboard, they were added in using code as this seemed like a more simpler option. Either swipe calls the swipe method which handles the restarts.

## Historical Games Record

The past games section uses a table view, it displays all the games that the user has played that has nished along with who won and the number of moves the user took to either win or lose. The user can click on any of these rows and view a replay of the game.

![](https://i.ibb.co/VV2qm1J/Aspose-Words-861e54ae-b5f3-4bb3-8ae0-6f70c28c4a1b-008.png)

## Replay Games 

When the user clicks on a specific row, they are presented with a screen in which they are shown a replay of the game, this is done by dropping in tokens using a timer and the timer stops when all the tokens have done falling.

You can easily control the speed at which the token falls by changing the timer interval and in a future release of this app, this is going to be made into a setting where by the user can set the speed of the replays.

After they have done falling, like in the rst page - the tokens are highlighted if they are a part of the winning set of tokens and if not they are given a label with the order in which they were dropped. A message is displayed below to show who won.

