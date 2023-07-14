# WildWestOnline

[![iOS starter workflow](https://github.com/stephtelolahy/WildWestOnline/actions/workflows/ios.yml/badge.svg?branch=main)](https://github.com/stephtelolahy/WildWestOnline/actions/workflows/ios.yml)

**Prototyping a game engine for the [Bang!](<https://en.wikipedia.org/wiki/Bang!_(card_game)>) card game**

**Trading card games**: a form of competitive activity played according to rules. it is turn based, cards have actions, cards have properties and cards have rules.
Currently, there is no good way to prototype trading card games and then be able to test the workings and the implications of rules in these games. 

**DSL**: Domain Specific Languages are computer languages designed for a specific domain. 
Since DSLs result in programs that are smaller and easier to understand, they allow even non-programmers to read, write and understand the language.

### Key Features

- [x] Game DSL
- [x] Serializable game object
- [x] Composable rules
- [x] Support classic Bang! and extensions
- [ ] Replay
- [ ] Hot reload
- [ ] Multiplayer online

### MetaModel

- **Game**: Global metaclass which contains all elements in a game.
- **Player**: Players who are participating in a game.
- **Rule**: Rules define the constraints of a game. Rules are either game-wide, or specific to one card.
- **Card**: Cards that are used in a game. Cards can have a cost, can have multiple properties, define additional rules, have actions that can be played and have side effects that happen when they are being played.
- **Action**: Cards can have actions on them. For example an ability of a card that can be activated.
- **Effect**: any change in the game state, applied when playing a card
- **Move**: any action taken by the player
- **Queue**: Commands queue
- **Sequence**: what begins when a Player Action is taken
- **Option**: a choice that have to be taken by player when resolving sequence

![](docs/architecture.png)

### Event solving

- The engine is event driven
- The process of resolving an event is similar to a depth-first search using a graph 
- Some effects may be blocked waiting user input. Then options are displayed through state


### Architecture

Redux architecture is meant to protect changes in an application’s state. It forces you to define clearly what state should be set when a specific action is dispatched.

- There is a single global state kept in store.
- State is immutable.
- New state can be set only by dispatching an action to store.
- New state can be calculated only by reducer which is a pure function.
- Store notifies subscribers by broadcasting a new state.
- It is best to separate each responsibility into different middleware. You can then easily enable or disable some features.

![](docs/redux.png)

### Sequence diagram

Online gameplay uses shared database

![](docs/sequence.png)


### Code duplication
Detect code duplication with [Periphery](https://github.com/kucherenko/jscpd/tree/master/packages/jscpd#html)

Run the following command on terminal from the project root

```
npx jscpd --reporters html ./Modules/Sources


open ./report/html/index.html
```
