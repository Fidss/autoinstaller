os.execute("clear")

-- WARNA
local red="\27[31m"
local green="\27[32m"
local yellow="\27[33m"
local cyan="\27[36m"
local magenta="\27[35m"
local reset="\27[0m"

-- PROGRESS BAR
function progress(text)
io.write(cyan..text.." ")
for i=1,25 do
io.write("#")
io.flush()
os.execute("sleep 0.03")
end
print(reset)
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

-- DETECT RAM
function detect_ram()
local f=io.open("/proc/meminfo","r")
if not f then return "Unknown" end
for line in f:lines() do
if line:find("MemTotal") then
local ram=line:match("(%d+)")
ram=tonumber(ram)/1024
return math.floor(ram).." MB"
end
end
return "Unknown"
end

-- DETECT CPU
function detect_cpu()
local p=io.popen("getprop ro.product.cpu.abi")
if not p then return "Unknown" end
local cpu=p:read("*l")
p:close()
return cpu or "Unknown"
end

-- DETECT DPI
function detect_dpi()
local p=io.popen("su -c '/system/bin/wm density' 2>/dev/null")
if not p then return "Unknown" end
local out=p:read("*a") or ""
p:close()
local dpi=out:match("Physical density:%s*(%d+)")
           or out:match("Override density:%s*(%d+)")
return dpi or "Unknown"
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

print(green.."      AUTO INSTALLER PRO"..reset)
print(yellow.."===================================="..reset)

local model=io.popen("getprop ro.product.model"):read("*l") or "Unknown"
local android=io.popen("getprop ro.build.version.release"):read("*l") or "Unknown"

print("Device  : "..model)
print("Android : "..android)
print("CPU     : "..detect_cpu())
print("RAM     : "..detect_ram())
print("DPI     : "..detect_dpi())

print(yellow.."====================================\n"..reset)

end

-- ROOT CHECK
local root_check = io.popen("su -c id"):read("*a")
if not root_check or not root_check:find("uid=0") then
print(red.."Root tidak tersedia!"..reset)
os.exit()
end

-- ANDROID TWEAKS
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

os.execute("su -c 'echo 3 > /proc/sys/vm/drop_caches'")

print(green.."✓ Tweaks Applied!"..reset)

end

-- INSTALL APK SYSTEM
function install_apps(mode)

loading("Mengambil database aplikasi")

os.execute("curl -L -s https://raw.githubusercontent.com/Fidss/AutoInstaller/main/apps.json -o apps.json")

local json=require("dkjson")
local f=io.open("apps.json","r")

if not f then
print(red.."Database gagal diambil"..reset)
return
end

local data=json.decode(f:read("*a"),1,nil)
f:close()

local apps=data.apps

print("\n"..green.."DAFTAR APLIKASI"..reset)
print("────────────────────────")

for i,v in ipairs(apps) do
print(cyan..i..". "..reset..v.name)
end

local selected={}

if mode=="manual" then

print("\nMasukkan nomor aplikasi (contoh: 1,3,5)")
io.write("Pilihan: ")
local input=io.read()

for num in string.gmatch(input,"%d+") do
table.insert(selected,tonumber(num))
end

else

for i=1,#apps do
table.insert(selected,i)
end

end

print("\n"..yellow.."Memulai instalasi...\n"..reset)

local home="/data/data/com.termux/files/home/"

for _,i in ipairs(selected) do

local app=apps[i]
local apk="app"..i..".apk"

print(magenta.."================================"..reset)
print(green.."Aplikasi : "..app.name..reset)
print(magenta.."================================"..reset)

print(cyan.."Downloading..."..reset)
os.execute("curl -L --progress-bar '"..app.url.."' -o '"..apk.."'")

loading("Installing "..app.name)

os.execute("su -c 'pm install -r "..home..apk.."'")

print(green.."✓ Install selesai\n"..reset)

end

print(green.."SEMUA INSTALASI SELESAI"..reset)
os.execute("sleep 2")

end

-- MENU
while true do

header()

print(magenta.."MENU UTAMA"..reset)
print("1 Auto Setup System")
print("2 Optimize System")
print("3 Gaming Boost Mode")
print("4 Set DPI Manual")
print("5 Install aplikasi tertentu")
print("6 Install semua aplikasi")
print("0 Keluar")

io.write("\nPilih menu: ")
local menu=io.read()

-- AUTO SETUP
if menu=="1" then

progress("Reset DPI")
os.execute("su -c '/system/bin/wm density reset'")

progress("Enable Developer Mode")
os.execute("su -c 'settings put global development_settings_enabled 1'")

progress("Enable Freeform Mode")
os.execute("su -c 'settings put global enable_freeform_support 1'")
os.execute("su -c 'settings put global force_resizable_activities 1'")

android_tweaks()

progress("Restart SystemUI")
os.execute("su -c 'pkill com.android.systemui'")

print(green.."Auto setup selesai!"..reset)
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

-- GAMING
elseif menu=="3" then

progress("RAM Boost")
os.execute("su -c 'echo 3 > /proc/sys/vm/drop_caches'")

progress("Kill Background Apps")
os.execute("su -c 'am kill-all'")

progress("Enable Performance Mode")
os.execute("su -c 'cmd power set-fixed-performance-mode-enabled true'")

progress("GPU Boost")
os.execute("su -c 'setprop debug.hwui.renderer opengl'")

print(green.."Gaming mode aktif!"..reset)
os.execute("sleep 2")

-- SET DPI
elseif menu=="4" then

io.write("Masukkan DPI: ")
local dpi=io.read()

progress("Apply DPI "..dpi)

os.execute("su -c '/system/bin/wm density reset'")
os.execute("su -c '/system/bin/wm density "..dpi.."'")

print(green.."DPI berhasil diubah!"..reset)
os.execute("sleep 2")

-- INSTALL APP
elseif menu=="5" then
install_apps("manual")

elseif menu=="6" then
install_apps("all")

elseif menu=="0" then
print("Keluar...")
break
end

end
