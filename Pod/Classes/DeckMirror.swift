//
//  DeckMirror.swift
//  PlayingDecks (Swift)
//
//  Created by Gregory Combs on 7/16/15.
//

import Foundation

struct DeckMirror: MirrorType {
    private let _value: Deck

    init(_ value: Deck) {
        _value = value
    }

    var value: Any { return _value }

    var valueType: Any.Type { return Deck.self }

    var objectIdentifier: ObjectIdentifier? { return nil }

    var disposition: MirrorDisposition { return .Struct }

    // MARK: Child properties

    var count: Int { return 6 }

    subscript(index: Int) -> (String, MirrorType) {
        switch index {
        case 0:
            return ("description", reflect(_value.description))
        case 1:
            return ("isShuffled", reflect(_value.isShuffled))
        case 2:
            return ("suiteCount", reflect(_value.suiteCount))
        case 3:
            return ("cardCount", reflect(_value.cardCount))
        case 4:
            return ("hashValue", reflect(_value.hashValue))
        case 5:
            return ("cards", reflect(_value.cards))
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

extension Deck : Reflectable {
    public func getMirror() -> MirrorType {
        return DeckMirror(self)
    }
}
