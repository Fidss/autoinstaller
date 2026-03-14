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

progress("Disable Chrome")
os.execute("su -c 'pm disable-user --user 0 com.android.chrome'")

progress("Disable Google Feedback")
os.execute("su -c 'pm disable-user --user 0 com.google.android.feedback'")

progress("Disable Google Partner Setup")
os.execute("su -c 'pm disable-user --user 0 com.google.android.partnersetup'")

progress("Disable Google Sync")
os.execute("su -c 'settings put global master_sync_enabled 0'")

progress("Disable Job Scheduler")
os.execute("su -c 'cmd jobscheduler reset-execution-quota'")

progress("Disable Background Services")
os.execute("su -c 'settings put global background_process_limit 0'")

progress("Disable App Standby")
os.execute("su -c 'settings put global app_standby_enabled 0'")

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

-- EXTREME SERVICE DISABLE - SYSTEM UI + INTERNET ONLY
function extreme_disable()

progress("💀 Mode NUKLIR - Hanya System UI & Internet yang Hidup")

-- 1. PASTIKAN SYSTEM UI TETAP HIDUP
progress("🎯 Mengunci System UI")
os.execute("su -c 'pm enable com.android.systemui 2>/dev/null'")
os.execute("su -c 'am start-service com.android.systemui/.SystemUIService 2>/dev/null'")

-- 2. CADANGKAN DAN PASTIKAN INTERNET AKTIF
progress("🌐 Mengunci koneksi internet")
os.execute("su -c 'svc wifi enable'")
os.execute("su -c 'svc data enable'")
os.execute("su -c 'settings put global mobile_data 1'")
os.execute("su -c 'settings put global wifi_on 1'")
os.execute("su -c 'settings put global airplane_mode_on 0'")
os.execute("su -c 'settings put global data_roaming 0'")

