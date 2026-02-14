import Foundation

public enum AutoLabChatTransportEvent: Sendable {
    case health(ok: Bool)
    case tick
    case chat(AutoLabChatEventPayload)
    case agent(AutoLabAgentEventPayload)
    case seqGap
}

public protocol AutoLabChatTransport: Sendable {
    func requestHistory(sessionKey: String) async throws -> AutoLabChatHistoryPayload
    func sendMessage(
        sessionKey: String,
        message: String,
        thinking: String,
        idempotencyKey: String,
        attachments: [AutoLabChatAttachmentPayload]) async throws -> AutoLabChatSendResponse

    func abortRun(sessionKey: String, runId: String) async throws
    func listSessions(limit: Int?) async throws -> AutoLabChatSessionsListResponse

    func requestHealth(timeoutMs: Int) async throws -> Bool
    func events() -> AsyncStream<AutoLabChatTransportEvent>

    func setActiveSessionKey(_ sessionKey: String) async throws
}

extension AutoLabChatTransport {
    public func setActiveSessionKey(_: String) async throws {}

    public func abortRun(sessionKey _: String, runId _: String) async throws {
        throw NSError(
            domain: "AutoLabChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "chat.abort not supported by this transport"])
    }

    public func listSessions(limit _: Int?) async throws -> AutoLabChatSessionsListResponse {
        throw NSError(
            domain: "AutoLabChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "sessions.list not supported by this transport"])
    }
}
