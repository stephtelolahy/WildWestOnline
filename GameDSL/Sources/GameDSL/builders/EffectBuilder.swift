import Foundation

@resultBuilder
public struct EffectsBuilder {

    public static func buildBlock(_ components: Effect...) -> [Effect] {
        components
    }
}

@resultBuilder
public struct EffectBuilder {

    public static func buildBlock(_ component: Effect) -> Effect {
        component
    }
}
