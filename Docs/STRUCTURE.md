


# Adopted best practices
- [x] Use a modular architecture
- [x] Keep it Simple
- [x] Follow Principle of Separation of Concerns
- [ ] Consider all performance parameters
- [x] Layered Architecture
- [x] Decompose by Domain
- [ ] Event Sourcing
- [ ] Follow the Idempotence Principle



# Modules structure

### Core
- XState.swift
    - struct State
    - static let State.reducer
    - static let State.middleware
    - class State.Builder
- XAction.swift
- XService.swift

### UI
- XView.swift
    - struct View
    - struct Previews
- XViewModel.swift
    - struct State
    - static let deriveState

### Data
- XRepository.swift