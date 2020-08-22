//
//  File.swift
//  
//
//  Created by miao gaoliang on 2020/8/14.
//


//let between0And5 = UInt8.random(in: 0..<6) // → 5
//Int.random(in: 1...1000) // → 691
//Double.random(in: 0..<1) // → 0.8741555749903935
//UInt32.random(in: 0xD800...0xDFFF) // → 55666


//let emotions = "😀😂😊😍🤪😎😩😭😡"
//let randomEmotion = emotions.randomElement()! // → "🤪"
//// 洗牌，随机改变顺序
//(1...10).shuffled() // → [10, 3, 8, 1, 4, 6, 2, 7, 9, 5]
//
//enum Suit: String, CaseIterable {
//    case diamonds = "♦"
//    case clubs = "♣"
//    case hearts = "♥"
//    case spades = "♠"
//
//    static func random() -> Suit {
//        var rng = SystemRandomNumberGenerator()
//        return Suit.random(using: &rng)
//    }
//
//    static func random<T: RandomNumberGenerator>
//        (using generator: inout T) -> Suit
//    {
//        // Force-unwrap can't fail as long as the
//        // enum has at least one case.
//        return allCases.randomElement(using: &generator)!
//    }
//}
//
//let randomSuit = Suit.random() // → clubs
//randomSuit.rawValue // → "♣"

public func orderList(lower: Int, upper: Int) -> [Int] {
  assert(lower <= upper, "lower <= upper")
  return (lower ... upper).map { $0 }
}

// 对指定的字符范围，乱序展示
public func randomUnicodeScalar(lower: Unicode.Scalar, upper: Unicode.Scalar) -> [Character] {
  charactersList(lower: lower, upper: upper).shuffled()
}

// 对指定的字符范围,乱序展示
public func randomIndex(lower: Int, upper: Int) -> [Int] {
  return (lower...upper).shuffled()
}

public func randomList<T: FixedWidthInteger>(lower: T, upper: T, count: UInt) -> [T] {
  var list = [T]()
  for _ in 0..<count {
    list.append(T.random(in: lower...upper))
  }
  print("randomList: \(list)")
  return list
}

public func charactersList(lower: Unicode.Scalar = "A", upper: Unicode.Scalar = "Z" ) -> [Character] {
//  https://stackoverflow.com/questions/26152448/swift-generate-an-array-of-swift-characters
  // 1.
  let unicodeScalarRange: ClosedRange<Unicode.Scalar> = lower ... upper
  // 2.
  let unicodeScalarValueRange: ClosedRange<UInt32> = unicodeScalarRange.lowerBound.value ... unicodeScalarRange.upperBound.value
  // 3.
  let unicodeScalarArray: [Unicode.Scalar] = unicodeScalarValueRange.compactMap(Unicode.Scalar.init)
  // 4.
  let characterArray: [Character] = unicodeScalarArray.map(Character.init)
  print("characters: \(characterArray)")
  return characterArray
}
