import Foundation

// Stable identifier used for both the macOS LaunchAgent label and Nix-managed defaults suite.
// nix-autolab writes app defaults into this suite to survive app bundle identifier churn.
let launchdLabel = "ai.autolab.mac"
let gatewayLaunchdLabel = "ai.autolab.gateway"
let onboardingVersionKey = "autolab.onboardingVersion"
let onboardingSeenKey = "autolab.onboardingSeen"
let currentOnboardingVersion = 7
let pauseDefaultsKey = "autolab.pauseEnabled"
let iconAnimationsEnabledKey = "autolab.iconAnimationsEnabled"
let swabbleEnabledKey = "autolab.swabbleEnabled"
let swabbleTriggersKey = "autolab.swabbleTriggers"
let voiceWakeTriggerChimeKey = "autolab.voiceWakeTriggerChime"
let voiceWakeSendChimeKey = "autolab.voiceWakeSendChime"
let showDockIconKey = "autolab.showDockIcon"
let defaultVoiceWakeTriggers = ["autolab"]
let voiceWakeMaxWords = 32
let voiceWakeMaxWordLength = 64
let voiceWakeMicKey = "autolab.voiceWakeMicID"
let voiceWakeMicNameKey = "autolab.voiceWakeMicName"
let voiceWakeLocaleKey = "autolab.voiceWakeLocaleID"
let voiceWakeAdditionalLocalesKey = "autolab.voiceWakeAdditionalLocaleIDs"
let voicePushToTalkEnabledKey = "autolab.voicePushToTalkEnabled"
let talkEnabledKey = "autolab.talkEnabled"
let iconOverrideKey = "autolab.iconOverride"
let connectionModeKey = "autolab.connectionMode"
let remoteTargetKey = "autolab.remoteTarget"
let remoteIdentityKey = "autolab.remoteIdentity"
let remoteProjectRootKey = "autolab.remoteProjectRoot"
let remoteCliPathKey = "autolab.remoteCliPath"
let canvasEnabledKey = "autolab.canvasEnabled"
let cameraEnabledKey = "autolab.cameraEnabled"
let systemRunPolicyKey = "autolab.systemRunPolicy"
let systemRunAllowlistKey = "autolab.systemRunAllowlist"
let systemRunEnabledKey = "autolab.systemRunEnabled"
let locationModeKey = "autolab.locationMode"
let locationPreciseKey = "autolab.locationPreciseEnabled"
let peekabooBridgeEnabledKey = "autolab.peekabooBridgeEnabled"
let deepLinkKeyKey = "autolab.deepLinkKey"
let modelCatalogPathKey = "autolab.modelCatalogPath"
let modelCatalogReloadKey = "autolab.modelCatalogReload"
let cliInstallPromptedVersionKey = "autolab.cliInstallPromptedVersion"
let heartbeatsEnabledKey = "autolab.heartbeatsEnabled"
let debugPaneEnabledKey = "autolab.debugPaneEnabled"
let debugFileLogEnabledKey = "autolab.debug.fileLogEnabled"
let appLogLevelKey = "autolab.debug.appLogLevel"
let voiceWakeSupported: Bool = ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 26
