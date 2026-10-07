{ lib, ... }:

let
  inherit (lib.generators) mkLuaInline;
  toLua' = lib.generators.toLua;
  toLua = generatorConfig: toLua' ({ multiline = false; } // generatorConfig);
  mkCmd = cmd: mkLuaInline "hl.${cmd}";
  mkDsp = target: mkCmd "dsp.${target}";
  mkWrappedCmd = (
    { wrapperFunction ? (x: x)
    , wrappedCmd ? "true"
    }:
    {
      __functor = wrapperFunction;
      _raw = wrappedCmd;
    }
  );
  quickWrap = wrappedCmd: wrapperFunction: mkWrappedCmd { inherit wrapperFunction wrappedCmd; };
in {
  hl = {
    exec_cmd = arg: mkCmd "exec_cmd(${toLua { } arg})";
    dsp = {
      # Almost every use of this uses app2unit, so do that
      exec_cmd = quickWrap (arg: mkDsp "exec_cmd(${toLua { } arg})") (final: arg: final._raw "app2unit -- ${arg}");
      focus = arg: mkDsp "focus(${toLua { } arg})";
      window = {
        move = arg: mkDsp "window.move(${toLua { } arg})";
        drag = mkDsp "window.drag()";
        resize = mkDsp "window.resize()";
        close = mkDsp "window.close()";
        kill = mkDsp "window.kill()";
        fullscreen = mkDsp "window.fullscreen()";
        float = mkDsp "window.float()";
      };
      workspace = {
        move = arg: mkDsp "workspace.move(${toLua { } arg})";
      };
    };
  };
}
