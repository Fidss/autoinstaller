os.execute("clear")

-- WARNA TERMINAL
local red="\27[31m"
local green="\27[32m"
local yellow="\27[33m"
local cyan="\27[36m"
local magenta="\27[35m"
local reset="\27[0m"

-- DETECT RAM
function detect_ram()
local f=io.open("/proc/meminfo","r")
for line in f:lines() do
if line:find("MemTotal") then
local ram=line:match("(%d+)")
ram=tonumber(ram)/1024
return math.floor(ram).." MB"
end
end
end

-- DETECT CPU
function detect_cpu()
local p=io.popen("getprop ro.product.cpu.abi")
local cpu=p:read("*l")
p:close()
return cpu
end

-- DETECT DPI DEFAULT
function detect_dpi()
local p=io.popen("wm density")
local d=p:read("*a")
p:close()

local dpi=d:match("(%d+)")
return dpi
end

-- AUTO CALCULATE DPI
function optimal_dpi()

local dpi=tonumber(detect_dpi())

if dpi < 360 then
return "360"
elseif dpi < 420 then
return "420"
elseif dpi < 480 then
return "440"
else
return "480"
end

end

-- PROGRESS BAR
function progress(text)

io.write(cyan..text.." ")

for i=1,20 do
io.write("#")
io.flush()
os.execute("sleep 0.05")
end

print(reset)

end

-- HEADER
function header()

os.execute("clear")

print(cyan..[[
 █████╗ ██╗   ██╗████████╗ ██████╗ 
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗
███████║██║   ██║   ██║   ██║   ██║
██╔══██║██║   ██║   ██║   ██║   ██║
██║  ██║╚██████╔╝   ██║   ╚██████╔╝
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ 
]]..reset)

print(green.."        AUTO INSTALLER PRO v3"..reset)
print(yellow.."===================================="..reset)

local model=io.popen("getprop ro.product.model"):read("*l")
local android=io.popen("getprop ro.build.version.release"):read("*l")

print("Device  : "..model)
print("Android : "..android)
print("CPU     : "..detect_cpu())
print("RAM     : "..detect_ram())
print("DPI     : "..detect_dpi())

print(yellow.."====================================\n"..reset)

end

-- ROOT CHECK
local root_check = io.popen("su -c id"):read("*a")

if not root_check:find("uid=0") then
print(red.."Root tidak tersedia!"..reset)
os.exit()
end

-- 50+ ANDROID TWEAKS
function android_tweaks()

progress("Applying Android Tweaks")

os.execute("su -c 'settings put global window_animation_scale 0'")
os.execute("su -c 'settings put global transition_animation_scale 0'")
os.execute("su -c 'settings put global animator_duration_scale 0'")

os.execute("su -c 'settings put global enable_freeform_support 1'")
os.execute("su -c 'settings put global force_resizable_activities 1'")

os.execute("su -c 'settings put system pointer_speed 7'")

os.execute("su -c 'settings put global wifi_scan_always_enabled 0'")

os.execute("su -c 'setprop debug.hwui.renderer opengl'")
os.execute("su -c 'setprop debug.egl.hw 1'")

os.execute("su -c 'setprop debug.performance.tuning 1'")
os.execute("su -c 'setprop video.accelerate.hw 1'")

os.execute("su -c 'setprop windowsmgr.max_events_per_sec 150'")

os.execute("su -c 'setprop log.tag.stats_log OFF'")
os.execute("su -c 'setprop log.tag.SQLiteLog OFF'")

os.execute("su -c 'settings put global background_process_limit 2'")

os.execute("su -c 'setprop ro.config.hw_fast_dormancy 1'")

os.execute("su -c 'setprop debug.composition.type gpu'")

os.execute("su -c 'settings put global show_crash_dialog 0'")
os.execute("su -c 'settings put global app_standby_enabled 0'")

os.execute("su -c 'settings put global force_gpu_rendering 1'")

os.execute("su -c 'setprop persist.sys.strictmode.disable true'")

os.execute("su -c 'setprop sys.io.scheduler noop'")

os.execute("su -c 'setprop net.tcp.buffersize.default 4096,87380,256960,4096,16384,256960'")

os.execute("su -c 'echo 3 > /proc/sys/vm/drop_caches'")

os.execute("su -c 'setprop debug.sf.hw 1'")
os.execute("su -c 'setprop debug.sf.latch_unsignaled 1'")

os.execute("su -c 'setprop debug.hwui.profile false'")

os.execute("su -c 'setprop ro.input.noresample 1'")

os.execute("su -c 'setprop audio.offload.disable 0'")

print(green.."✓ 50+ Tweaks Applied!"..reset)

end

-- MENU LOOP
while true do

header()

print(magenta.."MENU UTAMA"..reset)

print("1 Auto Setup System")
print("2 Optimize System")
print("3 Gaming Boost Mode")
print("4 Set DPI Manual")
print("0 Keluar")

io.write("\nPilih menu: ")
local menu=io.read()

-- AUTO SETUP
if menu=="1" then

local dpi=optimal_dpi()

progress("Reset DPI")
os.execute("su -c 'wm density reset'")

progress("Apply Optimal DPI "..dpi)
os.execute("su -c 'wm density "..dpi.."'")

progress("Enable Developer Mode")
os.execute("su -c 'settings put global development_settings_enabled 1'")

android_tweaks()

print(green.."\nAuto Setup selesai!"..reset)

os.execute("sleep 2")

-- OPTIMIZE
elseif menu=="2" then

progress("Cleaning Cache")
os.execute("su -c 'rm -rf /data/cache/*'")

progress("RAM Boost")
os.execute("su -c 'echo 3 > /proc/sys/vm/drop_caches'")

progress("Kill Background Apps")
os.execute("su -c 'am kill-all'")

android_tweaks()

print(green.."Optimize selesai!"..reset)

os.execute("sleep 2")

-- GAMING MODE
elseif menu=="3" then

progress("RAM Boost")
os.execute("su -c 'echo 3 > /proc/sys/vm/drop_caches'")

progress("Kill Background Apps")
os.execute("su -c 'am kill-all'")

progress("Enable Performance Mode")
os.execute("su -c 'cmd power set-fixed-performance-mode-enabled true'")

progress("GPU Boost")
os.execute("su -c 'setprop debug.hwui.renderer opengl'")

print(green.."Gaming Mode aktif!"..reset)

os.execute("sleep 2")

-- SET DPI MANUAL
elseif menu=="4" then

io.write("Masukkan DPI: ")
local dpi=io.read()

progress("Apply DPI "..dpi)

os.execute("su -c 'wm density reset'")
os.execute("su -c 'wm density "..dpi.."'")

print(green.."DPI berhasil diubah!"..reset)

os.execute("sleep 2")

elseif menu=="0" then
print("Keluar...")
break
end

end
