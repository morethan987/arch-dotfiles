// 创建新映射示例（Ctrl-y）
// api.mapkey('<Ctrl-y>', 'Show me the money', function() {
//     api.Front.showPopup('a well-known phrase uttered by characters in the 1996 film Jerry Maguire (Escape to close).');
// });

// 默认映射替换示例
// api.map('gt', 'T');

// 默认注销映射示例
// api.unmap('<Ctrl-i>');

// 往下/往上滚动半页
api.map('<Alt-j>', 'd');
api.unmap('d');
api.map('<Alt-k>', 'e');
api.unmap('e');

// 跳到左侧/右侧标签页
api.map('<Alt-h>', 'E');
api.unmap('E');
api.map('<Alt-l>', 'R');
api.unmap('R');

// 关闭当前标签页
api.map(';q', 'x');
api.unmap('x');

// 打开新标签
api.map(';n', 'on');
api.unmap('on');

// 滚动到最下边
api.map('ge', 'G');
api.unmap('G');

// 跳到第一个/最后一个标签页
api.map('gH', 'g0');
api.unmap('g0');
api.map('gL', 'g$');
api.unmap('g$');

// 滚动到最右边/最左边
api.map('gh', '$');
api.unmap('$');
api.map('gl', '0');
api.unmap('0');

// follow links
api.map('F', 'af');
api.unmap('af');

// chose tabs
api.map('<Alt-o>', 'T');
api.unmap('T');

// forward and backward
api.unmap('<Ctrl-i>');
api.unmap('<Ctrl-o>');
api.map('<Ctrl-i>', 'D')
api.map('<Ctrl-o>', 'S')


// insert mode exit
api.imap('jj', '<Esc>');

// ==== 主题样式设置 ====

// 点击链接时的字母框 (hints)
// 普通 hint：深紫灰半透明底 + 亮青字，低噪不遮内容
api.Hints.style([
    "font-family: 'JetBrains Mono', Consolas, monospace !important",
    "font-size: 10px !important",
    "font-weight: bold",
    "line-height: 1 !important",
    "padding: 1px 4px !important",
    "border-radius: 3px !important",
    "border: 1px solid #6272a4 !important",
    "color: #8be9fd !important",
    "background: rgba(40, 42, 54, 0.92) !important",
    "box-shadow: 0 1px 4px rgba(0,0,0,0.5) !important",
    "opacity: 0.9 !important",
].join("; "));

// text hint（文本选择模式）：亮紫边框区分
api.Hints.style([
    "font-family: 'JetBrains Mono', Consolas, monospace !important",
    "font-size: 10px !important",
    "font-weight: bold",
    "line-height: 1 !important",
    "padding: 1px 4px !important",
    "border-radius: 3px !important",
    "border: 1px solid #bd93f9 !important",
    "color: #f8f8f2 !important",
    "background: rgba(68, 71, 90, 0.92) !important",
    "box-shadow: 0 1px 4px rgba(0,0,0,0.5) !important",
    "opacity: 0.9 !important",
].join("; "), "text");

// Visual Mode：marks 降低饱和度避免抢眼，cursor 保持醒目紫色
// fix: marks 从 #50fa7b 换成更柔和的 rgba 绿，减少大段选中时的视觉冲击
api.Visual.style('marks', 'background-color: rgba(80, 250, 123, 0.35) !important; color: #f8f8f2 !important;');
api.Visual.style('cursor', 'background-color: #bd93f9 !important; color: #282a36 !important;');

