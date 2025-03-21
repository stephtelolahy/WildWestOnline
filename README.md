# WildWestOnline

[![CI](https://github.com/stephtelolahy/WildWestOnline/actions/workflows/ios.yml/badge.svg)](https://github.com/stephtelolahy/WildWestOnline/actions/workflows/ios.yml)

**Prototyping a game engine for the [Bang!](<https://en.wikipedia.org/wiki/Bang!_(card_game)>) card game**

**Trading card games**: a form of competitive activity played according to rules. It is turn based, cards have properties and have rules.
Currently, there is no effective way to prototype trading card games and then be able to test the workings and the implications of rules in these games. 

**DSL**: Domain Specific Languages are computer languages designed for a specific domain. 
Since DSLs result in programs that are smaller and easier to understand, they allow even non-programmers to read, write and understand the language.

### Key Features

- [x] Game DSL
- [x] Serializable game object
- [x] Composable rules
- [x] Support classic Bang!
- [ ] Support extensions
- [ ] Replay
- [ ] Multiplayer online

### MetaModel

- **Game**: Global metaclass which contains all elements in a game.
- **Player**: Players who are participating in a game.
- **Card**: Cards that are used in a game. Cards can have multiple properties, define additional rules, have actions that can be played and have side effects that happen when they are being played.
- **Action**: Any action changing the game state. It can be performed by the user or by the system.
- **Effect**: Action applied when playing a card. An Effect may be resolved as a sequence of actions
- **Selector**: Selectors are used to specify which objects an effect should affect.

```mermaid
graph TD;
    GAME(Game) --> PLAYER(Player);
    GAME --> CARD(Card);
    GAME --> QUEUE(Queue);
    QUEUE --> ACTION(Action);
    ACTION --> ACTIONTYPE(ActionType);
    ACTION --> PAYLOAD(Payload);
    CARD --> EFFECT(Effect);
    EFFECT --> SELECTOR(Selector);
    EFFECT --> ACTIONTYPE;
```

### Event solving

- The process of resolving an event is similar to a depth-first search using a graph 
- Some effects may be blocked while waiting for user input. Then options are displayed through state.

```mermaid
graph TD;
    N1(1) --> N2(2);
    N2 --> N3(3);
    N2 --> N6(6);
    N3 --> N4(4);
    N3 --> N5(5);
    N6 --> N7(7);
    N6 --> X6(/);
    N1 --> X1(/);
```

### Modular Architecture

The project consists of Swift Package products with the following structure.
- All features are implemented in self-contained module `Core`
- `UI` and `Data` layers depend on `Core`

```mermaid
 graph TD;
    APP(App) --> UI(UI);
    APP --> DATA(Data);
    UI --> UILIBRARY(Library)
    UI --> CORE(Core);
    DATA --> CORE;
    DATA --> DATALIBRARY(Library)
```

### Redux

Redux architecture is meant to protect changes in an application’s state. It forces you to define clearly what state should be set when a specific action is dispatched.

- There is a single global state kept in store.
- State is immutable.
- New state can be set only by dispatching an action to store.
- New state can be calculated only by reducer which is a pure function.
- Store notifies subscribers by broadcasting a new state.
- Each side-effect is implemented as an asynchronous action.

```mermaid
graph TD;
  subgraph Main thread
    View --> Action
    Action --> Reducer
    Reducer --> State
    State --> View
  end
  subgraph Background thread
    Reducer --> Effect
    Effect --> Action
  end
```

#### Store projection
The app should have a single real Store, holding a single source-of-truth. 
However, we can "derive" this store to small subsets, called store projections, that will handle a smaller part of the state for each Screen. So we can map back-and-forth to the original store types.

```mermaid
flowchart TD
APP[App] --> APPSTORE(Store)
APP --> |compose| VIEW(View)
VIEW --> |observe| STOREPROJECTION(StoreProjection)
STOREPROJECTION --> |derive| APPSTORE
```

### Sequence diagram

Online gameplay uses shared database

```mermaid
sequenceDiagram
    User->>UI: event
    UI->>Engine: action
    Engine->>State: update
    State-->>UI: notify
    State-->>AI: notify
    AI->>Engine: action
    Engine->>State: update
    State-->>UI: notify
```
