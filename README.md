# WildWestOnline

Prototyping a game engine for the [Bang!](<https://en.wikipedia.org/wiki/Bang!_(card_game)>) card game.

### Features

- [ ] Powerful scripting language using JSON 
- [ ] Support classic Bang! and extensions
- [ ] Play online

## Terminology
- Engine: game interface
- Queue: events queue
- State: bunch of data describing the game
- Card: card abilities as data
- Effect: any change in the game state, applied with argument
- Move: any action taken by the player
- Sequence: what begins when a Player Action is taken
- Option: a choice that have to be taken by player when resolving sequence

## Event solving

- It is important to mention that the engine is event driven
- The process of resolving an event is similar to a depth-first search using a graph 
- Some effects may be blocked waiting user input. Then options are displayed through state

## Architecture

### Sequence

![](docs/sequence.png)

### Layers

![](docs/dependency.png)

### Game objects

![](docs/data_structure.png)
