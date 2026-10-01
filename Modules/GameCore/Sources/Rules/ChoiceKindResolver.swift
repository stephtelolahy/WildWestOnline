//
//  ChoiceKindResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 01/11/2024.
//
extension Card.Selector.ChoiceKind {
    func resolve(status: Card.Selector.ChoiceStatus, pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
        switch status {
        case .notDetermined:
            return try resolveOptions(pendingAction, state: state)

        case .prompted:
            fatalError("Should not resolve a prompted choice")

        case .selected(let selection, let prompt):
            guard let selectionValue = prompt.options.first(where: { $0.label == selection })?.id else {
                fatalError("Selection \(selection) not found in prompted choice")
            }

            return resolveSelection(selectionValue, pendingAction: pendingAction, state: state)
        }
    }
}

extension Card.Selector.ChoiceKind {
    func resolveOptions(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
        let player = pendingAction.sourcePlayer
        switch self {
        case .target(let requirements):
            let targetPlayers = state.playOrder
                .starting(with: player)
                .dropFirst()
                .filter { requirements.match($0, pendingAction: pendingAction, state: state) }
            guard targetPlayers.isNotEmpty else {
                throw .noChoosableTarget(requirements)
            }

            return [pendingAction.withChoice(self, prompt: .init(chooser: player, choices: Array(targetPlayers)))]

        case .card(let requirement):
            let prompt = try requirement.resolve(pendingAction: pendingAction, state: state)
            return [pendingAction.withChoice(self, prompt: prompt)]

        case .costCard(let conditions):
            let target = pendingAction.requiredTarget
            let costCards = state.players.get(target).hand.filter {
                conditions.match($0, pendingAction: pendingAction, state: state) && $0 != pendingAction.sourceCard
            }
            guard costCards.isNotEmpty else {
                throw .noChoosableCard(conditions, player: target)
            }

            return [pendingAction.withChoice(self, prompt: .init(chooser: player, choices: costCards))]

        case .counterCard(let conditions), .redirectCard(let conditions):
            let target = pendingAction.requiredTarget
            let cards = state.players.get(target).hand.filter {
                conditions.match($0, pendingAction: pendingAction, state: state)
            }
            guard cards.isNotEmpty else {
                return [pendingAction]
            }

            return [pendingAction.withChoice(self, prompt: .init(chooser: target, choices: cards))]

        case .playedCard(let conditions):
            let playedCards = state.players.get(player).hand.filter {
                conditions.match($0, pendingAction: pendingAction, state: state)
            }
            guard playedCards.isNotEmpty else {
                throw .noChoosableCard(conditions, player: player)
            }

            return [pendingAction.withChoice(self, prompt: .init(chooser: player, choices: playedCards))]
        }
    }

    func resolveSelection(_ selection: String, pendingAction: GameFeature.Action, state: GameFeature.State) -> [GameFeature.Action] {
        let isPass = selection == .choicePass
        switch self {
        case .target:
            return isPass ? [] : [pendingAction.copy(targetedPlayer: selection)]

        case .card:
            return isPass ? [] : [pendingAction.copy(targetedCard: selection, state: state)]

        case .costCard:
            return isPass ? [] : [.discardHand(selection, player: pendingAction.requiredTarget), pendingAction]

        case .counterCard:
            return isPass ? [pendingAction] : [.discardHand(selection, player: pendingAction.requiredTarget)]

        case .redirectCard:
            guard !isPass else {
                return [pendingAction]
            }

            let reversedAction = pendingAction.copy(
                withPlayer: pendingAction.targetedPlayer,
                targetedPlayer: pendingAction.sourcePlayer,
                selectors: [.choose(self)] + pendingAction.selectors
            )
            return [.discardHand(selection, player: pendingAction.requiredTarget), reversedAction]

        case .playedCard(let conditions):
            guard !isPass else {
                return []
            }

            let alias = conditions.contains(.canCounterShot)
                ? state.alias(for: Card.name(of: selection), player: pendingAction.sourcePlayer, action: .counterShot, on: .played)
                : nil
            return [pendingAction.copy(playedCard: selection, alias: alias)]
        }
    }
}

extension Array where Element == Card.Selector.PlayerRequirement {
    func match(_ player: String, pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
        allSatisfy {
            $0.match(player, pendingAction: pendingAction, state: state)
        }
    }
}

extension Array where Element == Card.Selector.CardFilter {
    func match(_ card: String, pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
        allSatisfy {
            $0.match(card, pendingAction: pendingAction, state: state)
        }
    }
}

private extension GameFeature.Action {
    func withChoice(_ choice: Card.Selector.ChoiceKind, prompt: Card.Selector.ChoicePrompt) -> Self {
        var copy = self
        copy.selectors.insert(.choose(choice, status: .prompted(prompt)), at: 0)
        return copy
    }
}
