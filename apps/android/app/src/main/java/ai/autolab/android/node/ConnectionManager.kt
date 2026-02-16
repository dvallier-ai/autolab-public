package ai.autolab.android.node

import android.os.Build
import ai.autolab.android.BuildConfig
import ai.autolab.android.SecurePrefs
import ai.autolab.android.gateway.GatewayClientInfo
import ai.autolab.android.gateway.GatewayConnectOptions
import ai.autolab.android.gateway.GatewayEndpoint
import ai.autolab.android.gateway.GatewayTlsParams
import ai.autolab.android.protocol.AutoLabCanvasA2UICommand
import ai.autolab.android.protocol.AutoLabCanvasCommand
import ai.autolab.android.protocol.AutoLabCameraCommand
import ai.autolab.android.protocol.AutoLabLocationCommand
import ai.autolab.android.protocol.AutoLabScreenCommand
import ai.autolab.android.protocol.AutoLabSmsCommand
import ai.autolab.android.protocol.AutoLabCapability
import ai.autolab.android.LocationMode
import ai.autolab.android.VoiceWakeMode

class ConnectionManager(
  private val prefs: SecurePrefs,
  private val cameraEnabled: () -> Boolean,
  private val locationMode: () -> LocationMode,
  private val voiceWakeMode: () -> VoiceWakeMode,
  private val smsAvailable: () -> Boolean,
  private val hasRecordAudioPermission: () -> Boolean,
  private val manualTls: () -> Boolean,
) {
  companion object {
    internal fun resolveTlsParamsForEndpoint(
      endpoint: GatewayEndpoint,
      storedFingerprint: String?,
      manualTlsEnabled: Boolean,
    ): GatewayTlsParams? {
      val stableId = endpoint.stableId
      val stored = storedFingerprint?.trim().takeIf { !it.isNullOrEmpty() }
      val isManual = stableId.startsWith("manual|")

      if (isManual) {
        if (!manualTlsEnabled) return null
        if (!stored.isNullOrBlank()) {
          return GatewayTlsParams(
            required = true,
            expectedFingerprint = stored,
            allowTOFU = false,
            stableId = stableId,
          )
        }
        return GatewayTlsParams(
          required = true,
          expectedFingerprint = null,
          allowTOFU = false,
          stableId = stableId,
        )
      }

      // Prefer stored pins. Never let discovery-provided TXT override a stored fingerprint.
      if (!stored.isNullOrBlank()) {
        return GatewayTlsParams(
          required = true,
          expectedFingerprint = stored,
          allowTOFU = false,
          stableId = stableId,
        )
      }

      val hinted = endpoint.tlsEnabled || !endpoint.tlsFingerprintSha256.isNullOrBlank()
      if (hinted) {
        // TXT is unauthenticated. Do not treat the advertised fingerprint as authoritative.
        return GatewayTlsParams(
          required = true,
          expectedFingerprint = null,
          allowTOFU = false,
          stableId = stableId,
        )
      }

      return null
    }
  }

  fun buildInvokeCommands(): List<String> =
    buildList {
      add(AutoLabCanvasCommand.Present.rawValue)
      add(AutoLabCanvasCommand.Hide.rawValue)
      add(AutoLabCanvasCommand.Navigate.rawValue)
      add(AutoLabCanvasCommand.Eval.rawValue)
      add(AutoLabCanvasCommand.Snapshot.rawValue)
      add(AutoLabCanvasA2UICommand.Push.rawValue)
      add(AutoLabCanvasA2UICommand.PushJSONL.rawValue)
      add(AutoLabCanvasA2UICommand.Reset.rawValue)
      add(AutoLabScreenCommand.Record.rawValue)
      if (cameraEnabled()) {
        add(AutoLabCameraCommand.Snap.rawValue)
        add(AutoLabCameraCommand.Clip.rawValue)
      }
      if (locationMode() != LocationMode.Off) {
        add(AutoLabLocationCommand.Get.rawValue)
      }
      if (smsAvailable()) {
        add(AutoLabSmsCommand.Send.rawValue)
      }
      if (BuildConfig.DEBUG) {
        add("debug.logs")
        add("debug.ed25519")
      }
      add("app.update")
    }

  fun buildCapabilities(): List<String> =
    buildList {
      add(AutoLabCapability.Canvas.rawValue)
      add(AutoLabCapability.Screen.rawValue)
      if (cameraEnabled()) add(AutoLabCapability.Camera.rawValue)
      if (smsAvailable()) add(AutoLabCapability.Sms.rawValue)
      if (voiceWakeMode() != VoiceWakeMode.Off && hasRecordAudioPermission()) {
        add(AutoLabCapability.VoiceWake.rawValue)
      }
      if (locationMode() != LocationMode.Off) {
        add(AutoLabCapability.Location.rawValue)
      }
    }

  fun resolvedVersionName(): String {
    val versionName = BuildConfig.VERSION_NAME.trim().ifEmpty { "dev" }
    return if (BuildConfig.DEBUG && !versionName.contains("dev", ignoreCase = true)) {
      "$versionName-dev"
    } else {
      versionName
    }
  }

  fun resolveModelIdentifier(): String? {
    return listOfNotNull(Build.MANUFACTURER, Build.MODEL)
      .joinToString(" ")
      .trim()
      .ifEmpty { null }
  }

  fun buildUserAgent(): String {
    val version = resolvedVersionName()
    val release = Build.VERSION.RELEASE?.trim().orEmpty()
    val releaseLabel = if (release.isEmpty()) "unknown" else release
    return "AutoLabAndroid/$version (Android $releaseLabel; SDK ${Build.VERSION.SDK_INT})"
  }

  fun buildClientInfo(clientId: String, clientMode: String): GatewayClientInfo {
    return GatewayClientInfo(
      id = clientId,
      displayName = prefs.displayName.value,
      version = resolvedVersionName(),
      platform = "android",
      mode = clientMode,
      instanceId = prefs.instanceId.value,
      deviceFamily = "Android",
      modelIdentifier = resolveModelIdentifier(),
    )
  }

  fun buildNodeConnectOptions(): GatewayConnectOptions {
    return GatewayConnectOptions(
      role = "node",
      scopes = emptyList(),
      caps = buildCapabilities(),
      commands = buildInvokeCommands(),
      permissions = emptyMap(),
      client = buildClientInfo(clientId = "autolab-android", clientMode = "node"),
      userAgent = buildUserAgent(),
    )
  }

  fun buildOperatorConnectOptions(): GatewayConnectOptions {
    return GatewayConnectOptions(
      role = "operator",
      scopes = listOf("operator.read", "operator.write", "operator.talk.secrets"),
      caps = emptyList(),
      commands = emptyList(),
      permissions = emptyMap(),
      client = buildClientInfo(clientId = "autolab-control-ui", clientMode = "ui"),
      userAgent = buildUserAgent(),
    )
  }

  fun resolveTlsParams(endpoint: GatewayEndpoint): GatewayTlsParams? {
    val stored = prefs.loadGatewayTlsFingerprint(endpoint.stableId)
    return resolveTlsParamsForEndpoint(endpoint, storedFingerprint = stored, manualTlsEnabled = manualTls())
  }
}
