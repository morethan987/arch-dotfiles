proxy_off() {
    unset http_proxy
    unset https_proxy
    unset all_proxy
    unset ALL_PROXY
    unset no_proxy
    echo "终端代理已关闭"
}
