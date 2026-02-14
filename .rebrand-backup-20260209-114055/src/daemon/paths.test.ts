import path from "node:path";
import { describe, expect, it } from "vitest";
import { resolveGatewayStateDir } from "./paths.js";

describe("resolveGatewayStateDir", () => {
  it("uses the default state dir when no overrides are set", () => {
    const env = { HOME: "/Users/test" };
    expect(resolveGatewayStateDir(env)).toBe(path.join("/Users/test", ".autolab"));
  });

  it("appends the profile suffix when set", () => {
    const env = { HOME: "/Users/test", AUTOLAB_PROFILE: "rescue" };
    expect(resolveGatewayStateDir(env)).toBe(path.join("/Users/test", ".autolab-rescue"));
  });

  it("treats default profiles as the base state dir", () => {
    const env = { HOME: "/Users/test", AUTOLAB_PROFILE: "Default" };
    expect(resolveGatewayStateDir(env)).toBe(path.join("/Users/test", ".autolab"));
  });

  it("uses AUTOLAB_STATE_DIR when provided", () => {
    const env = { HOME: "/Users/test", AUTOLAB_STATE_DIR: "/var/lib/autolab" };
    expect(resolveGatewayStateDir(env)).toBe(path.resolve("/var/lib/autolab"));
  });

  it("expands ~ in AUTOLAB_STATE_DIR", () => {
    const env = { HOME: "/Users/test", AUTOLAB_STATE_DIR: "~/autolab-state" };
    expect(resolveGatewayStateDir(env)).toBe(path.resolve("/Users/test/autolab-state"));
  });

  it("preserves Windows absolute paths without HOME", () => {
    const env = { AUTOLAB_STATE_DIR: "C:\\State\\autolab" };
    expect(resolveGatewayStateDir(env)).toBe("C:\\State\\autolab");
  });
});
