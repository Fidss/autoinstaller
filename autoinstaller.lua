os.execute("clear")

-- WARNA TERMINAL
local red="\27[31m"
local green="\27[32m"
local yellow="\27[33m"
local cyan="\27[36m"
local magenta="\27[35m"
local reset="\27[0m"

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

print(green.."        AUTO INSTALLER v7"..reset)
print(yellow.."===================================="..reset)
print(" Online APK Installer + Optimizer")
print(yellow.."====================================\n"..reset)
end

function loading(text)
io.write(cyan..text)
for i=1,3 do
io.write(".")
io.flush()
os.execute("sleep 0.5")
end
print(reset)
end

-- CEK ROOT
local root_check = io.popen("su -c id"):read("*a")
if not root_check:find("uid=0") then
print(red.."Root tidak tersedia! Jalankan dengan su/root"..reset)
os.exit()
end

while true do

header()

print(magenta.."MENU UTAMA"..reset)
print("┌───────────────────────────────┐")
print("│ 1. Install aplikasi tertentu  │")
print("│ 2. Install semua aplikasi     │")
print("│ 3. Auto Setup System          │")
print("│ 4. Optimize System            │")
print("│ 5. Install Kaeru              │")
print("│ 6. Run Kaeru                  │")
print("│ 0. Keluar                     │")
print("└───────────────────────────────┘")

io.write("\nPilih menu: ")
local menu=io.read()

-- AUTO SETUP
if menu=="3" then

loading("Mengaktifkan developer mode")
os.execute("su -c 'settings put global development_settings_enabled 1'")

loading("Mengatur DPI")
os.execute("su -c 'wm density 500'")

loading("Mematikan animasi")
os.execute("su -c 'settings put global window_animation_scale 0'")
os.execute("su -c 'settings put global transition_animation_scale 0'")
os.execute("su -c 'settings put global animator_duration_scale 0'")

loading("Mengaktifkan freeform mode")
os.execute("su -c 'settings put global enable_freeform_support 1'")
os.execute("su -c 'settings put global force_resizable_activities 1'")

print(green.."\n✓ Auto Setup selesai\n"..reset)
io.read()

-- OPTIMIZE
elseif menu=="4" then

loading("Membersihkan cache")
os.execute("su -c 'rm -rf /data/cache/*'")
os.execute("su -c 'rm -rf /cache/*'")

loading("Membersihkan RAM")
os.execute("su -c 'echo 3 > /proc/sys/vm/drop_caches'")

loading("Menghentikan background apps")
os.execute("su -c 'am kill-all'")

print(green.."\n✓ Optimize selesai\n"..reset)
io.read()

-- INSTALL KAERU
elseif menu=="5" then

print(cyan.."Menginstall Kaeru...\n"..reset)

os.execute("termux-setup-storage")
os.execute("pkg update -y && pkg upgrade -y")
os.execute("pkg install -y lua53 tsu python figlet android-tools sqlite")

os.execute("pip install pyfiglet rich")

os.execute("curl -L -o /sdcard/download/kaeru.lua https://raw.githubusercontent.com/pgen0x/kaeru/refs/heads/main/kaeru.lua")

print(green.."\n✓ Kaeru berhasil di install\n"..reset)
io.read()

-- RUN KAERU
elseif menu=="6" then

print(cyan.."Menjalankan Kaeru...\n"..reset)
os.execute("lua /sdcard/download/kaeru.lua")

-- INSTALL APK
elseif menu=="1" or menu=="2" then

loading("Mengambil database aplikasi")

os.execute("curl -L -s https://raw.githubusercontent.com/Fidss/AutoInstaller/main/apps.json -o apps.json")

local json=require("dkjson")
local f=io.open("apps.json","r")

if not f then
print(red.."Database gagal diambil"..reset)
io.read()
goto continue
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

if menu=="1" then
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
io.read()

elseif menu=="0" then
print(green.."Keluar dari program..."..reset)
break
end

::continue::

end
