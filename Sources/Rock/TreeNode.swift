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

extension TreeNode: Hashable {
  static func == (lhs: TreeNode<T>, rhs: TreeNode<T>) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self))
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
  /*
                        0
                 1            2
               3    4     5      6
             7  8  9 10 11 12 13  14
   */

  print("中序:  左 根 右")
  let source = orderList(lower: 0, upper: 14)
  let node = treeNode(from: source)

  let list = inOrderTraversal(node: node)
  print(list)

  let list2 = inOrderTraveral2(node: node)
  print(list2)

  let list3 = flagInOrderTreeTraversal(node: node)
  print(list3)
  
  print("前序： 根 左 右")
  let list4 = preOrderTraveral(node: node)
  print(list4)

  let list5 = preOrderTraveral2(node: node)
  print(list5)

  print("后： 左右根")
  let post = postOrderTraversal(node: node)
  print(post)

  let post2 = postOrderTraversal2(node: node)
  print(post2)
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
//MARK: in order
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

func inOrderTraveralx<T>(node: TreeNode<T>?) -> [T]? {
  guard let root = node else {
    return nil
  }
  var queue = [TreeNode<T>]()
  var current: TreeNode<T>? = root
  var result = [T]()
  while current != nil || !queue.isEmpty {
    while current != nil {
      current.map({ queue.append($0) })
      current = current?.left
    }
    current = queue.removeLast()
    current?.value.map({ result.append($0) })
    current = current?.right
  }
  return result
}

func inOrderTraveral2<T>(node: TreeNode<T>?) -> [T]? {
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
    while current != nil {
      current.map { queue.append($0) }
      current = current?.left
    }
    current = queue.removeLast()
    current?.value.map { result.append($0) }
    current = current?.right
  }
  return result
}

//MARK: pre order
func preOrderTraveral<T>(node: TreeNode<T>?) -> [T]? {
  guard let root = node else {
    return nil
  }
  var list = [T]()
  _preOrder(node: root, list: &list)
  return list
}

private func _preOrder<T>(node: TreeNode<T>, list: inout [T]) {
  node.value.map { list.append($0) }
  node.left.map({ _preOrder(node: $0, list: &list) })
  node.right.map({ _preOrder(node: $0, list: &list) })
}

func preOrderTraveral2<T>(node: TreeNode<T>?) -> [T]? {
  /*
   1. 边界条件
   2. 变量 current, queue,
   3. 循环条件
   */
  guard let root = node else {
    return nil
  }
  var result = [T]()
  var queue = [TreeNode<T>]()
  var current: TreeNode<T>?
  current = root
  while current != nil || !queue.isEmpty {
    current?.value.map({ result.append($0) })
    current.map({ queue.append($0) })
    while current != nil {
      current = current?.left.flatMap({
        queue.append($0);
        $0.value.map({ result.append($0) })
        return $0
      })
    }
    current = queue.removeLast()
    current = current?.right
  }
  return result
}

//MARK: - post order
func postOrderTraversal<T>(node: TreeNode<T>?) -> [T]? {
  guard let root = node else {
    return nil
  }
  var list = [T]()
  _postOrder(node: root, list: &list)
  return list
}

private func _postOrder<T>(node: TreeNode<T>, list: inout [T]) {
  node.left.map({ _postOrder(node: $0, list: &list) })
  node.right.map({ _postOrder(node: $0, list: &list) })
  node.value.map({ list.append($0) })
}

func postOrderTraversal2<T>(node: TreeNode<T>?) -> [T]? {
  guard let root = node else {
    return nil
  }
  var queue = [TreeNode<T>]()
  var result = [T]()
  var current: TreeNode<T>?
  current = root
  while current != nil || !queue.isEmpty {
    current.map({ queue.append($0) })
    current?.value.map({ result.append($0) })

    while current != nil {
      current = current?.right.map({
        queue.append($0);
        $0.value.map({ result.append($0) })
        return $0
      })
    }
    current = queue.removeLast()
    current = current?.left
  }
  return result.reversed()
}

//MARK: - 应付各种遍历操作
enum VisitState: Int {
  case none
  case visited
}
// 将访问过的元素进行标记
func flagInOrderTreeTraversal<T>(node: TreeNode<T>?) -> [T]? {
  guard let root = node else {
    return nil
  }
  var list = [(VisitState, TreeNode<T>)]()
  list.append((.none, root))
  var result = [T]()
  while !list.isEmpty {
    let (state, tmp) = list.removeLast()
    switch state {
    case .none:
      tmp.right.map({ list.append((.none, $0)) })
      list.append((.visited, tmp))
      tmp.left.map({ list.append((.none, $0)) })
    default:
      tmp.value.map({ result.append($0) })
    }
  }
  return result
}
