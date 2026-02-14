import type {
  AnyAgentTool,
  AutoLabPluginApi,
  AutoLabPluginToolFactory,
} from "../../src/plugins/types.js";
import { createLobsterTool } from "./src/lobster-tool.js";

export default function register(api: AutoLabPluginApi) {
  api.registerTool(
    ((ctx) => {
      if (ctx.sandboxed) {
        return null;
      }
      return createLobsterTool(api) as AnyAgentTool;
    }) as AutoLabPluginToolFactory,
    { optional: true },
  );
}
