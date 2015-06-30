//
//  Suite.swift
//  PlayingCards (Swift)
//
//  Created by Gregory Combs on 6/30/15.
//
//

import UIKit;

public struct Suite : Hashable {
    public let suiteType: SuiteType;
    public let name: String;
    public let color: UIColor;
    public let cards: [Card];
    public let cardCount: Int = 13;
    public var hashValue : Int {
        return HashUtils.compositeHash([suiteType.hashValue, cardCount.hashValue]);
    }

    init(type: SuiteType) {
        suiteType = type;
        name = type.name();
        color = type.color();

        var tempCards : [Card] = [];
        for cardType in CardType.allValues {
            let card = Card(suite: type, type: cardType);
            tempCards += [card];
        }
        cards = tempCards;
        assert(cards.count == cardCount, "Unexpected card count for suite \(name)");
    }
}

public func ==(lhs: Suite, rhs: Suite) -> Bool {
    return (lhs.suiteType == rhs.suiteType && lhs.cardCount == rhs.cardCount);
}

public enum SuiteType : Int {
    case Hearts = 0, Diamonds, Clubs, Spades;

    public func color() -> UIColor {
        switch self {
        case .Hearts, .Diamonds:
            return UIColor.redColor();
        case .Clubs, .Spades:
            return UIColor.blackColor();
        }
    }

    public func name() -> String {
        assert(SuiteType.allNames.count > self.rawValue , "Mismatch in SuiteType length versus allNames length");
        return SuiteType.allNames[self.rawValue];
    }

    static let allValues = [Hearts,Diamonds,Clubs,Spades];
    static let allNames = ["Hearts", "Diamonds", "Clubs", "Spades"];
}
