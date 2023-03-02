import Foundation

@resultBuilder
public struct RequirementBuilder {

    public static func buildBlock(_ components: Requirement...) -> [Requirement] {
        components
    }
}
