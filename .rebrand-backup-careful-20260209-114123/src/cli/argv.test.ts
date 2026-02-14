import { describe, expect, it } from "vitest";
import {
  buildParseArgv,
  getFlagValue,
  getCommandPath,
  getPrimaryCommand,
  getPositiveIntFlagValue,
  getVerboseFlag,
  hasHelpOrVersion,
  hasFlag,
  shouldMigrateState,
  shouldMigrateStateFromPath,
} from "./argv.js";

describe("argv helpers", () => {
  it("detects help/version flags", () => {
    expect(hasHelpOrVersion(["node", "autolab", "--help"])).toBe(true);
    expect(hasHelpOrVersion(["node", "autolab", "-V"])).toBe(true);
    expect(hasHelpOrVersion(["node", "autolab", "status"])).toBe(false);
  });

  it("extracts command path ignoring flags and terminator", () => {
    expect(getCommandPath(["node", "autolab", "status", "--json"], 2)).toEqual(["status"]);
    expect(getCommandPath(["node", "autolab", "agents", "list"], 2)).toEqual(["agents", "list"]);
    expect(getCommandPath(["node", "autolab", "status", "--", "ignored"], 2)).toEqual(["status"]);
  });

  it("returns primary command", () => {
    expect(getPrimaryCommand(["node", "autolab", "agents", "list"])).toBe("agents");
    expect(getPrimaryCommand(["node", "autolab"])).toBeNull();
  });

  it("parses boolean flags and ignores terminator", () => {
    expect(hasFlag(["node", "autolab", "status", "--json"], "--json")).toBe(true);
    expect(hasFlag(["node", "autolab", "--", "--json"], "--json")).toBe(false);
  });

  it("extracts flag values with equals and missing values", () => {
    expect(getFlagValue(["node", "autolab", "status", "--timeout", "5000"], "--timeout")).toBe(
      "5000",
    );
    expect(getFlagValue(["node", "autolab", "status", "--timeout=2500"], "--timeout")).toBe(
      "2500",
    );
    expect(getFlagValue(["node", "autolab", "status", "--timeout"], "--timeout")).toBeNull();
    expect(getFlagValue(["node", "autolab", "status", "--timeout", "--json"], "--timeout")).toBe(
      null,
    );
    expect(getFlagValue(["node", "autolab", "--", "--timeout=99"], "--timeout")).toBeUndefined();
  });

  it("parses verbose flags", () => {
    expect(getVerboseFlag(["node", "autolab", "status", "--verbose"])).toBe(true);
    expect(getVerboseFlag(["node", "autolab", "status", "--debug"])).toBe(false);
    expect(getVerboseFlag(["node", "autolab", "status", "--debug"], { includeDebug: true })).toBe(
      true,
    );
  });

  it("parses positive integer flag values", () => {
    expect(getPositiveIntFlagValue(["node", "autolab", "status"], "--timeout")).toBeUndefined();
    expect(
      getPositiveIntFlagValue(["node", "autolab", "status", "--timeout"], "--timeout"),
    ).toBeNull();
    expect(
      getPositiveIntFlagValue(["node", "autolab", "status", "--timeout", "5000"], "--timeout"),
    ).toBe(5000);
    expect(
      getPositiveIntFlagValue(["node", "autolab", "status", "--timeout", "nope"], "--timeout"),
    ).toBeUndefined();
  });

  it("builds parse argv from raw args", () => {
    const nodeArgv = buildParseArgv({
      programName: "autolab",
      rawArgs: ["node", "autolab", "status"],
    });
    expect(nodeArgv).toEqual(["node", "autolab", "status"]);

    const versionedNodeArgv = buildParseArgv({
      programName: "autolab",
      rawArgs: ["node-22", "autolab", "status"],
    });
    expect(versionedNodeArgv).toEqual(["node-22", "autolab", "status"]);

    const versionedNodeWindowsArgv = buildParseArgv({
      programName: "autolab",
      rawArgs: ["node-22.2.0.exe", "autolab", "status"],
    });
    expect(versionedNodeWindowsArgv).toEqual(["node-22.2.0.exe", "autolab", "status"]);

    const versionedNodePatchlessArgv = buildParseArgv({
      programName: "autolab",
      rawArgs: ["node-22.2", "autolab", "status"],
    });
    expect(versionedNodePatchlessArgv).toEqual(["node-22.2", "autolab", "status"]);

    const versionedNodeWindowsPatchlessArgv = buildParseArgv({
      programName: "autolab",
      rawArgs: ["node-22.2.exe", "autolab", "status"],
    });
    expect(versionedNodeWindowsPatchlessArgv).toEqual(["node-22.2.exe", "autolab", "status"]);

    const versionedNodeWithPathArgv = buildParseArgv({
      programName: "autolab",
      rawArgs: ["/usr/bin/node-22.2.0", "autolab", "status"],
    });
    expect(versionedNodeWithPathArgv).toEqual(["/usr/bin/node-22.2.0", "autolab", "status"]);

    const nodejsArgv = buildParseArgv({
      programName: "autolab",
      rawArgs: ["nodejs", "autolab", "status"],
    });
    expect(nodejsArgv).toEqual(["nodejs", "autolab", "status"]);

    const nonVersionedNodeArgv = buildParseArgv({
      programName: "autolab",
      rawArgs: ["node-dev", "autolab", "status"],
    });
    expect(nonVersionedNodeArgv).toEqual(["node", "autolab", "node-dev", "autolab", "status"]);

    const directArgv = buildParseArgv({
      programName: "autolab",
      rawArgs: ["autolab", "status"],
    });
    expect(directArgv).toEqual(["node", "autolab", "status"]);

    const bunArgv = buildParseArgv({
      programName: "autolab",
      rawArgs: ["bun", "src/entry.ts", "status"],
    });
    expect(bunArgv).toEqual(["bun", "src/entry.ts", "status"]);
  });

  it("builds parse argv from fallback args", () => {
    const fallbackArgv = buildParseArgv({
      programName: "autolab",
      fallbackArgv: ["status"],
    });
    expect(fallbackArgv).toEqual(["node", "autolab", "status"]);
  });

  it("decides when to migrate state", () => {
    expect(shouldMigrateState(["node", "autolab", "status"])).toBe(false);
    expect(shouldMigrateState(["node", "autolab", "health"])).toBe(false);
    expect(shouldMigrateState(["node", "autolab", "sessions"])).toBe(false);
    expect(shouldMigrateState(["node", "autolab", "memory", "status"])).toBe(false);
    expect(shouldMigrateState(["node", "autolab", "agent", "--message", "hi"])).toBe(false);
    expect(shouldMigrateState(["node", "autolab", "agents", "list"])).toBe(true);
    expect(shouldMigrateState(["node", "autolab", "message", "send"])).toBe(true);
  });

  it("reuses command path for migrate state decisions", () => {
    expect(shouldMigrateStateFromPath(["status"])).toBe(false);
    expect(shouldMigrateStateFromPath(["agents", "list"])).toBe(true);
  });
});
