#!/bin/zsh

set -eu

script_dir="${0:A:h}"
repo_dir="${script_dir:h}"
install_dir="${CLAUDE_STYLED_INSTALL_DIR:-${HOME}/Applications}"
target_app="${install_dir}/Claude Styled.app"
built_app="${repo_dir}/dist/Claude Styled.app"

"${script_dir}/build.sh"
/bin/mkdir -p "${install_dir}"

if [[ -e "${target_app}" ]]; then
  timestamp=$(/bin/date '+%Y%m%d-%H%M%S')
  backup_app="${install_dir}/Claude Styled.backup-${timestamp}.app"
  /bin/mv "${target_app}" "${backup_app}"
  /bin/echo "旧版本已备份到：${backup_app}"
fi

/usr/bin/ditto "${built_app}" "${target_app}"
/usr/bin/codesign --verify --deep --strict "${target_app}"

/bin/echo "已安装：${target_app}"
/bin/echo "运行：open \"${target_app}\""
