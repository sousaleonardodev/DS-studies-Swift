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
		guard let currentHead = head else {
			return nil
		}

		self.head = currentHead.next // << Update to the new head

		return currentHead.value // Return value
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
