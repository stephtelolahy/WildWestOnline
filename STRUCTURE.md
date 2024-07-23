#  Clean+Redux architecture 

### Principles
- App = ∑ View(ViewState, ViewAction)
- ViewState = derive(AppState)
- ViewAction = extract(AppAction)
- AppState = ∑ State
- State = Reducer(State, Action)
- Action = Middleware(State, Action, Service)

### Core
- Actions
- State (+Builder)
- Reducers (+Extensions)
- Middlewares
- Models
- Services

### UI
- View (+Components)
- ViewState
- ViewActions
- Presenter

### Data
- Repositories
- LocalStorage
- Networking
