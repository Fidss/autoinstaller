os.execute("clear")

-- warna terminal
local red="\27[31m"
local green="\27[32m"
local yellow="\27[33m"
local cyan="\27[36m"
local reset="\27[0m"

print(cyan..[[
 █████╗ ██╗   ██╗████████╗ ██████╗ 
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗
███████║██║   ██║   ██║   ██║   ██║
██╔══██║██║   ██║   ██║   ██║   ██║
██║  ██║╚██████╔╝   ██║   ╚██████╔╝
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ 
]]..reset)

print(green.."        AUTO INSTALLER v3"..reset)
print(yellow.."===================================="..reset)
print("      Online APK Auto Installer")
print(yellow.."====================================\n"..reset)

local json_url="https://raw.githubusercontent.com/Fidss/AutoInstaller/main/apps.json"

print(cyan.."Mengambil database aplikasi...\n"..reset)

os.execute("curl -L -s "..json_url.." -o apps.json")

local json=require("dkjson")
local f=io.open("apps.json","r")

if not f then
print(red.."Gagal mengambil database aplikasi"..reset)
os.exit()
end

local data=json.decode(f:read("*a"))
f:close()

local apps=data.apps

print(green.."Daftar aplikasi:\n"..reset)

for i,v in ipairs(apps) do
print(cyan..i..". "..reset..v.name)
end

print("\nMenu:")
print("1. Install aplikasi tertentu")
print("2. Install semua aplikasi")
print("3. Uninstall aplikasi user")

io.write("\nPilih menu: ")
local menu=io.read()

local selected={}

-- ================= INSTALL =================

if menu=="1" then

print("\nMasukkan nomor aplikasi (contoh: 1,3,5)")
io.write("Pilihan: ")
local input=io.read()

for num in string.gmatch(input,"%d+") do
table.insert(selected,tonumber(num))
end

elseif menu=="2" then

for i=1,#apps do
table.insert(selected,i)
end

end

if menu=="1" or menu=="2" then

print("\n"..yellow.."Memulai instalasi...\n"..reset)

local home="/data/data/com.termux/files/home/"

for _,i in ipairs(selected) do

local app=apps[i]
local apk="app"..i..".apk"

print(yellow.."================================"..reset)
print(green.."Aplikasi : "..app.name..reset)
print(yellow.."================================"..reset)

print(cyan.."Downloading..."..reset)

-- progress bar asli
os.execute("curl -L --progress-bar '"..app.url.."' -o '"..apk.."'")

print(green.."\nDownload selesai"..reset)

print(cyan.."Installing..."..reset)

os.execute("su -c 'pm install -r "..home..apk.."'")

print(green.."Selesai install "..app.name.."\n"..reset)

end

-- ================= UNINSTALL =================

elseif menu=="3" then

print(cyan.."\nMendeteksi aplikasi user...\n"..reset)

local handle=io.popen("pm list packages -3")
local packages={}

for line in handle:lines() do
local pkg=line:gsub("package:","")
table.insert(packages,pkg)
end
handle:close()

if #packages==0 then
print(red.."Tidak ada aplikasi user ditemukan"..reset)
os.exit()
end

print(green.."Daftar aplikasi user:\n"..reset)

for i,pkg in ipairs(packages) do
print(cyan..i..". "..reset..pkg)
end

print("\nMasukkan nomor aplikasi yang ingin di uninstall (contoh: 1,3,5)")
io.write("Pilihan: ")
local input=io.read()

for num in string.gmatch(input,"%d+") do
table.insert(selected,tonumber(num))
end

print("\n"..yellow.."Memulai uninstall...\n"..reset)

for _,i in ipairs(selected) do

local pkg=packages[i]

if pkg then

print(yellow.."================================"..reset)
print(green.."Uninstall : "..pkg..reset)
print(yellow.."================================"..reset)

os.execute("su -c 'pm uninstall "..pkg.."'")

print(green.."Selesai uninstall "..pkg.."\n"..reset)

end

end

end

print(yellow.."===================================="..reset)
print(green.."        SEMUA PROSES SELESAI"..reset)
print(yellow.."===================================="..reset)
