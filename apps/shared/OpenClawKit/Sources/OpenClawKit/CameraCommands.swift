import Foundation

public enum AutoLabCameraCommand: String, Codable, Sendable {
    case list = "camera.list"
    case snap = "camera.snap"
    case clip = "camera.clip"
}

public enum AutoLabCameraFacing: String, Codable, Sendable {
    case back
    case front
}

public enum AutoLabCameraImageFormat: String, Codable, Sendable {
    case jpg
    case jpeg
}

public enum AutoLabCameraVideoFormat: String, Codable, Sendable {
    case mp4
}

public struct AutoLabCameraSnapParams: Codable, Sendable, Equatable {
    public var facing: AutoLabCameraFacing?
    public var maxWidth: Int?
    public var quality: Double?
    public var format: AutoLabCameraImageFormat?
    public var deviceId: String?
    public var delayMs: Int?

    public init(
        facing: AutoLabCameraFacing? = nil,
        maxWidth: Int? = nil,
        quality: Double? = nil,
        format: AutoLabCameraImageFormat? = nil,
        deviceId: String? = nil,
        delayMs: Int? = nil)
    {
        self.facing = facing
        self.maxWidth = maxWidth
        self.quality = quality
        self.format = format
        self.deviceId = deviceId
        self.delayMs = delayMs
    }
}

public struct AutoLabCameraClipParams: Codable, Sendable, Equatable {
    public var facing: AutoLabCameraFacing?
    public var durationMs: Int?
    public var includeAudio: Bool?
    public var format: AutoLabCameraVideoFormat?
    public var deviceId: String?

    public init(
        facing: AutoLabCameraFacing? = nil,
        durationMs: Int? = nil,
        includeAudio: Bool? = nil,
        format: AutoLabCameraVideoFormat? = nil,
        deviceId: String? = nil)
    {
        self.facing = facing
        self.durationMs = durationMs
        self.includeAudio = includeAudio
        self.format = format
        self.deviceId = deviceId
    }
}