-- 3. NONAKTIFKAN SEMUA APLIKASI (KECUALI SYSTEM UI)
progress("📱 Membunuh SEMUA aplikasi...")
local apps_to_disable = {
    -- Google & Play Services (MATIKAN SEMUA)
    "com.google.android.gms", "com.google.android.gsf", "com.google.android.gsf.login",
    "com.google.android.feedback", "com.google.android.partnersetup", 
    "com.google.android.onetimeinitializer", "com.google.android.configupdater",
    "com.google.android.ext.services", "com.google.android.ext.shared",
    "com.android.vending", "com.google.android.apps.wellbeing", 
    "com.google.android.apps.messaging", "com.google.android.apps.maps",
    "com.google.android.apps.photos", "com.google.android.apps.docs",
    "com.google.android.apps.tachyon", -- Google Duo
    "com.google.android.youtube", "com.google.android.music", "com.google.android.videos",
    
    -- Browser & Download
    "com.android.chrome", "com.android.browser", "com.android.htmlviewer",
    "com.android.documentsui", "com.android.downloads", "com.android.downloads.ui",
    "com.android.providers.downloads", "com.android.providers.media",
    
    -- Aplikasi Bawaan Android (SEMUA)
    "com.android.dialer", "com.android.mms", "com.android.contacts", "com.android.calendar",
    "com.android.email", "com.android.exchange", "com.android.gallery3d", "com.android.camera2",
    "com.android.music", "com.android.videoeditor", "com.android.deskclock", "com.android.calculator2",
    "com.android.soundrecorder", "com.android.stk", "com.android.wallpaper.livepicker",
    "com.android.wallpaper", "com.android.wallpapercropper", "com.android.wallpaperbackup",
    "com.android.launcher3", "com.android.quicksearchbox", "com.android.inputmethod.latin",
    "com.android.printspooler", "com.android.sharedstoragebackup", "com.android.wallpaperbackup",
    "com.android.keychain", "com.android.certinstaller", "com.android.backupconfirm",
    "com.android.pacprocessor", "com.android.proxyhandler", "com.android.statementservice",
    "com.android.managedprovisioning", "com.android.wallpaper.livepicker",
    
    -- Samsung Bloat (MATIKAN SEMUA)
    "com.samsung.android.bixby.wakeup", "com.samsung.android.bixby.vui", 
    "com.samsung.android.bixby.agent", "com.samsung.android.bixby.agent.dummy",
    "com.samsung.android.bixby.esim", "com.samsung.android.bixby.service",
    "com.samsung.android.app.spage", "com.samsung.android.app.routines",
    "com.samsung.android.app.notes", "com.samsung.android.app.memo",
    "com.samsung.android.app.contacts", "com.samsung.android.app.clock",
    "com.samsung.android.app.calendar", "com.samsung.android.app.gallery",
    "com.samsung.android.app.music", "com.samsung.android.app.video",
    "com.samsung.android.app.watchmanager", "com.samsung.android.app.shealth",
    "com.sec.android.app.shealth", "com.sec.android.app.billing",
    "com.sec.android.app.camera", "com.sec.android.app.clockpackage",
    "com.sec.android.app.contacts", "com.sec.android.app.downloadable",
    "com.sec.android.app.popupcalculator", "com.sec.android.app.quicktool",
    "com.sec.android.app.sbrowser", "com.sec.android.app.sbrowserprovider",
    "com.sec.android.app.shealth", "com.sec.android.app.simsetting",
    "com.sec.android.app.soundalive", "com.sec.android.app.talkback",
    "com.sec.android.app.voicenote", "com.sec.android.app.wlantest",
    "com.facebook.katana", "com.facebook.orca", "com.facebook.system",
    "com.facebook.appmanager", "com.microsoft.skydrive", "com.microsoft.office.word",
    "com.microsoft.office.excel", "com.microsoft.office.powerpoint", "com.microsoft.teams",
    
    -- Xiaomi Bloat (MATIKAN SEMUA)
    "com.miui.notes", "com.miui.gallery", "com.miui.player", "com.miui.video", 
    "com.miui.bugreport", "com.miui.analytics", "com.miui.compass", "com.miui.notes",
    "com.miui.screenrecorder", "com.miui.securitycenter", "com.miui.securityadd",
    "com.miui.cleanmaster", "com.miui.powerkeeper", "com.miui.weather2",
    "com.miui.weather", "com.miui.misound", "com.miui.virtualsim", "com.miui.hybrid",
    "com.miui.hybrid.accessory", "com.miui.yellowpage", "com.miui.backup",
    "com.miui.bugreport", "com.miui.calculator", "com.miui.calendar",
    "com.miui.cloudbackup", "com.miui.cloudservice", "com.miui.cloudservice.sys",
    "com.xiaomi.glgm", "com.xiaomi.midrop", "com.xiaomi.mipicks", "com.xiaomi.glgm",
    "com.xiaomi.discover", "com.xiaomi.micloud.sdk", "com.xiaomi.mipush",
    "com.xiaomi.mitransfer", "com.xiaomi.scanner", "com.xiaomi.shop",
    "com.xiaomi.video", "com.xiaomi.videoeditor", "com.xiaomi.wallet",
    
    -- Oppo/Vivo Bloat
    "com.oppo.music", "com.oppo.video", "com.oppo.gallery", "com.oppo.camera",
    "com.oppo.weather", "com.oppo.weather.service", "com.oppo.calculator",
    "com.oppo.calendar", "com.oppo.clock", "com.oppo.health", "com.oppo.safe",
    "com.oppo.soundrecorder", "com.oppo.themestore", "com.oppo.market",
    "com.oppo.browser", "com.oppo.store", "com.oppo.exservice",
    "com.vivo.weather", "com.vivo.weather.provider", "com.vivo.video",
    "com.vivo.music", "com.vivo.gallery", "com.vivo.camera", "com.vivo.browser",
    "com.vivo.store", "com.vivo.assistant", "com.vivo.easyshare",
    
    -- Aplikasi System Tambahan (MATIKAN)
    "com.android.cellbroadcastreceiver", "com.android.cellbroadcastreceiver.module",
    "com.android.emergency", "com.android.emergencyassist", "com.android.incallui",
    "com.android.server.telecom", "com.android.phone", "com.android.telephony",
    "com.android.providers.telephony", "com.android.providers.calendar",
    "com.android.providers.contacts", "com.android.providers.userdictionary",
    "com.android.providers.settings", "com.android.providers.applications",
    "com.android.providers.blockednumber", "com.android.providers.partnerbookmarks",
    "com.android.simappdialog", "com.android.smspush", "com.android.smsservice",
    "com.android.mms.service", "com.android.carrierconfig", "com.android.carrierdefaultapp",
    "com.android.dynsystem", "com.android.egg", "com.android.emergency",
    "com.android.externalstorage", "com.android.frameworkresource",
    "com.android.hotwordenrollment.okgoogle", "com.android.hotwordenrollment.xgoogle",
    "com.android.incident", "com.android.installd", "com.android.internal.display",
    "com.android.internal.systemui", "com.android.mtp", "com.android.networkstack",
    "com.android.networkstack.inprocess", "com.android.nfc", "com.android.nfc.thirdparty",
    "com.android.onetimeinitializer", "com.android.packageinstaller",
    "com.android.phone", "com.android.printservice", "com.android.providers.downloads.ui",
    "com.android.providers.media.module", "com.android.proxyhandler",
    "com.android.quicksearchbox", "com.android.se", "com.android.se.dmc",
    "com.android.settings.intelligence", "com.android.shell", "com.android.statementservice",
    "com.android.stk", "com.android.systemui.plugin", "com.android.terminal",
    "com.android.traceur", "com.android.uidemo", "com.android.vpndialogs",
    "com.android.wallpaper.livepicker", "com.android.webview", "com.android.wifi.resources"
}

