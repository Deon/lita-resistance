# lita-resistance

[![Build Status](https://travis-ci.org/DeonHua/lita-resistance.svg?branch=master)](https://travis-ci.org/DeonHua/lita-resistance)
[![Gem Version](https://badge.fury.io/rb/lita-resistance.svg)](https://badge.fury.io/rb/lita-resistance)
[![Coverage Status](https://coveralls.io/repos/DeonHua/lita-resistance/badge.svg?branch=master&service=github)](https://coveralls.io/github/DeonHua/lita-resistance?branch=master)
[![Code Climate](https://codeclimate.com/github/DeonHua/lita-resistance/badges/gpa.svg)](https://codeclimate.com/github/DeonHua/lita-resistance)

Plays a game of resistance by assigning roles to users you mention in chat.

## Installation

Add lita-resistance to your Lita instance's Gemfile:

``` ruby
gem "lita-resistance"
```

## Usage

`lita resistance help` - Provides detailed help (this readme file)

`lita resistance N [users]` - Assigns the roles of spy/resistance to users you mention, with no special characters.

`lita resistance [CBSAFD] [users]` - Assigns special characters to the users mentioned, the remainder (if any) will receive 'vanilla' spy/resistance roles. 

### Special Characters
**Note:** The number of special characters chosen for each team must be less than the number of characters on that team. 

The number of spies is always (Players + 2)/3 **rounded down**. 

#### Resistance (Good)
Commander (**C**) - Knows all spies except Deep Cover.

Body Guard (**B**) - Knows Commander and False Commander.

#### Spies (Bad)

Blind Spy (**S**) - Doesn't know the other spies. The other spies don't know Blind Spy.

Assassin (**A**) - If Resistance successfully completes 3 missions, Assassin can guess Commander. If Assassin is correct, Spies win.

False Commander (**F**) - Appears as Commander to Bodyguard.

Deep Cover (**D**) - Does not appear as spy to Commander. If played with Commander and without Assassin, can take Assassin's role. 

### Examples (No Special Characters)

`lita resistance N @player1 @player2 @player3 @player4 @player5`

You don't need to include the `@` symbol:

`lita resistance N player1 player2 player3 player4 player5`

You can also do a combination of both:

`lita resistance N @player1 @player2 player3 player4 player5`

#### Special Characters

Assigns Assassin and Commander:

`lita resistance CA @player1 @player2 @player3 @player4 @player5`

[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)
