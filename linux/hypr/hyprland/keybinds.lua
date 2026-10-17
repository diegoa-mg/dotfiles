local vars = require("variables")
local fn   = require("hyprland.functions")

local function dms(cmd) return hl.dsp.exec_cmd("dms ipc call " .. cmd) end

-- Alterna un workspace especial con una app: si la app no existe, la abre oculta en ese workspace
local function toggle_app(special, class, cmd)
    return function()
        local found = false
        for _, w in pairs(hl.get_windows()) do
            if w.class == class then
                found = true
                break
            end
        end
        if found then
            hl.dispatch(hl.dsp.workspace.toggle_special(special))
        else
            hl.dispatch(hl.dsp.exec_cmd(cmd, { workspace = "special:" .. special .. " silent" }))
        end
    end
end

---------------
---- DMS ----
---------------

-- Launcher
hl.bind("SUPER + SUPER_L", dms("spotlight toggle"), { release = true })

-- Misc
hl.bind(vars.kbSession, dms("powermenu toggle"))
hl.bind(vars.kbShowSidebar, dms("notifications toggle"))
hl.bind(vars.kbClearNotifs, dms("notifications clearAll"), { locked = true })
hl.bind(vars.kbShowPanels, dms("control-center toggle"))
hl.bind(vars.kbLock, dms("lock lock"))

-- Restore lock (levanta DMS solo si no está corriendo)
hl.bind(vars.kbRestoreLock, function()
    hl.dispatch(hl.dsp.exec_cmd("pgrep -f 'dms run' >/dev/null || dms run"))
    hl.dispatch(dms("lock lock"))
end)

-- Brightness
hl.bind("XF86MonBrightnessUp", dms('brightness increment 5 ""'), { locked = true })
hl.bind("XF86MonBrightnessDown", dms('brightness decrement 5 ""'), { locked = true })

-- Media
hl.bind("CTRL + SUPER + M", dms("mpris playPause"), { locked = true })
hl.bind("XF86AudioPlay", dms("mpris playPause"), { locked = true })
hl.bind("XF86AudioPause", dms("mpris playPause"), { locked = true })
hl.bind("CTRL + SUPER + Equal", dms("mpris next"), { locked = true })
hl.bind("XF86AudioNext", dms("mpris next"), { locked = true })
hl.bind("CTRL + SUPER + Minus", dms("mpris previous"), { locked = true })
hl.bind("XF86AudioPrev", dms("mpris previous"), { locked = true })
hl.bind("XF86AudioStop", dms("mpris stop"), { locked = true })

-- Kill/restart
hl.bind("CTRL + SUPER + SHIFT + R", hl.dsp.exec_cmd("dms kill"), { release = true })
hl.bind("CTRL + SUPER + ALT + R", hl.dsp.exec_cmd("dms restart"), { release = true })

-- Portapapeles (historial de DMS)
hl.bind("SUPER + V", dms("clipboard toggle"))

-- Captura por área (herramienta de DMS)
hl.bind("SUPER + SHIFT + ALT + S", dms("screenshot begin"))

-----------------------
---- WORKSPACES ----
-----------------------

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(vars.kbGoToWs .. " + " .. key, fn.wsaction("focus", "", i))
    hl.bind(vars.kbMoveWinToWs .. " + " .. key, fn.wsaction("move", "", i))
    hl.bind(vars.kbGoToWsGroup .. " + " .. key, fn.wsaction("focus", "group", i))
    hl.bind(vars.kbMoveWinToWsGroup .. " + " .. key, fn.wsaction("move", "group", i))
end

