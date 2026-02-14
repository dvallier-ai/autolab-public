type StateDirEnvSnapshot = {
  autolabStateDir: string | undefined;
  clawdbotStateDir: string | undefined;
};

export function snapshotStateDirEnv(): StateDirEnvSnapshot {
  return {
    autolabStateDir: process.env.AUTOLAB_STATE_DIR,
    clawdbotStateDir: process.env.CLAWDBOT_STATE_DIR,
  };
}

export function restoreStateDirEnv(snapshot: StateDirEnvSnapshot): void {
  if (snapshot.autolabStateDir === undefined) {
    delete process.env.AUTOLAB_STATE_DIR;
  } else {
    process.env.AUTOLAB_STATE_DIR = snapshot.autolabStateDir;
  }
  if (snapshot.clawdbotStateDir === undefined) {
    delete process.env.CLAWDBOT_STATE_DIR;
  } else {
    process.env.CLAWDBOT_STATE_DIR = snapshot.clawdbotStateDir;
  }
}

export function setStateDirEnv(stateDir: string): void {
  process.env.AUTOLAB_STATE_DIR = stateDir;
  delete process.env.CLAWDBOT_STATE_DIR;
}
