import type { AutoLabPluginApi } from "autolab/plugin-sdk";
import { emptyPluginConfigSchema } from "autolab/plugin-sdk";
import { createDiagnosticsOtelService } from "./src/service.js";

const plugin = {
  id: "diagnostics-otel",
  name: "Diagnostics OpenTelemetry",
  description: "Export diagnostics events to OpenTelemetry",
  configSchema: emptyPluginConfigSchema(),
  register(api: AutoLabPluginApi) {
    api.registerService(createDiagnosticsOtelService());
  },
};

export default plugin;