-- Nonaktifkan SEMUA aplikasi
for i, app in ipairs(apps_to_disable) do
    os.execute("su -c 'pm disable-user --user 0 " .. app .. " 2>/dev/null'")
    os.execute("su -c 'pm hide " .. app .. " 2>/dev/null'")
    os.execute("su -c 'pm suspend " .. app .. " 2>/dev/null'")
end

-- 4. HENTIKAN SEMUA LAYANAN SISTEM (KECUALI UNTUK INTERNET & UI)
progress("⚙️ Membunuh SEMUA layanan sistem...")
local system_services = {
    -- MATIKAN SEMUA INI:
    "media", "nfc", "bluetooth", "telephony-ims", "lowpan", "statsd",
    "tcmiface", "cnss-daemon", "imsdatadaemon", "ims_rtp_daemon", "cnd",
    "gatekeeperd", "storaged", "installd", "dex2oat", "mdnsd", "mtpd", "racoon",
    "logd", "logcat", "dumpsys", "bugreport", "keystore", "fingerprintd",
    "audioserver", "cameraserver", "drmserver", "mediadrm", "mediaextractor",
    "mediametrics", "mediaprovider", "mediaresourcemanager", "mediaserver",
    "netutils", "nfc", "otads", "p2p_supplicant", "radio", "rnvt", "rpmbd",
    "secure_element", "servicemanager", "storaged", "surfaceflinger",
    "thermal-engine", "thermald", "time_daemon", "tombstoned", "ueventd",
    "vold", "watchdogd", "wificond", "wpa_supplicant",
    
    -- Layanan telepon (MATIKAN)
    "ril-daemon", "qcrild", "qcrildmsim", "rild", "atfwd", "mtservice",
    "imsd", "imsqmidaemon", "qmi_motext_hook", "qms", "qseecomd", "qcneserver",
    "qmuxd", "rmt_storage", "irsc_util", "pd_mapper", "loc_launcher"
}

-- Jangan hentikan layanan penting untuk internet & UI:
local keep_services = {
    "netd", "dhcpclient", "zygote", "system_server"
}

for i, service in ipairs(system_services) do
    -- Cek apakah service perlu dipertahankan
    local keep = false
    for _, keep_service in ipairs(keep_services) do
        if service == keep_service then
            keep = true
            break
        end
    end
    
    if not keep then
        os.execute("su -c 'stop " .. service .. " 2>/dev/null'")
        os.execute("su -c 'killall -9 " .. service .. " 2>/dev/null'")
    end
end

-- 5. MATIKAN SEMUA SENSOR & HARDWARE TIDAK PENTING
progress("📳 Mematikan SEMUA sensor")
os.execute("su -c 'echo 0 > /sys/class/leds/button-backlight/device/device/off 2>/dev/null'")
os.execute("su -c 'echo 0 > /sys/class/vibrator/vibrator/power_on 2>/dev/null'")
os.execute("su -c 'echo 0 > /sys/devices/virtual/input/input1/enabled 2>/dev/null'")
os.execute("su -c 'echo 0 > /sys/class/leds/lcd-backlight/device/device/off 2>/dev/null'")

