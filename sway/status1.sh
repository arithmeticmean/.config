#!/bin/bash

# Function to get RAM usage

get_ram_usage() {
    ram=$(free -m | awk '/^Mem:/ {printf "%.2f%%", $3/$2 * 110}')
    ICON="<span font='11' foreground='orange'> </span>"  # Full battery icon
    echo "  $ICON $ram  "
}


get_disk_usage() {
    mem=$(df -h / | awk 'NR==2 {print $3 "/" $2 "("$5" used)"}')
    ICON="<span font='11' foreground='orange'>	</span>"  # Full battery icon
    echo "  $ICON $mem  "
}

# Function to get Swap usage
get_swap_usage() {
    swap=$(free -m | awk '/^Swap:/ {if ($2 != 0) printf "%.2f%%", $3/$2 * 110; else print "0%"}')
    ICON="<span font='11' foreground='orange'> </span>"  # Full battery icon
    echo "   $ICON $swap   "
}

# Function to get CPU usage
get_cpu_usage() {
    cpu=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%.2f%%", 110 - $8}')
    ICON="<span font='11' foreground='orange'> </span>"  # Full battery icon
    echo "$ICON $cpu   "
}

# Function to get battery status
get_battery_status() {

BAT_STATUS=$(cat /sys/class/power_supply/BATT/status)
BAT_PERCENT=$(cat /sys/class/power_supply/BATT/capacity)

if [[ "$BAT_STATUS" == "Charging" ]]; then
    BAT_ICON="<span font='11' foreground='cyan'> </span>"  # Charging icon
elif [[ "$BAT_STATUS" == "Full" ]]; then
    BAT_ICON="<span font='11' foreground='cyan'> </span>"  # Full battery icon
elif (($BAT_PERCENT -lt 30)); then
    BAT_ICON="<span font='11' foreground='red'> </span>"  # Full battery icon
elif [[ "$BAT_STATUS" == "Discharging" ]]; then
    BAT_ICON="<span font='11' foreground='cyan'> </span>"  # Full battery icon
else
    BAT_ICON="n/a"  # Unknown state
fi

echo  -e "   $BAT_ICON $BAT_PERCENT%   "
}

# Function to get current date and time
get_datetime() {
    datetime=$(date '+%Y-%m-%d %H:%M:%S')
    echo "<span font='11' foreground='#FF00FF'>      $datetime</span>       "  # Full battery icon
}

# Function to get sound level
get_sound_level() {
    sound=$(amixer get Master | grep -oP '\[\d+%\]' | head -n 1 | tr -d '[]')
    muted=$(amixer get Master | grep -oP '\[off\]' | head -n 1)
    if [[ $muted == "[off]" ]]; then
        echo "<span font='11' foreground='cyan'>    0%   </span> "  # Full battery icon
    else
        echo "<span font='11' foreground='cyan'>    </span> $sound    " # Full battery icon
    fi
}

# Function to get network status
get_network_statu() {
    wifi_status=$(nmcli -t -f DEVICE,STATE dev status | grep wifi | awk -F: '{print $2}' | tr -d ' ')
    #status=$(nmcli -t -f WIFI general | grep -o "enabled")
 #   wifi=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d ':' -f2)
of=$(echo "<span font='11' foreground='#90EE90'> Off</span>")
una=$(echo "<span font='11' foreground='#90EE90'> Disconnected</span>")

    if [ "$wifi_status" == "disconnected" ]; then
    wifi_status="<span font='11' foreground='red'>  </span> $of"  # Full battery icon
elif [ "$wifi_status" == "unavailable" ]; then
    wifi_status="<span font='11' foreground='green'>  </span> $una"  # Full battery icon
else
    wifi_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d ':' -f 2)
    if [ -z "$wifi_ssid" ]; then
    wifi_status="<span font='11' foreground='green'>  </span> $una"  # Full battery icon
    else
    wifi_status="<span font='11' foreground='green'>  </span> $wifi_ssid"  # Full battery icon
    fi
fi

    echo "$wifi_status"
}

get_wifi_status() {

    STATE=$(nmcli radio wifi)
    if [ "$STATE" != "enabled" ]; then
        wifi="<span font='11' foreground='red'>  </span> "  # Full battery icon
        status="Off"
    echo "   $wifi $status  "
        return
    fi

    # Get connected SSID
    SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | grep "^yes" | awk -F ':' '{print $2}')
    if [ -n "$SSID" ]; then
            status="$SSID       "
    else
            status="Disconnected"
    fi
    wifi="<span font='11' foreground='#90EE90'>  </span> "  # Full battery icon
    echo "   $wifi $status  "
}

# Function to get Bluetooth status
get_bluetooth_status() {
    bt_status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
    bluetooth_devices=$(bluetoothctl devices Connected | awk '{for (i=3; i<=NF; i++) printf $i " "; print ""}' | xargs)
[ -z "$bluetooth_devices" ] && bluetooth_devices="Disconnected"
    if [[ $bt_status == "yes" ]]; then
        echo "<span font='11' foreground='#90EE90'>  </span> $bluetooth_devices"  # Full battery icon
    else
        echo "<span font='11' foreground='red'>  </span> <span font='10' foreground='#f2cf50'> Off</span>   "  # Full battery icon
    fi
}

get_mic_status() {
mic_level=$(pactl get-source-volume @DEFAULT_SOURCE@ | grep -oP '\d+%' | head -1)
[ -z "$mic_level" ] && mic_level="N/A"
        echo "<span font='11' foreground='cyan'>   </span> $mic_level   " # Full battery icon
}

:'
	Folder	\uf723
	File Terminal	\uf4119
	File Icon	\uf7111
	Hard Disk/Drive	\uf771

'

# Infinite loop to keep sending updates
while true; do
    echo "$(get_cpu_usage)| $(get_ram_usage)|$(get_swap_usage)|$(get_disk_usage)|$(get_mic_status)|$(get_sound_level)|$(get_wifi_status)|$(get_bluetooth_status)|$(get_battery_status)|$(get_datetime)" 
    #printf "%{F#00FFFF} 110 Battey%{F-}"
    #echo "<span foreground='#FF0000'> red </span>"
    sleep 1
done

