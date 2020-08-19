//
//  File.swift
//  
//
//  Created by miao gaoliang on 2020/8/17.
//

// 斐波那契数列
func fib(n: Int) -> UInt {
  if n == 0 || n == 1 {
    return 1
  }
  var pre: UInt = 1
  var current: UInt = 1
  for _ in 2...n {
    let sum = current + pre
    pre = current
    current = sum
  }
  return current
}
// 1...n 构成的二叉树的个数
// G(n) = ∑ F(i,n); F(i,n) = G(i-1) * G(n-i) => G(n) = ∑ G(i-1) * G(n-i)
func numTrees(n: Int) -> Int {
  guard n > 1 else {
    return 1
  }
  
  var G = Array.init(repeating: 0, count: n+1)
  G[0] = 1
  G[1] = 1
  for i in 2...n {
    for j in 1...i {
      G[i] += G[j-1] * G[i - j]
    }
  }
  return G[n]
}

// 卡塔兰数
func numTrees2(n: Int) -> Int {
  var c = 1
  for i in 0 ..< n {
    c = (2 * c * (2 * i + 1)) / (i + 2)
  }
  return c
}
