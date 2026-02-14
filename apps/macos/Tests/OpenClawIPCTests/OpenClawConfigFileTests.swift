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
}
