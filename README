# rchess

The game of Kings, at the commandline.

## Project Info

This is a project assignment for [The Odin Project](https://theodinproject.com)

[Learn to Play](https://www.chess.com/learn-how-to-play-chess)

### Initial thoughts

I have been calling this project a refactor as I've talked my way back up to doing it - sometimes you have to whistle past the graveyard to get to where you're going.  It's not really a refactor at all, more of a reattack of the initial problem set.  I've decided to completely scrap what I had before - the only thing I may crib for myself is the movement data for the pieces as I've already done those base calculations and figured out a workable targetting strategy for piece movement.

I intend to stay as far away from BST as possible, as my decision to use that as my storage structure last time added a layer of unnecessary abstraction.  That said, I've looked over a few others' solutions to the problem of Chess in ruby and have spotted a couple of takeaways that I'm considering implementing.  One of those ideas is using a Node object for square data, and just referencing the node object in an 8x8 2d array.  

My MVP for this project is:

A working game of chess that implements: 
- [ ] all piece moves 
- [ ] turn based play 
- [ ] displays
  - [ ] a chess board 
  - [ ] a list of moves
  - [ ] string data for output and input
- [ ] save and load game data
- [ ] calculate win state (checkmate/draw)
- [ ] calculate threatened state for a given square