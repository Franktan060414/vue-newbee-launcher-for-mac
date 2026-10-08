#!/bin/zsh

# 项目位置
PROJECT_DIR=""

# 兼容通过 Homebrew 或 nvm 安装的 Node.js。
export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"
if ! command -v npm >/dev/null 2>&1; then
  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
fi

fail() {
  print -r -- ""
  print -r -- "$1"
  read -r "reply?按回车结束…"
  exit 1
}

[[ -d "$PROJECT_DIR" ]] || fail "项目目录不存在：$PROJECT_DIR。请修改脚本中的 PROJECT_DIR。"
[[ -f "$PROJECT_DIR/package.json" ]] || fail "项目目录中没有 package.json，请检查脚本中的 PROJECT_DIR。"
command -v npm >/dev/null 2>&1 || fail "未找到 npm。请先安装 Node.js，并确认在普通终端中可以运行 npm。"
command -v node >/dev/null 2>&1 || fail "未找到 Node.js。请确认在普通终端中可以运行 node。"

cd -- "$PROJECT_DIR" || fail "无法进入项目目录：$PROJECT_DIR"
node -e 'const p = require("./package.json"); process.exit(p.scripts && p.scripts.dev ? 0 : 1)' || fail "package.json 中没有有效的 scripts.dev，或文件格式不正确。请确认这个项目使用 npm run dev 启动。"

print -r -- "启动 Vue 项目：$PROJECT_DIR"
print -r -- "按 Control+C 停止服务。"
print -r -- ""
npm run dev
RESULT=$?
if (( RESULT != 0 && RESULT != 130 )); then
  fail "启动失败（退出码 $RESULT）。请查看上方错误信息。"
fi
exit "$RESULT"
