//
//  HashUtils.swift
//  PlayingCards (Swift)
//
//  Created by Gregory Combs on 6/30/15.
//

import Foundation

internal class HashUtils {

    internal static let HashCharBitSize = (Int(CHAR_BIT) * Int(sizeof(Int)));

    internal  class func rotateHashValue(hash: Int, howMuch: Int) -> Int {
        let first = hash << howMuch;
        let second = hash >> (HashCharBitSize - howMuch);
        return first | second;
    }

    internal class func computeValueHash(hash: Int, hashIndex: Int) -> Int {
        let hashValue = (hash == 0) ? 31 : hash;
        let howMuch = HashCharBitSize / (hashIndex + 1);
        return rotateHashValue(hashValue, howMuch:howMuch);
    }

    internal class func compositeHash(hashValues: [Int]) -> Int {
        var current = 31;
        var hashIndex = 1;

        for hash in hashValues {
            current = computeValueHash(hash, hashIndex:hashIndex) ^ current;
            hashIndex++;
        }
        return current;
    }
}
