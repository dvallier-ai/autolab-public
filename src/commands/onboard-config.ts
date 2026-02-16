import type { AutoLabConfig } from "../config/config.js";

export function applyOnboardingLocalWorkspaceConfig(
  baseConfig: AutoLabConfig,
  workspaceDir: string,
): AutoLabConfig {
  return {
    ...baseConfig,
    agents: {
      ...baseConfig.agents,
      defaults: {
        ...baseConfig.agents?.defaults,
        workspace: workspaceDir,
      },
    },
    gateway: {
      ...baseConfig.gateway,
      mode: "local",
    },
  };
}
