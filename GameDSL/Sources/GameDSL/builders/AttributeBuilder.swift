import Foundation

@resultBuilder
public struct AttributeBuilder {

    public static func buildBlock(_ components: any Attribute...) -> [any Attribute] {
        components
    }
}
