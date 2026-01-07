# update vpn config
vpn_update() {
    set -e

    local CONFIG_URL="https://pu7wd.no-mad-world.club/link/nKGHOzf6LylfyQ6O?clash=3"
    local CONFIG_FILE="/etc/mihomo/config.yaml"
    local MORE_FILE="$HOME/.config/vpn/more_config.yaml"

    # 要合并的字段（按需修改）
    local FIELDS=("proxies" "proxy-groups" "rules")

    echo "[1] 下载最新 config.yaml ..."
    sudo curl -L -o "$CONFIG_FILE" "$CONFIG_URL"

    echo "[2] 插入 more_config.yaml 中的增强字段..."

    for field in $FIELDS; do
        echo " 处理字段：$field"

        # 提取 more_config 中该字段的内容
        awk -v key="$field" '
            $1 == key ":" {flag=1; next}
            flag && /^[^ ]/ {flag=0}
            flag {print}
        ' "$MORE_FILE" > /tmp/vpn_more_block.txt

        if [[ ! -s /tmp/vpn_more_block.txt ]]; then
            echo "   - 跳过（more_config 中无该字段）"
            continue
        fi

        # 插入内容
        sudo sed -i "/^$field:/r /tmp/vpn_more_block.txt" "$CONFIG_FILE"
    done

    echo "[3] 重启 mihomo.service ..."
    sudo systemctl restart mihomo.service

    echo "[4] 等待 mihomo.service active ..."
    sleep 1

    while true; do
        local STATUS=$(systemctl is-active mihomo.service)
        if [[ "$STATUS" == "active" ]]; then
            echo "✓ 服务已启动成功！"
            break
        fi
        echo "状态：$STATUS，等待 1 秒..."
        sleep 1
    done

    echo "[✔] VPN配置更新完成！"
}
