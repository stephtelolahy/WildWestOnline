import Foundation

@resultBuilder
public struct AttributeBuilder {

    public static func buildBlock(_ components: Attribute...) -> [Attribute] {
        components
    }
}
