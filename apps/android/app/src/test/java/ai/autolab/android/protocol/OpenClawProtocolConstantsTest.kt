package ai.autolab.android.protocol

import org.junit.Assert.assertEquals
import org.junit.Test

class AutoLabProtocolConstantsTest {
  @Test
  fun canvasCommandsUseStableStrings() {
    assertEquals("canvas.present", AutoLabCanvasCommand.Present.rawValue)
    assertEquals("canvas.hide", AutoLabCanvasCommand.Hide.rawValue)
    assertEquals("canvas.navigate", AutoLabCanvasCommand.Navigate.rawValue)
    assertEquals("canvas.eval", AutoLabCanvasCommand.Eval.rawValue)
    assertEquals("canvas.snapshot", AutoLabCanvasCommand.Snapshot.rawValue)
  }

  @Test
  fun a2uiCommandsUseStableStrings() {
    assertEquals("canvas.a2ui.push", AutoLabCanvasA2UICommand.Push.rawValue)
    assertEquals("canvas.a2ui.pushJSONL", AutoLabCanvasA2UICommand.PushJSONL.rawValue)
    assertEquals("canvas.a2ui.reset", AutoLabCanvasA2UICommand.Reset.rawValue)
  }

  @Test
  fun capabilitiesUseStableStrings() {
    assertEquals("canvas", AutoLabCapability.Canvas.rawValue)
    assertEquals("camera", AutoLabCapability.Camera.rawValue)
    assertEquals("screen", AutoLabCapability.Screen.rawValue)
    assertEquals("voiceWake", AutoLabCapability.VoiceWake.rawValue)
  }

  @Test
  fun screenCommandsUseStableStrings() {
    assertEquals("screen.record", AutoLabScreenCommand.Record.rawValue)
  }
}
