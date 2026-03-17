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

-- ULTRA DEBLOAT MODE (EXTREME+)
function ultra_debloat()

progress("Clearing RAM")
os.execute("su -c 'sync; echo 3 > /proc/sys/vm/drop_caches'")

progress("Killing Background Apps")
os.execute("su -c 'am kill-all'")
os.execute("su -c 'pkill -f com.android'")
os.execute("su -c 'pkill -f google'")

progress("Force Stop All Apps")
os.execute("su -c 'cmd activity stop-app-switches'")

progress("Disable Play Store")
os.execute("su -c 'pm disable-user --user 0 com.android.vending'")

progress("Disable Google Feedback")
os.execute("su -c 'pm disable-user --user 0 com.google.android.feedback'")

progress("Disable Google Partner Setup")
os.execute("su -c 'pm disable-user --user 0 com.google.android.partnersetup'")

progress("Disable Google Sync")
os.execute("su -c 'settings put global master_sync_enabled 0'")

progress("Disable Job Scheduler")
os.execute("su -c 'cmd jobscheduler reset-execution-quota'")

progress("Disable Doze Mode")
os.execute("su -c 'dumpsys deviceidle disable'")

progress("Disable Location")
os.execute("su -c 'settings put secure location_mode 0'")

progress("Disable Sensors")
os.execute("su -c 'service call sensorservice 1'")

progress("Disable Animations")
os.execute("su -c 'settings put global window_animation_scale 0'")
os.execute("su -c 'settings put global transition_animation_scale 0'")
os.execute("su -c 'settings put global animator_duration_scale 0'")

progress("Stop Logcat")
os.execute("su -c 'logcat -c'")

progress("Clean Dalvik Cache")
os.execute("su -c 'rm -rf /data/dalvik-cache/*'")

progress("Clean System Cache")
os.execute("su -c 'rm -rf /data/cache/*'")

progress("Clean Temp Files")
os.execute("su -c 'rm -rf /data/local/tmp/*'")

progress("Disable Thermal Service")
os.execute("su -c 'stop thermal-engine'")

progress("Disable Stats Service")
os.execute("su -c 'stop statsd'")

progress("Restart SystemUI")
os.execute("su -c 'pkill com.android.systemui'")

progress("Final RAM Cleanup")
os.execute("su -c 'sync; echo 3 > /proc/sys/vm/drop_caches'")

print(green.."✓ ULTRA DEBLOAT EXTREME SELESAI"..reset)

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
    print("5 Ultra Debloat")
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
        ultra_debloat()
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
