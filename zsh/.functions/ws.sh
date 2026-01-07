# windsend
# 1. 程序的固定工作目录（配置文件所在目录）
WS_BASE_DIR="/home/morethan/WindSend"

# 2. PID 文件路径
WS_PID_FILE="$WS_BASE_DIR/windsend.pid"

# 3. 可执行文件的完整路径
WS_EXEC_PATH="/usr/local/bin/windsend"

# 定义一个函数来管理 windsend 服务
ws() {
    # 检查基本目录是否存在
    if [ ! -d "$WS_BASE_DIR" ]; then
        echo "错误：windsend 基本目录 $WS_BASE_DIR 不存在。"
        return 1
    fi

    # 帮助信息输出函数
    _ws_help() {
        echo "用法: ws <start|stop|status|help>"
        echo ""
        echo "  start      启动 windsend (默认行为)"
        echo "  stop       停止 windsend"
        echo "  status     查看 windsend 状态"
        echo "  help       显示此帮助信息"
    }

    # 参数解析 —— 无参数时默认 start
    case "$1" in
        "" )
            set -- "start"
            ;;

        help|-h|--help )
            _ws_help
            return 0
            ;;
    esac

    case "$1" in
        start)
            # 检查服务是否已运行
            if [ -f "$WS_PID_FILE" ] && ps -p $(cat "$WS_PID_FILE") > /dev/null; then
                echo "windsend 已经在运行 (PID: $(cat "$WS_PID_FILE"))."
                return 0
            fi

            echo "正在启动 windsend..."

            # 切换到固定工作目录，然后执行 nohup
            (
                cd "$WS_BASE_DIR" || exit 1 # 切换目录，如果失败则退出子 Shell
                # 注意：这里我们使用 $WS_EXEC_PATH 来执行程序
                nohup "$WS_EXEC_PATH" > /dev/null 2>&1 &
                # 将 PID 写入文件
                echo $! > "$WS_PID_FILE"
            )
            
            # 检查启动结果
            sleep 1
            if [ -f "$WS_PID_FILE" ] && ps -p $(cat "$WS_PID_FILE") > /dev/null; then
                echo "windsend 已启动 (PID: $(cat "$WS_PID_FILE"))."
            else
                echo "windsend 启动失败，请检查 $WS_BASE_DIR 目录下的配置和权限。"
            fi
            ;;

        stop)
            # ... (这部分逻辑与之前保持一致，只检查和终止进程) ...
            if [ -f "$WS_PID_FILE" ]; then
                WS_PID=$(cat "$WS_PID_FILE")
                if ps -p $WS_PID > /dev/null; then
                    kill $WS_PID
                    echo "windsend (PID $WS_PID) 已发送终止信号."
                    sleep 1
                    rm -f "$WS_PID_FILE"
                else
                    echo "windsend 进程未找到，但 PID 文件存在。已删除文件。"
                    rm -f "$WS_PID_FILE"
                fi
            else
                echo "windsend PID 文件不存在，服务可能未运行."
            fi
            ;;

        status)
            # ... (这部分逻辑与之前保持一致) ...
            if [ -f "$WS_PID_FILE" ]; then
                WS_PID=$(cat "$WS_PID_FILE")
                if ps -p $WS_PID > /dev/null; then
                    echo "windsend 正在运行 (PID: $WS_PID). 工作目录: $WS_BASE_DIR"
                else
                    echo "windsend PID 文件存在 ($WS_PID)，但进程未找到。请使用 'ws stop' 清理。"
                fi
            else
                echo "windsend 未运行 (PID 文件不存在)."
            fi
            ;;

        *)
            echo "无效参数。用法: ws <start|stop|status>"
            return 1
            ;;
    esac
}
