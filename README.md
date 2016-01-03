# lita-resistance

[![Build Status](https://travis-ci.org/DeonHua/lita-resistance.png?branch=master)](https://travis-ci.org/DeonHua/lita-resistance)
[![Coverage Status](https://coveralls.io/repos/DeonHua/lita-resistance/badge.png)](https://coveralls.io/r/DeonHua/lita-resistance)

Plays a game of resistance by assigning roles to users you mention in chat.

## Installation

Add lita-resistance to your Lita instance's Gemfile:

``` ruby
gem "lita-resistance"
```

## Usage

`lita resistance [users]` - Assigns the roles of spy/resistance to users you mention.

### Example

`lita resistance @player1 @player2 @player3 @player4 @player5`

You don't need to include the `@` symbol:

`lita resistance player1 player2 player3 player4 player5`

You can also do a combination of both:

`lita resistance @player1 @player2 player3 player4 player5`

[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)