# WildWestOnline

**Prototyping a game engine for the [Bang!](<https://en.wikipedia.org/wiki/Bang!_(card_game)>) card game**

**Trading card games**: a form of competitive activity played according to rules. It is turn based, cards have properties and have rules.
Currently, there is no good way to prototype trading card games and then be able to test the workings and the implications of rules in these games. 

**DSL**: Domain Specific Languages are computer languages designed for a specific domain. 
Since DSLs result in programs that are smaller and easier to understand, they allow even non-programmers to read, write and understand the language.

### Key Features

- [x] Game DSL
- [x] Serializable game object
- [x] Composable rules
- [ ] Support classic Bang! and extensions
- [ ] Replay
- [ ] Hot reload
- [ ] Multiplayer online

### MetaModel

- **Game**: Global metaclass which contains all elements in a game.
- **Player**: Players who are participating in a game.
- **Rule**: Rules define the constraints of a game. Rules are either game-wide, or specific to one card.
- **Card**: Cards that are used in a game. Cards can have multiple properties, define additional rules, have actions that can be played and have side effects that happen when they are being played.
- **Action**: Any action changing the game state. It can be performed by the user or by the system.
- **Effect**: Action applied when playing a card. An Effect may be resolved as a sequence of actions
- **Option**: a choice that have to be taken by player when resolving sequence

![](Docs/metamodel.png)

### Event solving

- The engine is event driven
- The process of resolving an event is similar to a depth-first search using a graph 
- Some effects may be blocked waiting user input. Then options are displayed through state

![](Docs/eventresolving.png)

#### Modular Architecture

The project is composed of SwiftPackage products with the following structure. 

![](Docs/modular.png)


### Redux Architecture

Redux architecture is meant to protect changes in an application’s state. It forces you to define clearly what state should be set when a specific action is dispatched.

- There is a single global state kept in store.
- State is immutable.
- New state can be set only by dispatching an action to store.
- New state can be calculated only by reducer which is a pure function.
- Store notifies subscribers by broadcasting a new state.
- Each side-effect is implemented into different middleware. You can then easily enable or disable some features.

![](Docs/redux.png)

#### Store projection
The app should have a single real Store, holding a single source-of-truth. 
However, we can "derive" this store to small subsets, called store projections, that will handle a smaller part of the state for each screen. So we can map back-and-forth to the original store types.

### Sequence diagram

Online gameplay uses shared database

![](Docs/sequence.png)
