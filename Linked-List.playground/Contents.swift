import UIKit

/// To implement a linked list we need 2 components
/// A `node` which will store the value and the next/ previous (if is a double linked list)
/// And the Linked list which will implement insertion, deletion and search using the node
///
///

// MARK: - Linked List
// NODE
class Node<T> { // << We're using class because as struct is a value type it doesn't store memory ref
	let value: T
	var next: Node<T>?

	init(value: T) {
		self.value = value
	}
}

// LIST
struct LinkedList<T: Comparable & Equatable> {
	var head: Node<T>?

	// Init passing value to keep it
	init(_ value: T) {
		head = Node<T>(value: value)
	}

	init(_ node: Node<T>) {
		head = node
	}

	// Insert
	mutating func insert(_ value: T) { // Using mutating to allow change the self.head property
		let node = Node<T>(value: value)
		node.next = head
		head = node
	}

	mutating func insert(_ node: Node<T>) {
		node.next = head
		head = node
	}

	mutating func remove() -> T? {
		guard let removedNode = head else { // << Check and declare
			return nil
		}

		self.head = removedNode.next // << Update to the new head

		return removedNode.value // Return value
	}

	func search(value: T) -> Bool {
		var currentNode: Node<T>? = head

		while currentNode != nil {
			if currentNode?.value == value {
				return true
			}

			currentNode = currentNode?.next
		}

		return false
	}

	mutating func reverseList() {
		var newList: Node<T>? // << This will be the new head
		var nextNode: Node<T>? // << Aux var to move the nodes

		// [1 > 2 > 3 > 4]
		//Will do:
		// Store the next Node |e.g. nextNode: 2
		// Make current head.next point to newList
		// Set current to newList |e.g. newList: 1
		// Set nextNode (previously stored) as head | e.g. head: [2 > 3 > 4] newList: [1 > nil]

		// Example:
		// 1º Loop: head = [1 > 2 > 3 > 4] | nextNode: 2 | newList = [1]
		// 2º Loop: head = [2 > 3 > 4] | nextNode: 3 | newList = [2 > 1]
		// 3º Loop: head = [3 > 4] | nextNode: 4 | newList [3 > 2 > 1]
		// ...
		while head != nil {
			nextNode = head?.next
			head?.next = newList
			newList = head
			head = nextNode
		}

		head = newList
	}

	func printList() {
		//Avoid infinit loop
		guard !hasCycle() else {
			print("Print aborted: Cycle detected")
			return
		}

		var node = head
		var nodesString = ""

		while node != nil {
			nodesString += "\(node!.value)"
			node = node?.next

			if node != nil {
				nodesString += " -> "
			}
		}

		print("List \(nodesString)")
	}

	func findMiddleNode() -> Node<T>? {
		var currentHead = head
		var aheadHead = head?.next

		// For each position we move in the list, the aheadHead moves 2 positions
		while aheadHead != nil {
			currentHead = currentHead?.next
			aheadHead = aheadHead?.next?.next // << As we're using Swift's optional we don't need to care with nil
		}

		return currentHead
	}

	// This function only works if we add the node in the list instead of the value
	func hasCycle() -> Bool {
		var normalSpeed: Node<T>? = head
		var fastSpeed: Node<T>? = head

		// If we had a cycle, sometime in the infinity loop booth variable will met
		while fastSpeed != nil && fastSpeed?.next != nil {
			normalSpeed = normalSpeed?.next
			fastSpeed = fastSpeed?.next?.next

			if normalSpeed === fastSpeed {
				return true
			}
		}
		return false
	}
}

let cycleNode = Node(value: 5)
var linkedList = LinkedList<Int>(1)
linkedList.insert(2)
linkedList.insert(3)
linkedList.insert(cycleNode)

linkedList.printList()
print(linkedList.reverseList())

print("Has cycle: \(linkedList.hasCycle())")

