//
//  File.swift
//  
//
//  Created by miao gaoliang on 2020/8/16.
//

public class Node<T> {
  var value: T?
  var next: Node<T>?
  weak var pre: Node<T>?
  required init(value: T?, next: Node<T>? = nil, pre: Node<T>? = nil) {
    self.value = value
    self.next = next
    self.pre = pre
  }
}
