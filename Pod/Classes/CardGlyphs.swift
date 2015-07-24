//
//  CardGlyphs.swift
//  Pods
//
//  Created by Gregory Combs on 7/23/15.
//  Copyright (c) 2015 PlayingCards (Swift). All rights reserved.
//

import Foundation

internal typealias CardGlyphMap = [CardType : String];
internal typealias SuiteGlyphMap = [SuiteType : CardGlyphMap];

internal class CardGlyphs {

    static func glyphForSuite(suiteType:SuiteType, cardType:CardType) -> String? {
        if let glyphs = SharedCardGlyphs.cardGlyphs[suiteType] ?? nil {
            return glyphs[cardType] ?? nil;
        }
        return nil;
    }

}

/**
*  The singleton ensures the (expensive) setup is completed only once,
*  no matter how many times you need to access the card glyphs.
*/
private let SharedCardGlyphs : CardGlyphsPrivate = CardGlyphsPrivate();

private class CardGlyphsPrivate {

    init() {
        var emptyMap : SuiteGlyphMap = [:];

        cardGlyphs = SuiteType.allValues.map({
            ($0, $0.cardGlyphMap)
        }).reduce(emptyMap, combine: {
            var map : SuiteGlyphMap = $0;
            let tuple : GlyphTuple = $1;
            map[tuple.suiteType] = tuple.cardGlyphs;
            return map;
        });
    }

    private typealias GlyphTuple = (suiteType: SuiteType, cardGlyphs: CardGlyphMap);
    private let cardGlyphs : SuiteGlyphMap;
}

private extension SuiteType {

    private typealias IndexedCardTypeTuple = (index: Int, element: CardType);
    private typealias RangeWithExclusion = (range: Range<Int>, exclude: Int);

    private var cardGlyphRange : RangeWithExclusion {
        get {
            switch self {
            case .Spades:
                return (0x1F0A1...0x1F0AE, 0x1F0AC);
            case .Hearts:
                return (0x1F0B1...0x1F0BE, 0x1F0BC);
            case .Diamonds:
                return (0x1F0C1...0x1F0CE, 0x1F0CC);
            case .Clubs:
                return (0x1F0D1...0x1F0DE, 0x1F0DC);
            }
        }
    }

    private var cardGlyphMap : CardGlyphMap {
        get {
            var cardTypes = EnumerateGenerator(CardType.allValues.generate())
            let range = cardGlyphRange;
            var glyphs : CardGlyphMap = [:];

            for code in range.range {
                if code == range.exclude {
                    continue;
                }

                let scalar = UnicodeScalar(code);
                let char = Character(scalar);

                if let tuple : IndexedCardTypeTuple = cardTypes.next() {
                    let cardType = tuple.element;
                    glyphs[cardType] = "\(char)";
                    continue;
                }
                break; // no more next()'s, time to quit
            }
            return glyphs;
        }
    }
}