-- 6. HAPUS SEMUA CACHE & DATA
progress("🧹 Pembersihan NUKLIR")
os.execute("su -c 'rm -rf /data/dalvik-cache/* 2>/dev/null'")
os.execute("su -c 'rm -rf /cache/* 2>/dev/null'")
os.execute("su -c 'rm -rf /data/cache/* 2>/dev/null'")
os.execute("su -c 'rm -rf /data/resource-cache/* 2>/dev/null'")
os.execute("su -c 'rm -rf /data/system/package_cache/* 2>/dev/null'")
os.execute("su -c 'rm -rf /data/system/userbehavior.db 2>/dev/null'")
os.execute("su -c 'rm -rf /data/system/usagestats/* 2>/dev/null'")
os.execute("su -c 'rm -rf /data/system/battery-history*.bin 2>/dev/null'")
os.execute("su -c 'rm -rf /data/system/batterystats.bin 2>/dev/null'")
os.execute("su -c 'rm -rf /data/log/* 2>/dev/null'")
os.execute("su -c 'rm -rf /data/anr/* 2>/dev/null'")
os.execute("su -c 'rm -rf /data/tombstones/* 2>/dev/null'")
os.execute("su -c 'rm -rf /data/system/dropbox/* 2>/dev/null'")

-- 7. MATIKAN SEMUA SYNCHRONIZATION
progress("🌐 Mematikan sync & background data")
os.execute("su -c 'settings put global master_sync_enabled 0'")
os.execute("su -c 'settings put global auto_time 0'")
os.execute("su -c 'settings put global auto_time_zone 0'")
os.execute("su -c 'settings put global wifi_scan_always_enabled 0'")
os.execute("su -c 'settings put global mobile_data_always_on 1'") -- Internet tetap aktif
os.execute("su -c 'settings put global network_recommendations_enabled 0'")
os.execute("su -c 'settings put global ble_scan_always_enabled 0'")

-- 8. OPTIMALKAN PERFORMANCE
progress("⚡ Mode performa MAXIMUM")
os.execute("su -c 'settings put global background_process_limit 0'")
os.execute("su -c 'settings put global app_standby_enabled 0'")
os.execute("su -c 'settings put global adaptive_battery_management_enabled 0'")
os.execute("su -c 'settings put global window_animation_scale 0'")
os.execute("su -c 'settings put global transition_animation_scale 0'")
os.execute("su -c 'settings put global animator_duration_scale 0'")

-- 9. OVERCLOCK CPU MAXIMUM
progress("⚡ Turbo Mode MAXIMUM")
os.execute("su -c 'echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null'")
for i = 0,7 do
    os.execute("su -c 'echo 1 > /sys/devices/system/cpu/cpu" .. i .. "/online 2>/dev/null'")
end

-- 10. BERSIHKAN RAM AGGRESIF
progress("💣 Ledakkan RAM")
os.execute("su -c 'sync'")
os.execute("su -c 'echo 3 > /proc/sys/vm/drop_caches 2>/dev/null'")
os.execute("su -c 'echo 1 > /proc/sys/vm/compact_memory 2>/dev/null'")
os.execute("su -c 'echo 100 > /proc/sys/vm/vfs_cache_pressure 2>/dev/null'")
os.execute("su -c 'am kill-all 2>/dev/null'")
os.execute("su -c 'am force-stop all 2>/dev/null'")

-- 11. PASTIKAN SYSTEM UI TETAP BERJALAN
progress("🎯 Memastikan System UI aktif")
os.execute("su -c 'am start-service com.android.systemui/.SystemUIService 2>/dev/null'")
os.execute("su -c 'pm enable com.android.systemui 2>/dev/null'")

-- 12. PASTIKAN INTERNET TETAP AKTIF
progress("📡 Memastikan internet aktif")
os.execute("su -c 'svc wifi enable'")
os.execute("su -c 'svc data enable'")
os.execute("su -c 'ping -c 2 8.8.8.8 > /dev/null 2>&1 && echo \"✅ Internet: AKTIF\" || echo \"⚠️  Internet: GAGAL\"'")

