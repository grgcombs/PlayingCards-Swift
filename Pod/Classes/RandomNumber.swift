//
//  RandomNumber.swift
//  PlayingCards (Swift)
//
//  Created by Gregory Combs on 7/14/15.
//

import Foundation

public extension Int
{
    /**
    Returns a random number with the given lower and upper boundary integers

    :param: lower The lowest possible integer to return
    :param: upper The highest possible integer to return

    :returns: A random integer within the limits provided
    
    Derived from http://stackoverflow.com/a/26140302/136582
    */
    public static func random(#lower: Int, upper: Int) -> Int {
        var offset = 0;

        // allow negative boundaries
        if lower < 0
        {
            offset = abs(lower);
        }

        let mini = UInt32(lower + offset);
        let maxi = UInt32(upper + offset);

        return Int(mini + arc4random_uniform(maxi - mini)) - offset;
    }

    /**
    Returns a random number with the given range of integers

        var aNumber = Int.random(-500...100);

    :param: range A range of integers. Negative boundaries are permitted.

    :returns: A random integer within the range provided.

    From http://stackoverflow.com/a/26140302/136582
    */
    public static func random(range: Range<Int> ) -> Int
    {
        return random(lower: range.startIndex, upper: range.endIndex);
    }
}

public func randomWithType <T: IntegerLiteralConvertible> (type: T.Type) -> T {
    var r: T = 0;
    arc4random_buf(&r, Int(sizeof(T)));
    return r;
}

public extension Double {
    /**
    Create a random num Double
    :param: lower number Double
    :param: upper number Double
    :return: random number Double
    By DaRkDOG
    */
    public static func random(#lower: Double, upper: Double) -> Double {
        let r = Double(randomWithType(UInt64)) / Double(UInt64.max)
        return (r * (upper - lower)) + lower
    }
}
