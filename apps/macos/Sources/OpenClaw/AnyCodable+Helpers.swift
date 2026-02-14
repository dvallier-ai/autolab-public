import AutoLabKit
import AutoLabProtocol
import Foundation

// Prefer the AutoLabKit wrapper to keep gateway request payloads consistent.
typealias AnyCodable = AutoLabKit.AnyCodable
typealias InstanceIdentity = AutoLabKit.InstanceIdentity

extension AnyCodable {
    var stringValue: String? { self.value as? String }
    var boolValue: Bool? { self.value as? Bool }
    var intValue: Int? { self.value as? Int }
    var doubleValue: Double? { self.value as? Double }
    var dictionaryValue: [String: AnyCodable]? { self.value as? [String: AnyCodable] }
    var arrayValue: [AnyCodable]? { self.value as? [AnyCodable] }

    var foundationValue: Any {
        switch self.value {
        case let dict as [String: AnyCodable]:
            dict.mapValues { $0.foundationValue }
        case let array as [AnyCodable]:
            array.map(\.foundationValue)
        default:
            self.value
        }
    }
}

extension AutoLabProtocol.AnyCodable {
    var stringValue: String? { self.value as? String }
    var boolValue: Bool? { self.value as? Bool }
    var intValue: Int? { self.value as? Int }
    var doubleValue: Double? { self.value as? Double }
    var dictionaryValue: [String: AutoLabProtocol.AnyCodable]? { self.value as? [String: AutoLabProtocol.AnyCodable] }
    var arrayValue: [AutoLabProtocol.AnyCodable]? { self.value as? [AutoLabProtocol.AnyCodable] }

    var foundationValue: Any {
        switch self.value {
        case let dict as [String: AutoLabProtocol.AnyCodable]:
            dict.mapValues { $0.foundationValue }
        case let array as [AutoLabProtocol.AnyCodable]:
            array.map(\.foundationValue)
        default:
            self.value
        }
    }
}
