import Foundation

public enum AutoLabDeviceCommand: String, Codable, Sendable {
    case status = "device.status"
    case info = "device.info"
}

public enum AutoLabBatteryState: String, Codable, Sendable {
    case unknown
    case unplugged
    case charging
    case full
}

public enum AutoLabThermalState: String, Codable, Sendable {
    case nominal
    case fair
    case serious
    case critical
}

public enum AutoLabNetworkPathStatus: String, Codable, Sendable {
    case satisfied
    case unsatisfied
    case requiresConnection
}

public enum AutoLabNetworkInterfaceType: String, Codable, Sendable {
    case wifi
    case cellular
    case wired
    case other
}

public struct AutoLabBatteryStatusPayload: Codable, Sendable, Equatable {
    public var level: Double?
    public var state: AutoLabBatteryState
    public var lowPowerModeEnabled: Bool

    public init(level: Double?, state: AutoLabBatteryState, lowPowerModeEnabled: Bool) {
        self.level = level
        self.state = state
        self.lowPowerModeEnabled = lowPowerModeEnabled
    }
}

public struct AutoLabThermalStatusPayload: Codable, Sendable, Equatable {
    public var state: AutoLabThermalState

    public init(state: AutoLabThermalState) {
        self.state = state
    }
}

public struct AutoLabStorageStatusPayload: Codable, Sendable, Equatable {
    public var totalBytes: Int64
    public var freeBytes: Int64
    public var usedBytes: Int64

    public init(totalBytes: Int64, freeBytes: Int64, usedBytes: Int64) {
        self.totalBytes = totalBytes
        self.freeBytes = freeBytes
        self.usedBytes = usedBytes
    }
}

public struct AutoLabNetworkStatusPayload: Codable, Sendable, Equatable {
    public var status: AutoLabNetworkPathStatus
    public var isExpensive: Bool
    public var isConstrained: Bool
    public var interfaces: [AutoLabNetworkInterfaceType]

    public init(
        status: AutoLabNetworkPathStatus,
        isExpensive: Bool,
        isConstrained: Bool,
        interfaces: [AutoLabNetworkInterfaceType])
    {
        self.status = status
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
        self.interfaces = interfaces
    }
}

public struct AutoLabDeviceStatusPayload: Codable, Sendable, Equatable {
    public var battery: AutoLabBatteryStatusPayload
    public var thermal: AutoLabThermalStatusPayload
    public var storage: AutoLabStorageStatusPayload
    public var network: AutoLabNetworkStatusPayload
    public var uptimeSeconds: Double

    public init(
        battery: AutoLabBatteryStatusPayload,
        thermal: AutoLabThermalStatusPayload,
        storage: AutoLabStorageStatusPayload,
        network: AutoLabNetworkStatusPayload,
        uptimeSeconds: Double)
    {
        self.battery = battery
        self.thermal = thermal
        self.storage = storage
        self.network = network
        self.uptimeSeconds = uptimeSeconds
    }
}

public struct AutoLabDeviceInfoPayload: Codable, Sendable, Equatable {
    public var deviceName: String
    public var modelIdentifier: String
    public var systemName: String
    public var systemVersion: String
    public var appVersion: String
    public var appBuild: String
    public var locale: String

    public init(
        deviceName: String,
        modelIdentifier: String,
        systemName: String,
        systemVersion: String,
        appVersion: String,
        appBuild: String,
        locale: String)
    {
        self.deviceName = deviceName
        self.modelIdentifier = modelIdentifier
        self.systemName = systemName
        self.systemVersion = systemVersion
        self.appVersion = appVersion
        self.appBuild = appBuild
        self.locale = locale
    }
}
