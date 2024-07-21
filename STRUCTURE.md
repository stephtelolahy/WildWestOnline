#  Clean+Redux architecture 

### Equations
- App = View(State)
- ViewState = Presenter(AppState)
- State = Reducer(State, Action)
- Action = Middleware(State, Action)

### Core
- State/ (+Builder)
- Reducers/ (+Extensions)
- Actions/
- Middlewares/
- Models/

### Data
- Repositories
- Utils

### UI
- ViewState/
- UiMiddleware/ #transform UI action to Core actions
- Presenter/
