import { afterEach, beforeEach } from "vitest";
import { AutoLabApp } from "../app.ts";

// oxlint-disable-next-line typescript/unbound-method
const originalConnect = AutoLabApp.prototype.connect;

export function mountApp(pathname: string) {
  window.history.replaceState({}, "", pathname);
  const app = document.createElement("autolab-app") as AutoLabApp;
  document.body.append(app);
  return app;
}

export function registerAppMountHooks() {
  beforeEach(() => {
    AutoLabApp.prototype.connect = () => {
      // no-op: avoid real gateway WS connections in browser tests
    };
    window.__AUTOLAB_CONTROL_UI_BASE_PATH__ = undefined;
    localStorage.clear();
    document.body.innerHTML = "";
  });

  afterEach(() => {
    AutoLabApp.prototype.connect = originalConnect;
    window.__AUTOLAB_CONTROL_UI_BASE_PATH__ = undefined;
    localStorage.clear();
    document.body.innerHTML = "";
  });
}