settings.theme = `
/* 全局等宽字体，确保所有 UI 元素排版一致 */
.sk_theme,
.sk_theme input,
#sk_omnibarSearchArea input,
#sk_omnibar,
#sk_status,
#sk_find,
#sk_keystroke,
#sk_richKeystroke,
#sk_banner,
kbd {
    font-family: "JetBrains Mono", Consolas, "Liberation Mono", Monaco, monospace !important;
    font-size: 10pt;
}

/* 主容器背景 */
.sk_theme {
    background: #282a36;
    color: #f8f8f2;
}
.sk_theme tbody {
    color: #f8f8f2;
}

/* 输入框 */
.sk_theme input {
    color: #ffb86c;
}
#sk_omnibarSearchArea {
    border-bottom: 1px solid #44475a;
}
#sk_omnibarSearchArea input {
    color: #ffb86c;
}

/* Omnibar 容器：圆角 + 投影，让浮层有"浮起来"的质感 */
/* fix: 原来没有 border-radius / box-shadow，浮层显得很平 */
#sk_omnibar {
    border-radius: 8px !important;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.6), 0 0 0 1px #44475a !important;
    overflow: hidden;
}

/* 按键卡片样式（kbd 徽章） */
kbd {
    background: #44475a;
    color: #f8f8f2;
    border: solid 1px #6272a4;
    border-bottom-color: #ff79c6;
    box-shadow: inset 0 -1px 0 #ff79c6;
    border-radius: 3px;
    padding: 1px 4px;
}
.sk_theme kbd .candidates {
    color: #50fa7b;
}

/* 按键提示浮窗：加 padding 避免内容贴边 */
/* fix: 原来没有 padding，内容紧贴边框 */
#sk_keystroke {
    background-color: #282a36;
    border: 1px solid #44475a;
    border-radius: 5px;
    padding: 6px 10px;
}

/* Omnibar 搜索结果列表 */
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #21222c;
}

/* 选中行：背景 + 左侧 accent 线，双重锚点 */
/* fix: 原来只改背景色，在深色主题里对比度有限 */
.sk_theme #sk_omnibarSearchResult ul li.focused {
    background: #383a59 !important;
    border-left: 3px solid #ff79c6 !important;
    padding-left: calc(0.5em - 3px) !important; /* 补偿 border 占用的宽度 */
}

/* 结果列表配色层级 */
.sk_theme .url {
    color: #6272a4; /* URL：注释级，最低优先 */
}
#sk_omnibarSearchResult li div.url {
    font-weight: normal;
}
.sk_theme .annotation {
    color: #bd93f9; /* 命令描述：亮紫，中等优先 */
}

/* fix: separator 与 url 原来同色，语义混淆；改为更暗的灰 */
.sk_theme .separator {
    color: #44475a;
}

/* 匹配字符高亮 */
.sk_theme .omnibar_highlight {
    color: #8be9fd !important;
}
.sk_theme .omnibar_folder {
    color: #ff79c6;
}

/* fix: timestamp 与 annotation 原来都是 #bd93f9，无法区分优先级 */
/* timestamp 是次要元信息，用更暗的紫灰 */
.sk_theme .omnibar_timestamp {
    color: #5a5f7a;
}
.sk_theme .omnibar_visitcount {
    color: #f1fa8c;
}

/* 页数提示和页码：强制字体 + 字号与全局一致 */
/* fix: .resultPage 会在 shadow DOM 里断继承链 */
.sk_theme .prompt,
.sk_theme .resultPage {
    font-family: "JetBrains Mono", Consolas, "Liberation Mono", Monaco, monospace !important;
    font-size: 10pt !important;
    color: #50fa7b;
}
.sk_theme .feature_name {
    color: #ff5555;
}

/* 状态栏：视觉隐藏但保留元素存在性                                        */
/*   不能用 display:none —— #sk_status 就是 statusBar 本体，             */
/*    内部会动态插入 <input> 承载 / 查找功能；display:none 后 input 无法    */
/*    获得焦点，导致 Esc 退出失效、页内搜索完全瘫痪。                        */
/* 方案：平时用 color:transparent 隐藏纯文字状态（NORMAL/Hints to click）， */
/*      有 input 时用 :has(input) 恢复完整样式                             */
#sk_status {
    position: fixed !important;
    top: 12px !important;
    right: 16px !important;
    bottom: auto !important;
    left: auto !important;
    width: fit-content;
    min-width: 0;
    max-width: 320px;
    padding: 2px 8px;
    background-color: transparent;
    border: 1px solid transparent;
    border-radius: 4px;
    color: transparent;
    font-family: "JetBrains Mono", Consolas, monospace !important;
    font-size: 10pt !important;
    z-index: 2147483647;
}

/* / 查找模式激活时（statusBar 内出现 input），恢复完整外观 */
#sk_status:has(input) {
    padding: 4px 10px;
    background-color: #282a36;
    border-color: #44475a;
    border-top: 2px solid #ff79c6;
    color: #50fa7b;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.4);
}

/* 查找输入框文字颜色 */
#sk_status input {
    color: #ffb86c;
}

/* 划词翻译气泡窗 */
/* fix: 加 padding 和字体声明，原来内容贴边且可能 fallback 系统字体 */
#sk_bubble {
    background-color: #282a36 !important;
    border: 1px solid #ff79c6 !important;
    border-radius: 6px;
    padding: 8px 12px !important;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5) !important;
    font-family: "JetBrains Mono", Consolas, monospace !important;
    font-size: 10pt !important;
}
#sk_bubble * {
    color: #f8f8f2 !important;
}
#sk_bubble .sk_bubble_content {
    overflow: auto;
}
#sk_bubble div.sk_arrow div:nth-of-type(1) {
    border-top-color: #ff79c6 !important;
    border-bottom-color: #ff79c6 !important;
}
#sk_bubble div.sk_arrow div:nth-of-type(2) {
    border-top-color: #282a36 !important;
    border-bottom-color: #282a36 !important;
}

/* 通知横幅 */
/* fix: 加 font-family 防止 fallback 到系统 serif */
#sk_banner {
    background: #282a36;
    border: 1px solid #44475a;
    border-bottom: 2px solid #ff79c6;
    color: #f8f8f2;
    font-family: "JetBrains Mono", Consolas, monospace !important;
    font-size: 10pt !important;
    padding: 4px 10px;
}

/* 框架选中边框高亮 */
#sk_frame {
    border: 3px solid #ff79c6 !important;
    box-shadow: 0 0 10px rgba(255, 121, 198, 0.4);
}
`;
