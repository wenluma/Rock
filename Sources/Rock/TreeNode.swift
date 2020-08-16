//
//  File.swift
//  
//
//  Created by miao gaoliang on 2020/8/12.
//
import Foundation

class TreeNode<T> {
  let value: T?
  var left: TreeNode<T>?
  var right: TreeNode<T>?

  init(value: T? = nil,
       left: TreeNode<T>? = nil,
       right: TreeNode<T>? = nil) {
    self.value = value
    self.left = left
    self.right = right
  }
  
  deinit {
  }
}

func testTreeDepth() {
  let list = orderList(lower: 0, upper: 14)
  //print(list)
  let node = treeNode(from: list)

  printLevel(of: node)

  let depth = maxDepth(root: node)
  print(depth)

  let depth2 = maxDepth2(root: node)
  print(depth2)

  let depth3 = maxDepthlevel(root: node)
  print(depth3)

  let depth4 = maxDepthlevel2(root: node)
  print(depth4)
  
  let depth5 = maxDepthlevel3(root: node)
  print(depth5)
}

func testTreeTraversal() {
  let source = orderList(lower: 0, upper: 14)
  let node = treeNode(from: source)

  let list = inOrderTraversal(node: node)
  print(list)
  
  let list2 = inOrderTraveral2(node: node)
  print(list2)
  
  let list3 = inOrderTraveral3(node: node)
  print(list3)
}

//MARK: - common
func treeNode<T>(from list:[T] ) -> TreeNode<T>? {
  if list.isEmpty {
    return nil
  }
  let count = list.count
  let root = TreeNode(value: list.first, left: nil, right: nil)
  var queue = [TreeNode<T>]()
  queue.append(root)
  
  stride(from: 1, to: count, by: 2).forEach { (index) in
    if queue.isEmpty { return }
    let node = queue.remove(at: 0)
    if index < count {
      let tmp = TreeNode(value: list[index])
      node.left = tmp
      queue.append(tmp)
    }
    if index+1 < count {
      let tmp = TreeNode(value: list[index+1])
      node.right = tmp
      queue.append(tmp)
    }
  }
  return root
}

func printLevel<T>(of root: TreeNode<T>?) {
  root.map { (node) -> Void in
    var queue = [TreeNode<T>]()
    var levelQueue = [TreeNode<T>]()
    queue.append(node)
    while !queue.isEmpty {
      levelQueue = queue
      queue.removeAll()
      
      while !levelQueue.isEmpty {
        let tmp = levelQueue.remove(at: 0)
        tmp.left.map({ queue.append($0) })
        tmp.right.map({ queue.append($0) })
        tmp.value.map { print($0, terminator: " ")}
      }
      print()
    }
  }
}

//MARK: -- DFS

//// 获取它的最大深度 递归 DFS
func maxDepth<T>(root: TreeNode<T>?) -> UInt {
  guard let root = root else {
    return 0
  }
  return max(maxDepth(root: root.left), maxDepth(root: root.right)) + 1
}

//// 非递归的DFS
func maxDepth2<T>(root: TreeNode<T>?) -> UInt {
  guard let root = root else {
    return 0
  }
  var queue = [(UInt, TreeNode<T>)]()
  queue.append((1, root))
  var depth: UInt = 0
  while !queue.isEmpty {
    let (currentDepth, node) = queue.remove(at: 0)
    depth = max(depth, currentDepth)
    node.left.map { queue.append((currentDepth + 1, $0)) }
    node.right.map { queue.append((currentDepth + 1, $0)) }
  }
  return depth
}

//MARK: - BFS
func maxDepthlevel<T>(root: TreeNode<T>?) -> UInt? {
  return root.flatMap { (node) -> UInt? in
    var queue = [TreeNode<T>]()
    var level: UInt = 0
    queue.append(node)
    while !queue.isEmpty {
      var count = queue.count
      while count > 0 {
        let node = queue.remove(at: 0)
        node.left.map({ queue.append($0) })
        node.right.map({ queue.append($0) })
        count -= 1
      }
      level += 1
    }
    return level
  }
}

/// 按层遍历2 BFS
func maxDepthlevel2<T>(root: TreeNode<T>?) -> UInt? {
  return root.flatMap { (node) -> UInt? in
    var queue = [TreeNode<T>]()
    var change = [TreeNode<T>]()
    
    var level: UInt = 0
    queue.append(node)
    while !queue.isEmpty {
      change = queue
      queue.removeAll()
      while !change.isEmpty {
        let node = change.remove(at: 0)
        node.left.map({ queue.append($0) })
        node.right.map({ queue.append($0) })
      }
      level += 1
    }
    return level
  }
}

func maxDepthlevel3<T>(root: TreeNode<T>?) -> UInt? {
  return root.flatMap { (node) -> UInt? in
    var queue = [TreeNode<T>]()
    queue.append(node)
    var depth: UInt = 0
    while !queue.isEmpty {
      var nextLevel = [TreeNode<T>]()
      while !queue.isEmpty {
        let tmp = queue.remove(at: 0)
        tmp.left.map { nextLevel.append($0) }
        tmp.right.map { nextLevel.append($0) }
      }
      queue = nextLevel
      depth += 1
    }
    return depth
  }
}

//MARK: - 遍历
func inOrderTraversal<T>(node: TreeNode<T>?) -> [T]? {
  guard let node = node else {
    return nil
  }
  var list = [T]()
  inOrder(node: node, list: &list)
  return list
}

private func inOrder<T>(node: TreeNode<T>?, list: inout [T]) {
  if let node = node {
    node.left.map { inOrder(node: $0, list: &list) }
    node.value.map { list.append($0) }
    node.right.map { inOrder(node: $0, list: &list) }
  }
}

func inOrderTraveral2<T>(node: TreeNode<T>?) -> [T]? {
  return node.flatMap { (tmp) -> [T]? in
    var stack = [TreeNode<T>]()

    var result = [T?]()
    var last: TreeNode<T>?
    last = tmp
    while last != nil || !stack.isEmpty {
      last.map { stack.append($0) }
      while last != nil {
        last = last?.left.flatMap { stack.append($0); return $0 }
      }
      last = stack.removeLast()
      last.map { result.append($0.value) }
      last = last?.right
    }
    return result.compactMap{ $0 }
  }
}

func inOrderTraveral3<T>(node: TreeNode<T>?) -> [T]? {
  /*
   1. 判断 current ！= nil
   2. current add to list
   3. 一直追溯left 到 left = nil; current add to list
   4. list revome last, current = last;
   5. save current value
   6. update current = current.right， 下一轮循环
   */
  guard let root = node else {
    return nil
  }
  var result = [T]()
  var queue = [TreeNode<T>]()
  var current: TreeNode<T>?
  current = root
  while current != nil || !queue.isEmpty {
    current.map { queue.append($0) }
    while current != nil {
      current = current?.left.flatMap({ queue.append($0); return $0 })
    }
    current = queue.removeLast()
    current?.value.map { result.append($0) }
    current = current?.right
  }
  return result
}





