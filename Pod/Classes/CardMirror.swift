//
//  CardMirror.swift
//  PlayingCards (Swift)
//
//  Created by Gregory Combs on 7/16/15.
//

import Foundation

struct CardMirror: MirrorType {
    private let _value: Card

    init(_ value: Card) {
        _value = value
    }

    var value: Any { return _value }

    var valueType: Any.Type { return Card.self }

    var objectIdentifier: ObjectIdentifier? { return nil }

    var disposition: MirrorDisposition { return .Struct }

    // MARK: Child properties

    var count: Int { return 8 }

    subscript(index: Int) -> (String, MirrorType) {
        switch index {
        case 0:
            return ("description", reflect(_value.description))
        case 1:
            return ("name", reflect(_value.name))
        case 2:
            return ("suiteType", reflect(_value.suiteType))
        case 3:
            return ("cardType", reflect(_value.cardType))
        case 4:
            return ("color", reflect(_value.color))
        case 5:
            return ("glyph", reflect(_value.glyph))
        case 6:
            return ("maxPointValue", reflect(_value.maxPointValue))
        case 7:
            return ("minPointValue", reflect(_value.minPointValue))
        default:
            fatalError("Index out of range")
        }
    }

    // MARK: Custom representation

    var summary: String {
        return "\(_value.description)";
    }

    var quickLookObject: QuickLookObject? {
        return .Text(summary)
    }
}

extension Card : Reflectable {
    public func getMirror() -> MirrorType {
        return CardMirror(self)
    }
}
