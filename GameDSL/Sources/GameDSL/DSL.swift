import Foundation

public extension Game {
    init(@AttributeBuilder attr: () -> [Attribute]) {
        self.attr = attr()
    }
}

public extension Player {
    init(_ id: String, @AttributeBuilder _ attr: () -> [Attribute] = { [] }) {
        self.id = id
        self.attr = attr()
    }
}

public extension Card {
    init(_ id: String, @CardActionBuilder actions: () -> [CardAction] = { [] }) {
        self.id = id
        self.actions = actions()
        self.attr = []
    }

    func attr(@AttributeBuilder attr: () -> [Attribute]) -> Self {
        .init(id: id, actions: actions, attr: attr())
    }
}

public extension Effect {

    func active(@RequirementBuilder requirements: () -> [Requirement] = { [] }) -> CardAction {
        CardAction(effect: self,
                   type: .active,
                   requirements: requirements())
    }

    func triggered(@RequirementBuilder requirements: () -> [Requirement]) -> CardAction {
        CardAction(effect: self,
                   type: .triggered,
                   requirements: requirements())
    }
}
