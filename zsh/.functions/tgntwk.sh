# togle network
tgntwk() {
    wifi_state=$(nmcli radio wifi)
    wifi_dev=$(nmcli device status | awk '/wifi/ && /connected/ {print $1}' | head -n1)
    eth_state=$(nmcli device status | awk '/ethernet/ {print $3}' | head -n1)
    eth_dev=$(nmcli device status | awk '/ethernet/ {print $1}' | head -n1)

    # 当 Wi-Fi 和以太网都启用时，优先关闭以太网
    if [[ "$wifi_state" == "enabled" && "$eth_state" == "已连接" ]]; then
        echo "󰈀 Both Wi-Fi and Ethernet are active — turning off Ethernet..."
        nmcli device disconnect "$eth_dev" >/dev/null 2>&1

    elif [[ "$wifi_state" == "enabled" ]]; then
        echo "󰈀 Switching to Ethernet..."
        nmcli radio wifi off
        nmcli device connect "$eth_dev" >/dev/null 2>&1

    else
        echo "󰤢 Switching to Wi-Fi..."
        nmcli device disconnect "$eth_dev" >/dev/null 2>&1
        nmcli radio wifi on
    fi
}
