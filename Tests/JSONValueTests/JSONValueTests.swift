import Testing
import Foundation
@testable import JSONValue

@Test("Basic type creation and value extraction")
func testJSONValueCreation() throws {
    // String type
    let stringValue = JSONValue.string("test")
    if case .string(let value) = stringValue {
        #expect(value == "test")
    } else {
        Issue.record("Expected string value")
    }
    
    // Boolean type
    let boolValue = JSONValue.boolean(true)
    if case .boolean(let value) = boolValue {
        #expect(value == true)
    } else {
        Issue.record("Expected boolean value")
    }
    
    // Integer type
    let intValue = JSONValue.integer(42)
    if case .integer(let value) = intValue {
        #expect(value == 42)
    } else {
        Issue.record("Expected integer value")
    }
    
    // Float type
    let floatValue = JSONValue.float(3.14)
    if case .float(let value) = floatValue {
        #expect(value == 3.14)
    } else {
        Issue.record("Expected float value")
    }
    
    // Double type
    let doubleValue = JSONValue.double(Double.pi)
    if case .double(let value) = doubleValue {
        #expect(value == Double.pi)
    } else {
        Issue.record("Expected double value")
    }
}

@Test("Array value creation and element access")
func testArrayValue() throws {
    let arrayValue = JSONValue.array([
        .string("test"),
        .integer(42),
        .boolean(true)
    ])
    
    if case .array(let values) = arrayValue {
        #expect(values.count == 3)
        
        if case .string(let str) = values[0] {
            #expect(str == "test")
        }
        if case .integer(let num) = values[1] {
            #expect(num == 42)
        }
        if case .boolean(let bool) = values[2] {
            #expect(bool == true)
        }
    } else {
        Issue.record("Expected array value")
    }
}

@Test("Object value creation and property access")
func testObjectValue() throws {
    let objectValue = JSONValue.object([
        "string": .string("test"),
        "number": .integer(42),
        "boolean": .boolean(true)
    ])
    
    if case .object(let dict) = objectValue {
        #expect(dict.count == 3)
        
        if case .string(let str) = dict["string"] {
            #expect(str == "test")
        }
        if case .integer(let num) = dict["number"] {
            #expect(num == 42)
        }
        if case .boolean(let bool) = dict["boolean"] {
            #expect(bool == true)
        }
    } else {
        Issue.record("Expected object value")
    }
}

@Test("Deep nested structure handling")
func testNestedStructure() throws {
    let nestedValue = JSONValue.object([
        "name": .string("Test"),
        "numbers": .array([.integer(1), .integer(2)]),
        "nested": .object([
            "key": .string("value"),
            "flag": .boolean(true),
            "deepNested": .object([
                "array": .array([
                    .string("deep"),
                    .boolean(false)
                ])
            ])
        ])
    ])
    
    if case .object(let dict) = nestedValue {
        // Top level validation
        #expect(dict.count == 3)
        
        // Array validation
        if case .array(let numbers) = dict["numbers"] {
            #expect(numbers.count == 2)
            if case .integer(let first) = numbers[0] {
                #expect(first == 1)
            }
        }
        
        // Nested object validation
        if case .object(let nested) = dict["nested"],
           case .object(let deepNested) = nested["deepNested"],
           case .array(let deepArray) = deepNested["array"] {
            #expect(deepArray.count == 2)
            if case .string(let str) = deepArray[0] {
                #expect(str == "deep")
            }
        }
    }
}

@Test("Value equality")
func testEquality() throws {
    // Same values should be equal
    #expect(JSONValue.string("test") == JSONValue.string("test"))
    #expect(JSONValue.integer(42) == JSONValue.integer(42))
    #expect(JSONValue.boolean(true) == JSONValue.boolean(true))
    #expect(JSONValue.float(3.14) == JSONValue.float(3.14))
    #expect(JSONValue.double(1.23) == JSONValue.double(1.23))
    
    // Different values should not be equal
    #expect(JSONValue.string("test") != JSONValue.string("other"))
    #expect(JSONValue.integer(42) != JSONValue.integer(43))
    
    // Different types should not be equal
    #expect(JSONValue.string("42") != JSONValue.integer(42))
    #expect(JSONValue.float(42.0) != JSONValue.integer(42))
}

@Test("Empty array and object handling")
func testEmptyContainers() throws {
    let emptyArray = JSONValue.array([])
    let emptyObject = JSONValue.object([:])
    
    if case .array(let arr) = emptyArray {
        #expect(arr.isEmpty)
    }
    
    if case .object(let obj) = emptyObject {
        #expect(obj.isEmpty)
    }
}

@Test("Array with duplicate values")
func testArrayWithDuplicates() throws {
    let arrayWithDuplicates = JSONValue.array([
        .string("test"),
        .string("test"),
        .integer(42),
        .integer(42)
    ])
    
    if case .array(let values) = arrayWithDuplicates {
        #expect(values.count == 4)
        #expect(values[0] == values[1])
        #expect(values[2] == values[3])
    }
}

@Test("Object with nested empty containers")
func testObjectWithEmptyContainers() throws {
    let objectWithEmpty = JSONValue.object([
        "emptyArray": .array([]),
        "emptyObject": .object([:]),
        "value": .string("test")
    ])
    
    if case .object(let dict) = objectWithEmpty {
        if case .array(let arr) = dict["emptyArray"] {
            #expect(arr.isEmpty)
        }
        if case .object(let obj) = dict["emptyObject"] {
            #expect(obj.isEmpty)
        }
    }
}

@Test("Special number values")
func testSpecialNumbers() throws {
    // Integer bounds
    let maxInt = JSONValue.integer(Int.max)
    let minInt = JSONValue.integer(Int.min)
    
    if case .integer(let max) = maxInt {
        #expect(max == Int.max)
    }
    if case .integer(let min) = minInt {
        #expect(min == Int.min)
    }
    
    // Float special values
    let floatValue = JSONValue.float(Float.infinity)
    if case .float(let value) = floatValue {
        #expect(value.isInfinite)
    }
}

@Test("Complex array operations")
func testComplexArrayOperations() throws {
    let complexArray = JSONValue.array([
        .array([.string("nested")]),
        .object(["key": .boolean(true)]),
        .array([
            .integer(1),
            .array([.string("deep")])
        ])
    ])
    
    if case .array(let values) = complexArray {
        #expect(values.count == 3)
        
        // Test first nested array
        if case .array(let nested1) = values[0] {
            #expect(nested1.count == 1)
            if case .string(let str) = nested1[0] {
                #expect(str == "nested")
            }
        }
        
        // Test nested object
        if case .object(let obj) = values[1] {
            if case .boolean(let bool) = obj["key"] {
                #expect(bool == true)
            }
        }
        
        // Test deeply nested array
        if case .array(let nested2) = values[2] {
            if case .array(let deepNested) = nested2[1] {
                if case .string(let str) = deepNested[0] {
                    #expect(str == "deep")
                }
            }
        }
    }
}