-- Go to workspace -1/+1
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "-1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "+1" }))
hl.bind(vars.kbPrevWs, hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind(vars.kbNextWs, hl.dsp.focus({ workspace = "+1" }), { repeating = true })
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind("SUPER + Page_down", hl.dsp.focus({ workspace = "+1" }), { repeating = true })

-- Go to workspace group -1/+1
hl.bind("CTRL + SUPER + mouse_down", hl.dsp.focus({ workspace = "-10" }))
hl.bind("CTRL + SUPER + mouse_up", hl.dsp.focus({ workspace = "+10" }))

-- Move window to workspace -1/+1
-- hl.wbind("SUPER + ALT + Page_Up", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })
hl.bind("SUPER + ALT + O", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })
-- hl.bind("SUPER + ALT + Page_Down", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind("SUPER + ALT + P", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind("SUPER + ALT + mouse_down", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + ALT + mouse_up", hl.dsp.window.move({ workspace = "+1" }))
-- hl.bind("CTRL + SUPER + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind("CTRL + SUPER + SHIFT + L", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
-- hl.bind("CTRL + SUPER + SHIFT + left", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })
hl.bind("CTRL + SUPER + SHIFT + J", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })

-- Move window to/from special workspace
-- hl.bind("CTRL + SUPER + SHIFT + up", hl.dsp.window.move({ workspace = "special:special" }))
hl.bind("CTRL + SUPER + SHIFT + I", hl.dsp.window.move({ workspace = "special:special" }))
-- hl.bind("CTRL + SUPER + SHIFT + down", hl.dsp.window.move({ workspace = "e+0" }))
hl.bind("CTRL + SUPER + SHIFT + K", hl.dsp.window.move({ workspace = "e+0" }))
hl.bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:special" }))

-- Window groups
hl.bind(vars.kbWindowGroupCycleNext, hl.dsp.window.cycle_next(), { repeating = true })
hl.bind(vars.kbWindowGroupCyclePrev, hl.dsp.window.cycle_next({ next = false }), { repeating = true })
hl.bind("CTRL + ALT + Tab", hl.dsp.group.next(), { repeating = true })
hl.bind("CTRL + SHIFT + ALT + Tab", hl.dsp.group.prev(), { repeating = true })
hl.bind(vars.kbToggleGroup, hl.dsp.group.toggle())
hl.bind(vars.kbUngroup, hl.dsp.window.move({ out_of_group = true }))
hl.bind("SUPER + SHIFT + Comma", hl.dsp.group.lock_active())

-- Window actions
-- hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "left" }))
-- hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
-- hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + I", hl.dsp.focus({ direction = "up" }))
-- hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "down" }))
-- hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "left" }))
-- hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
-- hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + I", hl.dsp.window.move({ direction = "up" }))
-- hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + Minus", hl.dsp.window.resize(fn.resize_active_window(-10, 0)), { repeating = true })
hl.bind("SUPER + Equal", hl.dsp.window.resize(fn.resize_active_window(10, 0)), { repeating = true })
hl.bind("SUPER + SHIFT + Minus", hl.dsp.window.resize(fn.resize_active_window(0, -10)), { repeating = true })
hl.bind("SUPER + SHIFT + Equal", hl.dsp.window.resize(fn.resize_active_window(0, 10)), { repeating = true })
-- hl.bind("SUPER + ALT + left", hl.dsp.window.resize(fn.resize_active_window(-10, 0)), { repeating = true })
hl.bind("SUPER + ALT + J", hl.dsp.window.resize(fn.resize_active_window(-10, 0)), { repeating = true })
-- hl.bind("SUPER + ALT + right", hl.dsp.window.resize(fn.resize_active_window(10, 0)), { repeating = true })
hl.bind("SUPER + ALT + L", hl.dsp.window.resize(fn.resize_active_window(10, 0)), { repeating = true })
-- hl.bind("SUPER + ALT + up", hl.dsp.window.resize(fn.resize_active_window(0, -10)), { repeating = true })
hl.bind("SUPER + ALT + I", hl.dsp.window.resize(fn.resize_active_window(0, -10)), { repeating = true })
-- hl.bind("SUPER + ALT + down", hl.dsp.window.resize(fn.resize_active_window(0, 10)), { repeating = true })
hl.bind("SUPER + ALT + K", hl.dsp.window.resize(fn.resize_active_window(0, 10)), { repeating = true })

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(vars.kbMoveWindow, hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(vars.kbResizeWindow, hl.dsp.window.resize(), { mouse = true })
hl.bind("CTRL + SUPER + Backslash", hl.dsp.window.center())
hl.bind("CTRL + SUPER + ALT + Backslash", hl.dsp.window.resize(fn.resize_by_screen(55, 70)))
hl.bind("CTRL + SUPER + ALT + Backslash", hl.dsp.window.center())
hl.bind(vars.kbWindowPip, function()
    local a = hl.get_active_window()
    if a then
        local pip = fn.move_actions(a) or {}
        if not a.floating then table.insert(pip, 1, hl.dsp.window.float()) end
        table.insert(pip, hl.dsp.window.pin({ action = "on", window = "address:" .. a.address }))

        for _, x in ipairs(pip) do
            hl.dispatch(x)
        end
    end
end)
hl.bind(vars.kbPinWindow, hl.dsp.window.pin())
hl.bind(vars.kbWindowFullscreen, hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(vars.kbWindowBorderedFullscreen, hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(vars.kbToggleWindowFloating, hl.dsp.window.float())
hl.bind(vars.kbCloseWindow, hl.dsp.window.close())

-- Special workspace toggles (nativos)
hl.bind(vars.kbSpecialWs, hl.dsp.workspace.toggle_special("special"))
hl.bind(vars.kbSystemMonitorWs, toggle_app("sysmon", "btop", "foot -a btop -T btop btop"))
hl.bind(vars.kbCommunicationWs, toggle_app("communication", "discord", "discord"))

-- Apps
hl.bind(vars.kbTerminal, hl.dsp.exec_cmd(vars.terminal))
hl.bind(vars.kbBrowser, hl.dsp.exec_cmd(vars.browser))
hl.bind(vars.kbEditor, hl.dsp.exec_cmd(vars.editor))
hl.bind(vars.kbFileExplorer, hl.dsp.exec_cmd(vars.fileExplorer))
hl.bind("CTRL + ALT + V", hl.dsp.exec_cmd(vars.audioSettings))

-- Utilities
-- Captura de pantalla completa: copia la imagen automaticamente
hl.bind("Print", hl.dsp.exec_cmd("grim - | wl-copy && notify-send 'Screenshot' 'Copiada al portapapeles'"), { locked = true })
-- Captura con seleccion de ventana o area: copia la imagen automaticamente
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("CHOICE=$(hyprctl clients -j | jq -r '.[] | select(.workspace.id == '$(hyprctl activeworkspace -j | jq '.id')') | .at[0],.at[1],.size[0],.size[1]' | awk 'NR%4==1{x=$0} NR%4==2{y=$0} NR%4==3{w=$0} NR%4==0{print x\",\"y\" \"w\"x\"$0}' | slurp); [ -n \"$CHOICE\" ] && grim -g \"$CHOICE\" - | wl-copy && notify-send 'Screenshot' 'Copiada al portapapeles'"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Volume
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l " ..
        (vars.volumeMax / 100) .. " @DEFAULT_AUDIO_SINK@ " .. vars.volumeStep .. "%+"
    ),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ " .. vars.volumeStep .. "%-"
    ),
    { locked = true, repeating = true }
)

-- Sleep
-- OJO: SUPER + SHIFT + L tambien esta asignado a "mover ventana a la derecha" (arriba)
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd(vars.sleepGestureCmd), { locked = true })

-- Pegar el ultimo elemento del portapapeles escribiendolo
hl.bind(
    "CTRL + SHIFT + ALT + V",
    hl.dsp.exec_cmd('sleep 0.5s && ydotool type -d 1 "$(cliphist list | head -1 | cliphist decode)"'),
    { locked = true }
)
-- Vaciar portapapeles
hl.bind("SUPER + ALT + X", hl.dsp.exec_cmd("cliphist wipe && rm -f ~/.cache/cliphist/db && notify-send 'Portapapeles' 'Historial completamente vaciado'"))

-- Switch language
hl.bind("CTRL + SUPER + space", hl.dsp.exec_cmd("hyprctl switchxkblayout current next"))

-- Sidra custom
hl.bind("SUPER + M", function()
    local found = false
    for _, w in pairs(hl.get_windows()) do
        if w.class == "sidra" then
            found = true
            break
        end
    end
    if found then
        hl.dispatch(hl.dsp.workspace.toggle_special("music"))
    else
        hl.dispatch(hl.dsp.exec_cmd("sidra", { workspace = "special:music silent" }))
    end
end)

-- Open school calendar
hl.bind("SUPER + Y", hl.dsp.exec_cmd("imv '/home/diego/Pictures/calendario_tercero.jpg'"))
