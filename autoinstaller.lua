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

-- LOADING
function loading(text)
io.write(cyan..text)
for i=1,3 do
io.write(".")
io.flush()
os.execute("sleep 0.4")
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

print(green.."        AUTO INSTALLER PRO"..reset)
print(yellow.."===================================="..reset)

local model=io.popen("getprop ro.product.model"):read("*l")
local android=io.popen("getprop ro.build.version.release"):read("*l")

print("Device  : "..model)
print("Android : "..android)
print("CPU     : "..detect_cpu())
print("RAM     : "..detect_ram())

print(yellow.."====================================\n"..reset)

end

-- ROOT CHECK
local root_check = io.popen("su -c id"):read("*a")
if not root_check:find("uid=0") then
print(red.."Root tidak tersedia!"..reset)
os.exit()
end

-- 30+ ANDROID TWEAKS
function android_tweaks()

loading("Apply Android Tweaks")

os.execute("su -c 'settings put global window_animation_scale 0'")
os.execute("su -c 'settings put global transition_animation_scale 0'")
os.execute("su -c 'settings put global animator_duration_scale 0'")

os.execute("su -c 'settings put global enable_freeform_support 1'")
os.execute("su -c 'settings put global force_resizable_activities 1'")

os.execute("su -c 'setprop debug.hwui.renderer opengl'")
os.execute("su -c 'setprop debug.egl.hw 1'")

os.execute("su -c 'settings put system pointer_speed 7'")

os.execute("su -c 'settings put global tcp_default_init_rwnd 60'")
os.execute("su -c 'settings put global wifi_scan_always_enabled 0'")

os.execute("su -c 'echo 3 > /proc/sys/vm/drop_caches'")
os.execute("su -c 'setprop persist.sys.purgeable_assets 1'")

os.execute("su -c 'setprop dalvik.vm.heapstartsize 8m'")
os.execute("su -c 'setprop dalvik.vm.heaptargetutilization 0.75'")
os.execute("su -c 'setprop dalvik.vm.heapgrowthlimit 256m'")
os.execute("su -c 'setprop dalvik.vm.heapsize 512m'")

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

os.execute("su -c 'setprop debug.sf.hw 1'")
os.execute("su -c 'setprop debug.sf.latch_unsignaled 1'")

os.execute("su -c 'setprop debug.hwui.profile false'")

os.execute("su -c 'setprop ro.input.noresample 1'")

os.execute("su -c 'setprop audio.offload.disable 0'")

print(green.."✓ 30+ Android Tweaks Applied!"..reset)

end

while true do

header()

print(magenta.."MENU UTAMA"..reset)

print("1 Auto Setup System")
print("2 Optimize System")
print("3 Gaming Boost Mode")
print("4 Install Kaeru")
print("5 Run Kaeru")
print("6 Set DPI")
print("0 Keluar")

io.write("\nPilih menu: ")
local menu=io.read()

-- AUTO SETUP
if menu=="1" then

print(cyan.."\nPilih DPI:\n"..reset)

print("1. 360 (Default)")
print("2. 420 (Recommended)")
print("3. 480")
print("4. 520")
print("5. Custom")

io.write("\nPilihan: ")
local dpi_menu = io.read()

local dpi="420"

if dpi_menu=="1" then
dpi="360"
elseif dpi_menu=="2" then
dpi="420"
elseif dpi_menu=="3" then
dpi="480"
elseif dpi_menu=="4" then
dpi="520"
elseif dpi_menu=="5" then
io.write("Masukkan DPI: ")
dpi=io.read()
end

loading("Reset DPI")
os.execute("su -c 'wm density reset'")

loading("Set DPI "..dpi)
os.execute("su -c 'wm density "..dpi.."'")

loading("Enable Developer Mode")
os.execute("su -c 'settings put global development_settings_enabled 1'")

loading("Disable Animations")
os.execute("su -c 'settings put global window_animation_scale 0'")
os.execute("su -c 'settings put global transition_animation_scale 0'")
os.execute("su -c 'settings put global animator_duration_scale 0'")

loading("Enable Freeform Mode")
os.execute("su -c 'settings put global enable_freeform_support 1'")
os.execute("su -c 'settings put global force_resizable_activities 1'")

android_tweaks()

print(green.."\n✓ Auto Setup selesai\n"..reset)
io.read()

-- OPTIMIZE
elseif menu=="2" then

loading("Cleaning Cache")
os.execute("su -c 'rm -rf /data/cache/*'")

loading("RAM Boost")
os.execute("su -c 'echo 3 > /proc/sys/vm/drop_caches'")

loading("Kill Background Apps")
os.execute("su -c 'am kill-all'")

android_tweaks()

print(green.."✓ Optimize selesai\n"..reset)
io.read()

-- GAMING MODE
elseif menu=="3" then

loading("RAM Boost")
os.execute("su -c 'echo 3 > /proc/sys/vm/drop_caches'")

loading("Kill Background Apps")
os.execute("su -c 'am kill-all'")

loading("Performance Mode")
os.execute("su -c 'cmd power set-fixed-performance-mode-enabled true'")

loading("GPU Boost")
os.execute("su -c 'setprop debug.hwui.renderer opengl'")

print(green.."✓ Gaming mode aktif\n"..reset)
io.read()

-- INSTALL KAERU
elseif menu=="4" then

loading("Download Kaeru")
os.execute("curl -L -o /sdcard/Download/kaeru.lua https://raw.githubusercontent.com/pgen0x/kaeru/refs/heads/main/kaeru.lua")

print(green.."✓ Kaeru berhasil di download\n"..reset)
io.read()

-- RUN KAERU
elseif menu=="5" then

loading("Running Kaeru")
os.execute("lua /sdcard/Download/kaeru.lua")

-- SET DPI
elseif menu=="6" then

io.write("Masukkan DPI: ")
local dpi=io.read()

loading("Set DPI "..dpi)

os.execute("su -c 'wm density reset'")
os.execute("su -c 'wm density "..dpi.."'")

print(green.."✓ DPI berhasil diubah\n"..reset)
io.read()

elseif menu=="0" then
print("Keluar...")
break
end

end
