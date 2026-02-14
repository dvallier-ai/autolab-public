import path from "node:path";
import { afterEach, describe, expect, it, vi } from "vitest";
import { resolveStorePath } from "./paths.js";

describe("resolveStorePath", () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it("uses AUTOLAB_HOME for tilde expansion", () => {
    vi.stubEnv("AUTOLAB_HOME", "/srv/autolab-home");
    vi.stubEnv("HOME", "/home/other");

    const resolved = resolveStorePath("~/.autolab/agents/{agentId}/sessions/sessions.json", {
      agentId: "research",
    });

    expect(resolved).toBe(
      path.resolve("/srv/autolab-home/.autolab/agents/research/sessions/sessions.json"),
    );
  });
});
