os.execute("clear")

print([[
 █████╗ ██╗   ██╗████████╗ ██████╗ 
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗
███████║██║   ██║   ██║   ██║   ██║
██╔══██║██║   ██║   ██║   ██║   ██║
██║  ██║╚██████╔╝   ██║   ╚██████╔╝
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ 
       AUTO INSTALLER v1.0
]])

print("====================================")
print("      Online APK Auto Installer")
print("====================================\n")

local json_url="https://raw.githubusercontent.com/Fidss/AutoInstaller/main/apps.json"

print("Mengambil database aplikasi...\n")

os.execute("curl -s "..json_url.." -o apps.json")

local json=require("dkjson")
local f=io.open("apps.json","r")
local data=json.decode(f:read("*a"))
f:close()

local apps=data.apps

print("Daftar aplikasi:\n")

for i,v in ipairs(apps) do
print(i..". "..v.name)
end

print("\nMenu:")
print("1. Install aplikasi tertentu")
print("2. Install semua aplikasi")

io.write("\nPilih menu: ")
local menu=io.read()

local selected={}

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

print("\nMemulai instalasi...\n")

for _,i in ipairs(selected) do

local app=apps[i]
local apk=app.name..".apk"

print("================================")
print("Aplikasi : "..app.name)
print("================================")

-- cek apakah sudah terinstall
local check=os.execute("su -c 'pm list packages | grep "..app.package.."'")

if check==0 then
print("Status : Update aplikasi")
else
print("Status : Install baru")
end

print("\nDownloading...")

os.execute("aria2c -x 16 -s 16 "..app.url.." -o '"..apk.."'")

print("\nInstalling...")

os.execute("su -c 'pm install -r "..apk.."'")

print("\nSelesai install "..app.name.."\n")

end

print("====================================")
print("        SEMUA PROSES SELESAI")
print("====================================")
