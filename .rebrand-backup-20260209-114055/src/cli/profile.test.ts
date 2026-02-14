import path from "node:path";
import { describe, expect, it } from "vitest";
import { formatCliCommand } from "./command-format.js";
import { applyCliProfileEnv, parseCliProfileArgs } from "./profile.js";

describe("parseCliProfileArgs", () => {
  it("leaves gateway --dev for subcommands", () => {
    const res = parseCliProfileArgs([
      "node",
      "autolab",
      "gateway",
      "--dev",
      "--allow-unconfigured",
    ]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBeNull();
    expect(res.argv).toEqual(["node", "autolab", "gateway", "--dev", "--allow-unconfigured"]);
  });

  it("still accepts global --dev before subcommand", () => {
    const res = parseCliProfileArgs(["node", "autolab", "--dev", "gateway"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("dev");
    expect(res.argv).toEqual(["node", "autolab", "gateway"]);
  });

  it("parses --profile value and strips it", () => {
    const res = parseCliProfileArgs(["node", "autolab", "--profile", "work", "status"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("work");
    expect(res.argv).toEqual(["node", "autolab", "status"]);
  });

  it("rejects missing profile value", () => {
    const res = parseCliProfileArgs(["node", "autolab", "--profile"]);
    expect(res.ok).toBe(false);
  });

  it("rejects combining --dev with --profile (dev first)", () => {
    const res = parseCliProfileArgs(["node", "autolab", "--dev", "--profile", "work", "status"]);
    expect(res.ok).toBe(false);
  });

  it("rejects combining --dev with --profile (profile first)", () => {
    const res = parseCliProfileArgs(["node", "autolab", "--profile", "work", "--dev", "status"]);
    expect(res.ok).toBe(false);
  });
});

describe("applyCliProfileEnv", () => {
  it("fills env defaults for dev profile", () => {
    const env: Record<string, string | undefined> = {};
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    const expectedStateDir = path.join(path.resolve("/home/peter"), ".autolab-dev");
    expect(env.AUTOLAB_PROFILE).toBe("dev");
    expect(env.AUTOLAB_STATE_DIR).toBe(expectedStateDir);
    expect(env.AUTOLAB_CONFIG_PATH).toBe(path.join(expectedStateDir, "autolab.json"));
    expect(env.AUTOLAB_GATEWAY_PORT).toBe("19001");
  });

  it("does not override explicit env values", () => {
    const env: Record<string, string | undefined> = {
      AUTOLAB_STATE_DIR: "/custom",
      AUTOLAB_GATEWAY_PORT: "19099",
    };
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    expect(env.AUTOLAB_STATE_DIR).toBe("/custom");
    expect(env.AUTOLAB_GATEWAY_PORT).toBe("19099");
    expect(env.AUTOLAB_CONFIG_PATH).toBe(path.join("/custom", "autolab.json"));
  });

  it("uses AUTOLAB_HOME when deriving profile state dir", () => {
    const env: Record<string, string | undefined> = {
      AUTOLAB_HOME: "/srv/autolab-home",
      HOME: "/home/other",
    };
    applyCliProfileEnv({
      profile: "work",
      env,
      homedir: () => "/home/fallback",
    });

    const resolvedHome = path.resolve("/srv/autolab-home");
    expect(env.AUTOLAB_STATE_DIR).toBe(path.join(resolvedHome, ".autolab-work"));
    expect(env.AUTOLAB_CONFIG_PATH).toBe(
      path.join(resolvedHome, ".autolab-work", "autolab.json"),
    );
  });
});

describe("formatCliCommand", () => {
  it("returns command unchanged when no profile is set", () => {
    expect(formatCliCommand("autolab doctor --fix", {})).toBe("autolab doctor --fix");
  });

  it("returns command unchanged when profile is default", () => {
    expect(formatCliCommand("autolab doctor --fix", { AUTOLAB_PROFILE: "default" })).toBe(
      "autolab doctor --fix",
    );
  });

  it("returns command unchanged when profile is Default (case-insensitive)", () => {
    expect(formatCliCommand("autolab doctor --fix", { AUTOLAB_PROFILE: "Default" })).toBe(
      "autolab doctor --fix",
    );
  });

  it("returns command unchanged when profile is invalid", () => {
    expect(formatCliCommand("autolab doctor --fix", { AUTOLAB_PROFILE: "bad profile" })).toBe(
      "autolab doctor --fix",
    );
  });

  it("returns command unchanged when --profile is already present", () => {
    expect(
      formatCliCommand("autolab --profile work doctor --fix", { AUTOLAB_PROFILE: "work" }),
    ).toBe("autolab --profile work doctor --fix");
  });

  it("returns command unchanged when --dev is already present", () => {
    expect(formatCliCommand("autolab --dev doctor", { AUTOLAB_PROFILE: "dev" })).toBe(
      "autolab --dev doctor",
    );
  });

  it("inserts --profile flag when profile is set", () => {
    expect(formatCliCommand("autolab doctor --fix", { AUTOLAB_PROFILE: "work" })).toBe(
      "autolab --profile work doctor --fix",
    );
  });

  it("trims whitespace from profile", () => {
    expect(formatCliCommand("autolab doctor --fix", { AUTOLAB_PROFILE: "  jbautolab  " })).toBe(
      "autolab --profile jbautolab doctor --fix",
    );
  });

  it("handles command with no args after autolab", () => {
    expect(formatCliCommand("autolab", { AUTOLAB_PROFILE: "test" })).toBe(
      "autolab --profile test",
    );
  });

  it("handles pnpm wrapper", () => {
    expect(formatCliCommand("pnpm autolab doctor", { AUTOLAB_PROFILE: "work" })).toBe(
      "pnpm autolab --profile work doctor",
    );
  });
});
