import Testing
import Foundation
@testable import JSONValue

@Test("型の生成と値の取得をテスト")
func testJSONValueCreation() throws {
    // String
    let stringValue = JSONValue.string("test")
    if case .string(let value) = stringValue {
        #expect(value == "test")
    } else {
        Issue.record("Expected string value")
    }
    
    // Boolean
    let boolValue = JSONValue.boolean(true)
    if case .boolean(let value) = boolValue {
        #expect(value == true)
    } else {
        Issue.record("Expected boolean value")
    }
    
    // Integer
    let intValue = JSONValue.integer(42)
    if case .integer(let value) = intValue {
        #expect(value == 42)
    } else {
        Issue.record("Expected integer value")
    }
    
    // Float
    let floatValue = JSONValue.float(3.14)
    if case .float(let value) = floatValue {
        #expect(value == 3.14)
    } else {
        Issue.record("Expected float value")
    }
    
    // Double
    let doubleValue = JSONValue.double(Double.pi)
    if case .double(let value) = doubleValue {
        #expect(value == Double.pi)
    } else {
        Issue.record("Expected double value")
    }
}

@Test("配列の生成と値の取得をテスト")
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

@Test("オブジェクトの生成と値の取得をテスト")
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

@Test("ネストされた構造のテスト")
func testNestedStructure() throws {
    let nestedValue = JSONValue.object([
        "name": .string("Test"),
        "numbers": .array([.integer(1), .integer(2)]),
        "nested": .object([
            "key": .string("value"),
            "flag": .boolean(true)
        ])
    ])
    
    if case .object(let dict) = nestedValue {
        // トップレベルの検証
        #expect(dict.count == 3)
        
        // 配列の検証
        if case .array(let numbers) = dict["numbers"] {
            #expect(numbers.count == 2)
            if case .integer(let first) = numbers[0] {
                #expect(first == 1)
            }
        }
        
        // ネストされたオブジェクトの検証
        if case .object(let nested) = dict["nested"] {
            if case .string(let key) = nested["key"] {
                #expect(key == "value")
            }
            if case .boolean(let flag) = nested["flag"] {
                #expect(flag == true)
            }
        }
    } else {
        Issue.record("Expected nested object structure")
    }
}

@Test("等値性の検証")
func testEquality() throws {
    // 同じ値を持つJSONValueは等しい
    #expect(JSONValue.string("test") == JSONValue.string("test"))
    #expect(JSONValue.integer(42) == JSONValue.integer(42))
    #expect(JSONValue.boolean(true) == JSONValue.boolean(true))
    #expect(JSONValue.float(3.14) == JSONValue.float(3.14))
    #expect(JSONValue.double(1.23) == JSONValue.double(1.23))
    
    // 異なる値は等しくない
    #expect(JSONValue.string("test") != JSONValue.string("other"))
    #expect(JSONValue.integer(42) != JSONValue.integer(43))
    
    // 異なる型は等しくない
    #expect(JSONValue.string("42") != JSONValue.integer(42))
    #expect(JSONValue.float(42.0) != JSONValue.integer(42))
}
