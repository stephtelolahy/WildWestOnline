# CardGameEngine

Prototyping a game engine for the [Bang](<https://en.wikipedia.org/wiki/Bang!_(card_game)>) card game.

### Features

- Engine is open source
- Powerful scripting language using JSON
- Card design is available using human readable data
- Any can play online using browser or mobile

## Data driven

- Game = State + Commands
- Move = Any action taken by the player
- Sequence = A Sequence is what begins when a Player Action is taken
- Effect = Any change in the game state = Action + Args + Context

## Effect solving

Effect may be blocked waiting user input.
=> show request input through state

## Architecture

### Layers

![](docs/dependency.png)

### Game objects

![](docs/data_structure.png)

### Sequence

![](docs/sequence.png)
