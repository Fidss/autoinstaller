os.execute("clear")

-- WARNA
local red="\27[31m"
local green="\27[32m"
local yellow="\27[33m"
local cyan="\27[36m"
local reset="\27[0m"

-- CLEAR AMAN (ANTI BUG TERMUX)
function clear()
    io.write("\27[2J\27[H")
end

-- HEADER (SIMPLE BIAR GAK RUSAK)
function header()
    print(cyan..[[
 █████╗ ██╗   ██╗████████╗ ██████╗ 
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗
███████║██║   ██║   ██║   ██║   ██║
██╔══██║██║   ██║   ██║   ██║   ██║
██║  ██║╚██████╔╝   ██║   ╚██████╔╝
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝
]]..reset)
    print(green.."AUTO INSTALLER PRO"..reset)
    print("================================\n")
end

-- PROGRESS BAR AMAN
function progress(text)
    io.write(cyan..text.." ")
    for i=1,20 do
        io.write("#")
        io.flush()
        os.execute("sleep 0.05")
    end
    print(reset)
end

-- =========================
-- FITUR
-- =========================

function auto_setup()
    progress("Setup storage")
    os.execute("termux-setup-storage")

    progress("Update system")
    os.execute("pkg update -y && pkg upgrade -y")

    progress("Install package")
    os.execute("pkg install -y lua53 tsu python figlet android-tools sqlite")

    progress("Install python module")
    os.execute("pip install pyfiglet rich")

    print(green.."✓ Auto setup selesai"..reset)
end

function optimize()
    progress("Optimasi ringan")
    os.execute("settings put global animator_duration_scale 0")
    os.execute("settings put global transition_animation_scale 0")
    os.execute("settings put global window_animation_scale 0")

    print(green.."✓ Optimasi selesai"..reset)
end

function gaming()
    progress("Gaming boost")
    os.execute("cmd power set-fixed-performance-mode-enabled true")
    print(green.."✓ Gaming mode aktif"..reset)
end

function set_dpi()
    print("\nPilih DPI:")
    print("1. 360 (Default)")
    print("2. 420 (Sedikit kecil)")
    print("3. 480 (Lebih kecil)")

    io.write("Pilih: ")
    local pilih = io.read()

    if pilih=="1" then
        os.execute("wm density 360")
    elseif pilih=="2" then
        os.execute("wm density 420")
    elseif pilih=="3" then
        os.execute("wm density 480")
    else
        print(red.."Pilihan salah"..reset)
        return
    end

    print(green.."✓ DPI berhasil diubah"..reset)
end

function debloat()
    progress("Debloat ringan")
    os.execute("pm disable-user --user 0 com.facebook.katana")
    os.execute("pm disable-user --user 0 com.facebook.appmanager")

    print(green.."✓ Debloat selesai"..reset)
end

function enable_google()
    progress("Enable Play Store & Chrome")
    os.execute("pm enable com.android.vending")
    os.execute("pm enable com.android.chrome")

    print(green.."✓ Google aktif kembali"..reset)
end

-- =========================
-- KAERU
-- =========================

function install_kaeru()
    progress("Download Kaeru")
    os.execute("curl -L -o /sdcard/Download/kaeru.lua https://raw.githubusercontent.com/pgen0x/kaeru/refs/heads/main/kaeru.lua")

    print(green.."✓ Kaeru berhasil diinstall"..reset)
end

function run_kaeru()
    local f = io.open("/sdcard/Download/kaeru.lua","r")

    if not f then
        print(red.."Kaeru belum diinstall!"..reset)
        return
    end

    f:close()

    progress("Menjalankan Kaeru")
    os.execute("lua /sdcard/Download/kaeru.lua")
end

-- =========================
-- MENU UTAMA (ANTI BUG)
-- =========================

function main_menu()
    clear()
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
        os.exit()
    else
        print(red.."Pilihan tidak valid"..reset)
    end

    print("\nTekan Enter untuk kembali...")
    io.read()
    main_menu()
end

-- JALANKAN
main_menu()
