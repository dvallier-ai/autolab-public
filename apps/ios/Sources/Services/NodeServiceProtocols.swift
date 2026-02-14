import CoreLocation
import Foundation
import AutoLabKit
import UIKit

protocol CameraServicing: Sendable {
    func listDevices() async -> [CameraController.CameraDeviceInfo]
    func snap(params: AutoLabCameraSnapParams) async throws -> (format: String, base64: String, width: Int, height: Int)
    func clip(params: AutoLabCameraClipParams) async throws -> (format: String, base64: String, durationMs: Int, hasAudio: Bool)
}

protocol ScreenRecordingServicing: Sendable {
    func record(
        screenIndex: Int?,
        durationMs: Int?,
        fps: Double?,
        includeAudio: Bool?,
        outPath: String?) async throws -> String
}

@MainActor
protocol LocationServicing: Sendable {
    func authorizationStatus() -> CLAuthorizationStatus
    func accuracyAuthorization() -> CLAccuracyAuthorization
    func ensureAuthorization(mode: AutoLabLocationMode) async -> CLAuthorizationStatus
    func currentLocation(
        params: AutoLabLocationGetParams,
        desiredAccuracy: AutoLabLocationAccuracy,
        maxAgeMs: Int?,
        timeoutMs: Int?) async throws -> CLLocation
}

protocol DeviceStatusServicing: Sendable {
    func status() async throws -> AutoLabDeviceStatusPayload
    func info() -> AutoLabDeviceInfoPayload
}

protocol PhotosServicing: Sendable {
    func latest(params: AutoLabPhotosLatestParams) async throws -> AutoLabPhotosLatestPayload
}

protocol ContactsServicing: Sendable {
    func search(params: AutoLabContactsSearchParams) async throws -> AutoLabContactsSearchPayload
    func add(params: AutoLabContactsAddParams) async throws -> AutoLabContactsAddPayload
}

protocol CalendarServicing: Sendable {
    func events(params: AutoLabCalendarEventsParams) async throws -> AutoLabCalendarEventsPayload
    func add(params: AutoLabCalendarAddParams) async throws -> AutoLabCalendarAddPayload
}

protocol RemindersServicing: Sendable {
    func list(params: AutoLabRemindersListParams) async throws -> AutoLabRemindersListPayload
    func add(params: AutoLabRemindersAddParams) async throws -> AutoLabRemindersAddPayload
}

protocol MotionServicing: Sendable {
    func activities(params: AutoLabMotionActivityParams) async throws -> AutoLabMotionActivityPayload
    func pedometer(params: AutoLabPedometerParams) async throws -> AutoLabPedometerPayload
}

extension CameraController: CameraServicing {}
extension ScreenRecordService: ScreenRecordingServicing {}
extension LocationService: LocationServicing {}
