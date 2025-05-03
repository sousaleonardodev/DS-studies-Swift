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
struct LinkedList<T: Comparable> {
	var head: Node<T>?

	// Init passing value to keep it
	init(_ value: T) {
		head = Node<T>(value: value)
	}


	// Insert
	mutating func insert(_ value: T) { // Using mutating to allow change the self.head property
		let node = Node<T>(value: value)
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
}


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

		var printed = ""
		while node != nil {
			printed += "\(node!.value) -> "
			node = node?.next
		}

		print("List \(printed)")
	}
}

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
