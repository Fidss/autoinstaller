os.execute("clear")

-- WARNA
local red="\27[31m"
local green="\27[32m"
local yellow="\27[33m"
local cyan="\27[36m"
local reset="\27[0m"

-- PROGRESS
function progress(text)
    print(cyan..text.."..."..reset)
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
    local p=io.popen("wm density 2>/dev/null")
    if not p then return "Unknown" end
    local out=p:read("*a") or ""
    p:close()
    local dpi=out:match("Physical density:%s*(%d+)")
    return dpi or "Unknown"
end

-- HEADER + LOGO
function header()
    print(cyan..[[
 █████╗ ██╗   ██╗████████╗ ██████╗ 
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗
███████║██║   ██║   ██║   ██║   ██║
██╔══██║██║   ██║   ██║   ██║   ██║
██║  ██║╚██████╔╝   ██║   ╚██████╔╝
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝
]]..reset)

    print(green.."      AUTO INSTALLER PRO"..reset)
    print(yellow.."=============================="..reset)

    local model=io.popen("getprop ro.product.model"):read("*l") or "Unknown"
    local android=io.popen("getprop ro.build.version.release"):read("*l") or "Unknown"

    print("Device  : "..model)
    print("Android : "..android)
    print("CPU     : "..detect_cpu())
    print("RAM     : "..detect_ram())
    print("DPI     : "..detect_dpi())

    print(yellow.."==============================\n"..reset)
end

-- ROOT CHECK
local root_check = io.popen("su -c id 2>/dev/null"):read("*a")
if not root_check or not root_check:find("uid=0") then
    print(red.."Root tidak tersedia!"..reset)
    os.exit()
end

-- AUTO SETUP
function auto_setup()
    progress("Set DPI 220")
    os.execute("su -c 'wm density 220'")

    progress("Disable animasi")
    os.execute("su -c 'settings put global window_animation_scale 0'")
    os.execute("su -c 'settings put global transition_animation_scale 0'")
    os.execute("su -c 'settings put global animator_duration_scale 0'")

    progress("Performa mode")
    os.execute("su -c 'setprop debug.performance.tuning 1'")
    os.execute("su -c 'setprop video.accelerate.hw 1'")

    progress("Bersihkan RAM")
    os.execute("su -c 'sync; echo 3 > /proc/sys/vm/drop_caches'")

    print(green.."✓ Auto setup selesai"..reset)
end

-- OPTIMIZE
function optimize()
    progress("Bersihkan cache")
    os.execute("su -c 'rm -rf /data/cache/*'")

    progress("Boost RAM")
    os.execute("su -c 'sync; echo 3 > /proc/sys/vm/drop_caches'")

    progress("Kill background apps")
    os.execute("su -c 'am kill-all'")

    print(green.."✓ Optimize selesai"..reset)
end

-- GAMING
function gaming()
    progress("Boost RAM")
    os.execute("su -c 'sync; echo 3 > /proc/sys/vm/drop_caches'")

    progress("Kill apps")
    os.execute("su -c 'am kill-all'")

    progress("Mode performa")
    os.execute("su -c 'cmd power set-fixed-performance-mode-enabled true'")

    print(green.."✓ Gaming mode aktif"..reset)
end

-- DPI
function set_dpi()
    io.write("Masukkan DPI: ")
    local dpi=io.read()

    progress("Apply DPI "..dpi)
    os.execute("su -c 'wm density "..dpi.."'")

    print(green.."✓ DPI berhasil diubah"..reset)
end

-- DEBLOAT
function debloat()
    progress("Bersihkan RAM")
    os.execute("su -c 'sync; echo 3 > /proc/sys/vm/drop_caches'")

    progress("Kill background apps")
    os.execute("su -c 'am kill-all'")

    progress("Matikan animasi")
    os.execute("su -c 'settings put global window_animation_scale 0'")
    os.execute("su -c 'settings put global transition_animation_scale 0'")
    os.execute("su -c 'settings put global animator_duration_scale 0'")

    print(green.."✓ Debloat ringan selesai"..reset)
end

-- ENABLE GOOGLE
function enable_google()
    progress("Enable Play Store")
    os.execute("su -c 'pm enable com.android.vending'")

    progress("Enable Chrome")
    os.execute("su -c 'pm enable com.android.chrome'")

    progress("Enable Google Services")
    os.execute("su -c 'pm enable com.google.android.gms'")

    print(green.."✓ Google aktif kembali"..reset)
end

-- INSTALL KAERU
function install_kaeru()
    progress("Setup storage")
    os.execute("termux-setup-storage")

    progress("Update & upgrade")
    os.execute("pkg update -y && pkg upgrade -y")

    progress("Install package")
    os.execute("pkg install -y lua53 tsu python figlet android-tools sqlite")

    progress("Install python module")
    os.execute("pip install pyfiglet rich")

    progress("Download Kaeru")
    os.execute("curl -L -o /sdcard/Download/kaeru.lua https://raw.githubusercontent.com/pgen0x/kaeru/refs/heads/main/kaeru.lua")

    print(green.."✓ Kaeru berhasil diinstall"..reset)
end

-- RUN KAERU
function run_kaeru()
    local f = io.open("/sdcard/Download/kaeru.lua","r")
    if not f then
        print(red.."Kaeru belum diinstall!"..reset)
        return
    end
    f:close()

    progress("Menjalankan Kaeru")
    os.execute("lua /sdcard/Download/kaeru.lua || lua /sdcard/download/kaeru.lua")
end

-- MENU
while true do
    header()

    print("1 Auto Setup System")
    print("2 Optimize System")
    print("3 Gaming Boost Mode")
    print("4 Set DPI Manual")
    print("5 Debloat Ringan (Aman)")
    print("6 Enable Chrome & Play Store")
    print("7 Install Kaeru")
    print("8 Run Kaeru")
    print("0 Keluar")

    io.write("\nPilih menu: ")
    local menu = io.read()

    if menu=="1" then
        auto_setup()
    elseif menu=="2" then
        optimize()
    elseif menu=="3" then
        gaming()
    elseif menu=="4" then
        set_dpi()
    elseif menu=="5" then
        debloat()
    elseif menu=="6" then
        enable_google()
    elseif menu=="7" then
        install_kaeru()
    elseif menu=="8" then
        run_kaeru()
    elseif menu=="0" then
        print("Keluar...")
        break
    end

    print("\nTekan Enter untuk kembali ke menu...")
    io.read()
    os.execute("clear")
end
