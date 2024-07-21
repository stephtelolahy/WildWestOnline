#  Clean+Redux architecture 

### Equations
- App = View(State)
- ViewState = Presenter(AppState)
- State = Reducer(State, Action)
- Action = Middleware(State, Action)

### Core
- Actions/
- State/ (+Builder)
- Reducers/ (+Extensions)
- Middlewares/
- Models/
- Services/

### UI
- View/ (+Components)
- ViewState/
- Presenter/
- ViewActions/
- Middlewares/ #transform UI action to Core actions, transform UI action to navigator action
https://github.com/reduxkotlin/NameGameSampleApp/tree/master/common/src/commonMain/kotlin/org/reduxkotlin/namegame/common/middleware

### Data
- Repositories/
- Utils/
