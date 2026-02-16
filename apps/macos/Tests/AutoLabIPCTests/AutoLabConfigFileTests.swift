import Foundation
import Testing
@testable import AutoLab

@Suite(.serialized)
struct AutoLabConfigFileTests {
    @Test
    func configPathRespectsEnvOverride() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("autolab-config-\(UUID().uuidString)")
            .appendingPathComponent("autolab.json")
            .path

        await TestIsolation.withEnvValues(["AUTOLAB_CONFIG_PATH": override]) {
            #expect(AutoLabConfigFile.url().path == override)
        }
    }

    @MainActor
    @Test
    func remoteGatewayPortParsesAndMatchesHost() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("autolab-config-\(UUID().uuidString)")
            .appendingPathComponent("autolab.json")
            .path

        await TestIsolation.withEnvValues(["AUTOLAB_CONFIG_PATH": override]) {
            AutoLabConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "ws://gateway.ts.net:19999",
                    ],
                ],
            ])
            #expect(AutoLabConfigFile.remoteGatewayPort() == 19999)
            #expect(AutoLabConfigFile.remoteGatewayPort(matchingHost: "gateway.ts.net") == 19999)
            #expect(AutoLabConfigFile.remoteGatewayPort(matchingHost: "gateway") == 19999)
            #expect(AutoLabConfigFile.remoteGatewayPort(matchingHost: "other.ts.net") == nil)
        }
    }

    @MainActor
    @Test
    func setRemoteGatewayUrlPreservesScheme() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("autolab-config-\(UUID().uuidString)")
            .appendingPathComponent("autolab.json")
            .path

        await TestIsolation.withEnvValues(["AUTOLAB_CONFIG_PATH": override]) {
            AutoLabConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "wss://old-host:111",
                    ],
                ],
            ])
            AutoLabConfigFile.setRemoteGatewayUrl(host: "new-host", port: 2222)
            let root = AutoLabConfigFile.loadDict()
            let url = ((root["gateway"] as? [String: Any])?["remote"] as? [String: Any])?["url"] as? String
            #expect(url == "wss://new-host:2222")
        }
    }

    @Test
    func stateDirOverrideSetsConfigPath() async {
        let dir = FileManager().temporaryDirectory
            .appendingPathComponent("autolab-state-\(UUID().uuidString)", isDirectory: true)
            .path

        await TestIsolation.withEnvValues([
            "AUTOLAB_CONFIG_PATH": nil,
            "AUTOLAB_STATE_DIR": dir,
        ]) {
            #expect(AutoLabConfigFile.stateDirURL().path == dir)
            #expect(AutoLabConfigFile.url().path == "\(dir)/autolab.json")
        }
    }

    @MainActor
    @Test
    func saveDictAppendsConfigAuditLog() async throws {
        let stateDir = FileManager().temporaryDirectory
            .appendingPathComponent("autolab-state-\(UUID().uuidString)", isDirectory: true)
        let configPath = stateDir.appendingPathComponent("autolab.json")
        let auditPath = stateDir.appendingPathComponent("logs/config-audit.jsonl")

        defer { try? FileManager().removeItem(at: stateDir) }

        try await TestIsolation.withEnvValues([
            "AUTOLAB_STATE_DIR": stateDir.path,
            "AUTOLAB_CONFIG_PATH": configPath.path,
        ]) {
            AutoLabConfigFile.saveDict([
                "gateway": ["mode": "local"],
            ])

            let configData = try Data(contentsOf: configPath)
            let configRoot = try JSONSerialization.jsonObject(with: configData) as? [String: Any]
            #expect((configRoot?["meta"] as? [String: Any]) != nil)

            let rawAudit = try String(contentsOf: auditPath, encoding: .utf8)
            let lines = rawAudit
                .split(whereSeparator: \.isNewline)
                .map(String.init)
            #expect(!lines.isEmpty)
            guard let last = lines.last else {
                Issue.record("Missing config audit line")
                return
            }
            let auditRoot = try JSONSerialization.jsonObject(with: Data(last.utf8)) as? [String: Any]
            #expect(auditRoot?["source"] as? String == "macos-autolab-config-file")
            #expect(auditRoot?["event"] as? String == "config.write")
            #expect(auditRoot?["result"] as? String == "success")
            #expect(auditRoot?["configPath"] as? String == configPath.path)
        }
    }
}
