# chess

![screenshot.png](./screenshot.png)
The game of Kings, at the commandline.

## Project Info

This is a project assignment for [The Odin Project](https://theodinproject.com)

[Learn to Play](https://www.chess.com/learn-how-to-play-chess)

## Needed gem

To play this game, you will need to install the 'colorize' gem

`gem install colorize`

## Caveats

This game is functionally playable and done! There is no defined 'draw' condition at this point, though I'll likely get around to adding one eventually. I would also like to implement a way for users to delete save files from within the game without having to remove them by hand at the CLI.

However, this game meets the basic assignment spec from The Odin Project, so as stated before, it's functionally done.

One thing to look out for, as I currently have it written, there is a large lag spike within the game whenever a king is checked/checkmated because of the way I have to run the moves to test for the difference between check and mate. This is a known issue and I'm seeking advice for it - if you have any ideas, please sub an issue and let me know.

## Update

_August 30, 2024_

I have save management in and functional. You can delete save files and rename them. The string strips on input from the player, and it automatically appends the `.chess` file extension. In this case, `.chess` is just a marshalled dump of the Game object. This may not be the most secure way of saving/loading games, but it's within the spec of the Assignment, and I feel good about being able to implement it. If you inspect this code and see any issues or bugs with it, I ask that you submit an issue with the details on it - it can't hurt for me to be able to use this as a perpetual learning process. Who knows, maybe it will be an interesting on-going problem to play with.

I have decided that, barring some help from the fine people at #ruby-help in [TOP Discord](https://discord.gg/theodinproject) tracking down the issue with the lag, I'm going to move on from it in the curriculum. This may be just a one and done learning problem, and it has taught me a great deal about code in general and about OOP in a way that I've never thought about. To other TOP rubyists who may find this along the path of your journey in an effort to understand this particular problem set I would like to encourage you to stick with it. I am mentally exhausted from doing this project. It has taken everything I know about code up to this point to get to the end of it - at least good enough for an ending anyways.

### Advice for people attempting this problem

This is a hard project -- at least it was for me. Someone on discord mentioned a statistic that something like less than 3% of the people who finish TOP ruby path finish the chess project...I don't know how accurate that is or what metric was used, but I can believe it. I made the mistake of walking away due to burnout and then coming back at it later - without just resting then continuing the curriculum. I was ready to walk away from coding at that point because I didn't think I was capable of finishing it. I had to take a break and then of course RL stepped in and I got back around to re-attacking it later than I wanted. Time gave me perspective and I rewrote it from the ground up. I may eventually delete the old repo - it's [here](https://github.com/taladan/TOP-ruby-chess) for now as a stone in the field to remind me of where I was.

#### If this is you:

- Don't stop. Keep on it unless it's going to make you walk away.
- ...but don't just walk away permanently. Go on and come back to it later - **IT'S WORTH DOING**.
- If you're just frustrated - **KEEP GOING**.
- ask _good_ questions, listen to the answers.
- Help others with the stuff you're learning on discord
- Help especially when you don't feel like coding it keeps your material relevant and fresh so that it's near to hand when you're in need.
- Ask the dumb questions.
- Don't ask it if you can google it.
- You've got this.

### Takeaway

I have spent over a year and a half on this project (mostly off due to burn out and RL stuff) and it has been my Mount Everest up to this point. I have no doubt as I continue to learn and grow as a programmer this will turn out to have been just a foothill. It's not often you get to say a sincere and well-meant thanks to people who have helped you get to a certain point in a meaningful way. There are several people on the Discord that helped me along the way to this point. If I started naming names, I'd be here all night and it would be like some weird award ceremony where no one has actually won a prize. Suffice it to say that the community of The Odin Project is a place you should be hanging out if you're not. I would like to thank Carlos and Roli specifically. Their encouragement and patient advice has been an anchor and rudder to me in this project. Go buy 'em a coffee if you're in funds, they're worth it.

What else is there to say? I will likely come to terms with it not being perfect. Afterall, perfect is the enemy of done, and comparison the theif of joy. If you have questions, ask 'em and I'll try and answer them as best I can - I make no promises, I will likely have to dig through it to understand what in the world I was thinking if you ask me about it. That's okay, come ping me on discord if you have a Q about this.

I hope you enjoy!

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

#### What are you still doing here?

Seriously?

Okay, so you want to know what I'd add if I could?

- rejigger Display to work with curses/ncurses
- implement Scorecard: there's a start of a simple class for it, but I would have to do some lifting to get algebraic notation in
- implement a way that Chess could be played by multiple users on the same linux server
- set up a way for clients to connect to the server and play each other - either in a chroot setup or something similar.
- Graphical Client?!? (_....runs away laughing maniacally_)
