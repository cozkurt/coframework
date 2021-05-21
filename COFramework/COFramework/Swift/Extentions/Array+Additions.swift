//
//  Array+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation

extension Array {
	func grouped<T>(by criteria: (Element) -> T) -> [T: [Element]] {
		var groups = [T: [Element]]()
		for element in self {
			let key = criteria(element)
			if groups.keys.contains(key) == false {
				groups[key] = [Element]()
			}
			groups[key]?.append(element)
		}
		return groups
	}
    
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>()
        var arrayOrdered = [Element]()
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}

extension Array where Element : Equatable {
    public mutating func mergeElements<C : Collection>(newElements: C) where C.Iterator.Element == Element {
        let filteredList = newElements.filter({!self.contains($0)})
        self.append(contentsOf: filteredList)
    }
}

extension Array where Element == Int {
    var average: Int {
        return isEmpty ? 0 : Int(reduce(0, +)) / Int(count)
    }
}
