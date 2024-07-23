#  Clean+Redux architecture 

### Principles
- App = View(State)
- ViewState = Presenter(AppState)
- State = Reducer(State, Action)
- Action = Middleware(State, Action)

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