// - MARK: Double Linked List
class NodeDoubleLinked<T> {
	let value: T
	var next: NodeDoubleLinked<T>?
	var previous: NodeDoubleLinked<T>? // << In a double  linked list the node is linked with both neighbour

	init(_ value: T) {
		self.value = value
	}
}

struct DoubleLinkedList<T: Comparable & Equatable> {
	var head: NodeDoubleLinked<T>?
	var tail: NodeDoubleLinked<T>?

	init(_ value: T) {
		head = NodeDoubleLinked<T>(value)
		tail = head
	}

	mutating func insertToHead(_ value: T) {
		let newNode = NodeDoubleLinked(value) // - Create the new Node

		guard let currentHead = head else { // - If we don't have head the list is empty so head and tail are the same
			head = newNode
			tail = newNode
			return
		}

		// List isn't empty
		newNode.next = currentHead
		currentHead.previous = newNode
		head = newNode
	}

	mutating func insertToTail(_ value: T) {
		let newNode = NodeDoubleLinked(value)

		guard let currentTail = tail else {
			head = newNode
			tail = newNode
			return
		}

		newNode.previous = currentTail
		currentTail.next = newNode
		tail = newNode
	}

	mutating func removeFromHead() -> T? {
		guard let removedNode = head else {
			return nil
		}

		head = removedNode.next // << Move head to next node

		// We do the check again as we have a new head
		if let head = head { // << I could just use head?.previous = nil bc Swift's unwrap
			head.previous = nil
		} else {
			tail = nil // << If a list doesn't have a head it's empty,
		}

		return removedNode.value
	}

	// We do the same as when removing from HEAD but using tail instead
	mutating func removeFromTail() -> T? {
		guard let removedNode = tail else {
			return nil
		}

		tail = removedNode.previous

		if let tail = tail {
			tail.next = nil
		} else {
			head = nil
		}

		return removedNode.value
	}

	func printList() {
		var node = head

		var nodesString = ""
		while node != nil {
			nodesString += "\(node!.value)"
			node = node?.next

			if node != nil {
				nodesString += " -> "
			}
		}

		print("List \(nodesString)")
	}
}

/*
 // MARK: - Just testing
 var doubledList = DoubleLinkedList<Int>(1)
 doubledList.insertToTail(2)
 doubledList.insertToTail(3)
 doubledList.insertToHead(0)

 doubledList.printList()

 print("Removed head: \(doubledList.removeFromHead())")

 doubledList.printList()

 print("Removed form HEAD \(doubledList.removeFromHead() ?? -1)")

 doubledList.printList()
 print("Removed form TAIL \(doubledList.removeFromTail() ?? -1)")

 doubledList.printList()

 print("Removed form TAIL \(doubledList.removeFromTail() ?? -1)")
 doubledList.printList()
 */

// MARK - MERGE 2 LISTs alg
/*
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init() { self.val = 0; self.next = nil; }
 *     public init(_ val: Int) { self.val = val; self.next = nil; }
 *     public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
 * }
 */
class Solution {
	func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
		guard var firstList: ListNode? = list1 else {
			return list2
		}

		guard var secondList: ListNode? = list2 else {
			return list1
		}

		var mergedList: ListNode?
		var currentTail: ListNode?

		while firstList != nil || secondList != nil {
			var newNode: ListNode?

			if let firstNode = firstList, let secondNode = secondList {
				if firstNode.val < secondNode.val {
					newNode = ListNode(firstNode.val)
					firstList = firstNode.next
				} else {
					newNode = ListNode(secondNode.val)
					secondList = secondNode.next
				}
			} else if let firstNode = firstList {
				newNode = ListNode(firstNode.val)
				firstList = firstNode.next
			} else if let secondNode = secondList {
				newNode = ListNode(secondNode.val)
				secondList = secondNode.next
			}

			if mergedList == nil {
				mergedList = newNode
				currentTail = mergedList
			} else {
				currentTail?.next = newNode
				currentTail = newNode
			}
		}

		return mergedList
	}
}}
}

*/
