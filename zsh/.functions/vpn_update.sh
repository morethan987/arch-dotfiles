# update vpn config
vpn_update() {
    local CONFIG_URL="https://pu7wd.no-mad-world.club/link/nKGHOzf6LylfyQ6O?clash=3"
    local CONFIG_FILE="/etc/mihomo/config.yaml"
    local MORE_FILE="$HOME/.config/vpn/more_config.yaml"
    local TEMP_FILE="/tmp/vpn_config_temp.yaml"
    local BACKUP_FILE="/tmp/vpn_config_backup.yaml"
    
    # 检查 yq 是否可用
    if ! command -v yq &> /dev/null; then
        echo "错误：找不到 yq 命令，请先安装: sudo pacman -S go-yq"
        return 1
    fi
    
    echo "[1] 下载最新 config.yaml ..."
    if ! sudo curl -L -o "$CONFIG_FILE" "$CONFIG_URL"; then
        echo "✗ 下载失败"
        return 1
    fi
    
    echo "[2] 检查 more_config.yaml 是否存在..."
    if [[ ! -f "$MORE_FILE" ]]; then
        echo "   - more_config.yaml 不存在，跳过合并"
    else
        # 备份和复制
        if ! sudo cp "$CONFIG_FILE" "$BACKUP_FILE"; then
            echo "✗ 创建备份文件失败"
            return 1
        fi
        if ! sudo cp "$CONFIG_FILE" "$TEMP_FILE"; then
            echo "✗ 创建临时文件失败"
            return 1
        fi
        
        echo "[3] 获取自定义配置中的所有顶级字段..."
        # 获取 more_config.yaml 中的所有顶级键
        local all_keys=$(yq eval 'keys | .[]' "$MORE_FILE" 2>&1)
        if [[ $? -ne 0 ]]; then
            echo "✗ 读取自定义配置字段失败: $all_keys"
            return 1
        fi
        
        if [[ -z "$all_keys" ]]; then
            echo "   - 自定义配置为空，跳过合并"
        else
            echo "   找到字段: $(echo $all_keys | tr '\n' ' ')"
            
            echo "[4] 合并配置..."
            while IFS= read -r field; do
                [[ -z "$field" ]] && continue
                echo "   处理字段：$field"
                
                # 检查主配置中是否存在该字段
                local has_in_config=$(sudo yq eval "has(\"$field\")" "$TEMP_FILE" 2>&1)
                if [[ $? -ne 0 ]]; then
                    echo "   ✗ 检查字段失败: $has_in_config"
                    continue
                fi
                
                # 判断字段值的类型
                local field_type=$(yq eval ".$field | type" "$MORE_FILE" 2>&1)
                if [[ $? -ne 0 ]]; then
                    echo "   ✗ 获取字段类型失败: $field_type"
                    continue
                fi
                
                if [[ "$has_in_config" == "true" ]]; then
                    # 字段已存在
                    if [[ "$field_type" == "!!seq" ]]; then
                        # 数组类型：将 more_config 的内容追加到开头
                        echo "   - 数组字段，追加到开头"
                        local merge_result=$(sudo yq eval-all \
                            "select(fileIndex==0).$field = select(fileIndex==1).$field + select(fileIndex==0).$field | select(fileIndex==0)" \
                            "$TEMP_FILE" "$MORE_FILE" -i 2>&1)
                        if [[ $? -ne 0 ]]; then
                            echo "   ✗ 合并数组失败: $merge_result"
                            continue
                        fi
                    elif [[ "$field_type" == "!!map" ]]; then
                        # 对象类型：递归合并（more_config 的值优先）
                        echo "   - 对象字段，递归合并"
                        local merge_result=$(sudo yq eval-all \
                            "select(fileIndex==0).$field = select(fileIndex==1).$field * select(fileIndex==0).$field | select(fileIndex==0)" \
                            "$TEMP_FILE" "$MORE_FILE" -i 2>&1)
                        if [[ $? -ne 0 ]]; then
                            echo "   ✗ 合并对象失败: $merge_result"
                            continue
                        fi
                    else
                        # 标量类型：直接覆盖
                        echo "   - 标量字段，覆盖"
                        local merge_result=$(sudo yq eval-all \
                            "select(fileIndex==0).$field = select(fileIndex==1).$field | select(fileIndex==0)" \
                            "$TEMP_FILE" "$MORE_FILE" -i 2>&1)
                        if [[ $? -ne 0 ]]; then
                            echo "   ✗ 覆盖字段失败: $merge_result"
                            continue
                        fi
                    fi
                    echo "   ✓ 已处理"
                else
                    # 字段不存在：添加到文件开头
                    echo "   - 新字段，添加到开头"
                    
                    # 提取字段内容到临时文件
                    local field_file="/tmp/vpn_field_${field}.yaml"
                    yq eval "{\"$field\": .$field}" "$MORE_FILE" > "$field_file" 2>&1
                    if [[ $? -ne 0 ]]; then
                        echo "   ✗ 提取字段失败"
                        rm -f "$field_file"
                        continue
                    fi
                    
                    # 合并：新字段 + 原配置
                    local merge_result=$(sudo yq eval-all '. as $item ireduce ({}; . * $item)' \
                        "$field_file" "$TEMP_FILE" > /tmp/vpn_merged.yaml 2>&1)
                    if [[ $? -ne 0 ]]; then
                        echo "   ✗ 添加新字段失败: $merge_result"
                        rm -f "$field_file"
                        continue
                    fi
                    
                    sudo mv /tmp/vpn_merged.yaml "$TEMP_FILE"
                    rm -f "$field_file"
                    echo "   ✓ 已添加"
                fi
            done <<< "$all_keys"
        fi
        
        # 验证生成的 YAML 是否有效
        echo "[5] 验证合并后的配置文件..."
        local validate_result=$(sudo yq eval '.' "$TEMP_FILE" > /dev/null 2>&1)
        if [[ $? -ne 0 ]]; then
            echo "✗ 合并后的配置文件无效，恢复备份"
            sudo mv "$BACKUP_FILE" "$CONFIG_FILE"
            return 1
        fi
        
        # 将处理后的文件替换原文件
        if ! sudo mv "$TEMP_FILE" "$CONFIG_FILE"; then
            echo "✗ 替换配置文件失败，恢复备份"
            sudo mv "$BACKUP_FILE" "$CONFIG_FILE"
            return 1
        fi
        
        echo "   ✓ 配置文件合并成功"
    fi
    
    echo "[6] 重启 mihomo.service ..."
    if ! sudo systemctl restart mihomo.service; then
        echo "✗ 重启服务失败，恢复备份配置"
        sudo mv "$BACKUP_FILE" "$CONFIG_FILE"
        sudo systemctl restart mihomo.service
        return 1
    fi
    
    echo "[7] 等待 mihomo.service active ..."
    sleep 1
    local max_wait=10
    local waited=0
    while true; do
        local STATUS=$(systemctl is-active mihomo.service)
        if [[ "$STATUS" == "active" ]]; then
            echo "✓ 服务已启动成功！"
            sudo rm "$BACKUP_FILE"
            break
        fi
        
        if [[ $waited -ge $max_wait ]]; then
            echo "✗ 服务启动超时，恢复备份配置"
            sudo mv "$BACKUP_FILE" "$CONFIG_FILE"
            sudo systemctl restart mihomo.service
            sudo journalctl -u mihomo.service -n 20 --no-pager
            return 1
        fi
        
        echo "状态：$STATUS，等待中...（${waited}s/${max_wait}s）"
        sleep 1
        ((waited++))
    done
    
    echo "[✔] VPN配置更新完成！"
}
