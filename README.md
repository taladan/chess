# chess

The game of Kings, at the commandline.

## Project Info

This is a project assignment for [The Odin Project](https://theodinproject.com)

[Learn to Play](https://www.chess.com/learn-how-to-play-chess)

### Initial thoughts
*01-24*

I have been calling this project a refactor as I've talked my way back up to doing it - sometimes you have to whistle past the graveyard to get to where you're going.  It's not really a refactor at all, more of a reattack of the initial problem set.  I've decided to completely scrap what I had before - the only thing I may crib for myself is the movement data for the pieces as I've already done those base calculations and figured out a workable targetting strategy for piece movement.

I intend to stay as far away from BST as possible, as my decision to use that as my storage structure last time added a layer of unnecessary abstraction.  That said, I've looked over a few others' solutions to the problem of Chess in ruby and have spotted a couple of takeaways that I'm considering implementing.  One of those ideas is using a Node object for square data, and just referencing the node object in an 8x8 2d array.  

### Movement cleanup
*08-24*

I have been horrible about updating the README.  YAY! I'm like 90% of the rest of github!

So, with the last branch I did, I was working on getting movement and threat stuff in.  I took a
break of about six months because I got stumped and RL intervened as it does. I finally made a
breakthrough and got all of movement in.  I have gotten in all piece movements, threat calculations,
castling and en passant.  I have **not** gotten check/checkmate in and was stumped for a couple of
days trying to decide how to implement it.  As I looked through my code more and more, I realized
(after some helpful advice from [@rlmoser](https://github.com/rlmoser99)) that I was letting my
classes get too large and unwieldy.  

I've struggled with areas of responsibility for a while in most of my projects with TOP, so it
should be no surprise that I'm struggling with this project as well. The current branch
(movement-cleanup) is an effort to break things out into sane areas of responsibility and atomicize
my code a bit more.  I believe this will help me understand where check/checkmate fits within my
thinking a bit better.


## MVP

A working game of chess that implements: 
- [ ] turn based play 
- [ ] displays
  - [ ] a chess board 
  - [ ] a list of moves
  - [ ] string data for output and input
- [ ] save and load game data
- [ ] calculate win state (checkmate/draw)
- [x] all piece moves 
- [x] calculate threatened state for a given square
