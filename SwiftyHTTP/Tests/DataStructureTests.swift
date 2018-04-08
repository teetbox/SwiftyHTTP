//
//  DataStructureTests.swift
//  SwiftyHTTP
//
//  Created by Matt Tian on 08/04/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest

class DataStructureTests: XCTestCase {
    
    func testNode() {
        let node5 = Node(value: 5)
        
        XCTAssertNil(node5.next)
        XCTAssertNil(node5.previous)
        
        let node7 = Node(value: 7)
        node5.next = node7
        
        XCTAssertNotNil(node5.next)
        XCTAssertNil(node5.previous)
        
        let node3 = Node(value: 3)
        node5.previous = node3
        
        XCTAssertNotNil(node5.next)
        XCTAssertNotNil(node5.previous)
    }
    
    func testLinkedList() {
        var list = LinkedList<Int>()
        
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
        
        list.append(7)
        XCTAssertNotNil(list.head)
        XCTAssertNotNil(list.tail)
        XCTAssertFalse(list.isEmpty)
        
        list.append(8)
        let node = list.node(at: 1)
        XCTAssertEqual(node?.value, 8)
        
        list.append(9)
        var removedNode = list.remove(at: 1)
        XCTAssertEqual(removedNode?.value, 8)
        XCTAssertEqual(list.head?.value, 7)
        XCTAssertEqual(list.tail?.value, 9)
        XCTAssertEqual(list.head?.next?.value, 9)
        
        removedNode = list.remove(at: 1)
        XCTAssertEqual(removedNode?.value, 9)
        XCTAssertEqual(list.head?.value, 7)
        XCTAssertEqual(list.tail?.value, 7)
        
        list.remove(at: 0)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
        XCTAssert(list.isEmpty)
        
        list.append(1)
        list.append(2)
        list.append(3)
        
        let node1 = list.node(at: 0)
        let node2 = list.node(at: 1)
        let node3 = list.node(at: 2)
        XCTAssertEqual(node1?.value, 1)
        XCTAssertEqual(node2?.value, 2)
        XCTAssertEqual(node3?.value, 3)
        
        let removedNode3 = list.remove(node: node3!)
        XCTAssertEqual(removedNode3.value, 3)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 2)
        
        list.remove(node: node2!)
        list.remove(node: node1!)
        XCTAssertNil(list.head?.previous)
        XCTAssertNil(list.tail?.next)
        XCTAssert(list.isEmpty)
        
        list.append(4)
        list.append(5)
        list.append(6)
        
        list.removeAll()
        XCTAssertNil(list.head?.previous)
        XCTAssertNil(list.tail?.next)
        XCTAssert(list.isEmpty)
    }
    
    func testQueue() {
        var queue = Queue<Int>()
        XCTAssert(queue.isEmpty)
        
        queue.enqueue(5)
        queue.enqueue(7)
        XCTAssertFalse(queue.isEmpty)
        
        var element = queue.dequeue()
        XCTAssertEqual(element, 5)
        
        element = queue.peek()
        XCTAssertEqual(element, 7)
        XCTAssertFalse(queue.isEmpty)
        
        element = queue.dequeue()
        XCTAssertEqual(element, 7)
        XCTAssert(queue.isEmpty)
    }
    
}
