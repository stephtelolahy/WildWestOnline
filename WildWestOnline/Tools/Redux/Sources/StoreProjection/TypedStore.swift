//
//  ViewModel.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 22/07/2024.
//
import Combine

open class TypedStore<ViewState: Equatable, ViewAction>: ObservableObject {
    @Published public internal(set) var state: ViewState

    public init(_ state: ViewState) {
        self.state = state
    }

    public func dispatch(_ viewAction: ViewAction) {
    }
}

private class ViewModel<ViewState: Equatable, ViewAction, GlobalState: Equatable>: TypedStore<ViewState, ViewAction> {
    private let globalStore: Store<GlobalState>
    private let deriveState: (GlobalState) -> ViewState?
    private let embedAction: (ViewAction, GlobalState) -> Action

    init(
        globalStore: Store<GlobalState>,
        deriveState: @escaping (GlobalState) -> ViewState?,
        embedAction: @escaping (ViewAction, GlobalState) -> Action
    ) {
        guard let initialState = deriveState(globalStore.state) else {
            fatalError("failed mapping to local state")
        }

        self.globalStore = globalStore
        self.deriveState = deriveState
        self.embedAction = embedAction
        super.init(initialState)

        globalStore.$state
            .map(self.deriveState)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: &self.$state)
    }

    override func dispatch(_ viewAction: ViewAction) {
        let globalAction = embedAction(viewAction, globalStore.state)
        globalStore.dispatch(globalAction)
    }
}

public extension Store {
    /// Creates a subset of the current store by applying any transformation to the State.
    func projection<ViewState: Equatable, ViewAction>(
        _ deriveState: @escaping (State) -> ViewState?,
        _ embedAction: @escaping (ViewAction, State) -> Action
    ) -> TypedStore<ViewState, ViewAction> {
        ViewModel(
            globalStore: self,
            deriveState: deriveState,
            embedAction: embedAction
        )
    }
}