-- 13. TAMPILKAN HASIL
print("\n"..string.rep("💀", 30))
print("🔴 NUKLIR MODE SELESAI!")
print("✅ SYSTEM UI: HIDUP (Anda masih bisa kontrol)")
print("✅ INTERNET: HIDUP (Browsing/Download lancar)")
print("❌ SEMUA APLIKASI: MATI")
print("❌ SEMUA LAYANAN: MATI (kecuali internet & UI)")
print("❌ SEMUA SENSOR: MATI")
print("⚡ CPU: OVERCLOCK MAX")
print("💾 RAM: BERSIH MAX")
print("\n⚠️  Untuk kembali normal: REBOOT HP!")
print(string.rep("💀", 30))

-- Tes interaksi
print("\n📱 Coba sentuh layar - System UI harusnya responsif!")
print("🌐 Coba buka browser - Internet harusnya jalan!")

end

-- ENABLE CHROME & PLAY STORE
function enable_google()

progress("Mengaktifkan Play Store")
os.execute("su -c 'pm enable com.android.vending'")

progress("Mengaktifkan Chrome")
os.execute("su -c 'pm enable com.android.chrome'")

progress("Mengaktifkan Google Services")
os.execute("su -c 'pm enable com.google.android.gms'")

progress("Mengaktifkan Google Sync")
os.execute("su -c 'settings put global master_sync_enabled 1'")

progress("Mengaktifkan Background Process")
os.execute("su -c 'settings delete global background_process_limit'")

print(green.."✓ Chrome dan Play Store aktif kembali"..reset)

os.execute("sleep 2")

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
print("7 Ultra Debloat Mode (Extreme) (Recommend)")
print("8 Enable Chrome & Play Store")
print("9 Extreme Disable (System disabled) (Not Recommend, Bisa Bikin Tidak Bisa Booting)")
print("0 Keluar")

io.write("\nPilih menu: ")
local menu=io.read()
           
-- AUTO SETUP SYSTEM
if menu=="1" then

progress("Reset DPI")
os.execute("su -c '/system/bin/wm density reset'")

os.execute("sleep 1")

progress("Apply DPI 220")
os.execute("su -c '/system/bin/wm density 220'")

os.execute("sleep 1")

progress("Enable Developer Mode")
os.execute("su -c 'settings put global development_settings_enabled 1'")

progress("Disable Animations")
os.execute("su -c 'settings put global window_animation_scale 0'")
os.execute("su -c 'settings put global transition_animation_scale 0'")
os.execute("su -c 'settings put global animator_duration_scale 0'")

progress("Enable Freeform Mode")
os.execute("su -c 'settings put global enable_freeform_support 1'")
os.execute("su -c 'settings put global force_resizable_activities 1'")

progress("Pointer Speed Boost")
os.execute("su -c 'settings put system pointer_speed 7'")

progress("Disable Wifi Scan")
os.execute("su -c 'settings put global wifi_scan_always_enabled 0'")

progress("Enable GPU Rendering")
os.execute("su -c 'setprop debug.hwui.renderer opengl'")
os.execute("su -c 'setprop debug.egl.hw 1'")

progress("Performance Tuning")
os.execute("su -c 'setprop debug.performance.tuning 1'")
os.execute("su -c 'setprop video.accelerate.hw 1'")
os.execute("su -c 'setprop debug.sf.hw 1'")
os.execute("su -c 'setprop debug.composition.type gpu'")

progress("FPS Boost")
os.execute("su -c 'setprop debug.hwui.fps_divisor 1'")

progress("Touch Boost")
os.execute("su -c 'setprop debug.touch_boost 1'")

progress("Network Boost")
os.execute("su -c 'setprop net.tcp.buffersize.default 4096,87380,110208,4096,16384,110208'")
os.execute("su -c 'setprop net.tcp.buffersize.wifi 4096,87380,110208,4096,16384,110208'")

progress("RAM Optimization")
os.execute("su -c 'echo 3 > /proc/sys/vm/drop_caches'")

progress("Clean System Cache")
os.execute("su -c 'rm -rf /data/cache/*'")

progress("Kill Background Apps")
os.execute("su -c 'am kill-all'")

progress("Restart SystemUI")
os.execute("su -c 'pkill com.android.systemui'")

print(green.."✓ AUTO SETUP SYSTEM SELESAI!"..reset)

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

elseif menu=="7" then
ultra_debloat()

elseif menu=="8" then
enable_google()

elseif menu=="9" then
extreme_disable()

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
