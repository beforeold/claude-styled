#!/bin/zsh

set -eu

install_dir="${CLAUDE_STYLED_INSTALL_DIR:-${HOME}/Applications}"
target_app="${install_dir}/Claude Styled.app"
profile_extension_dir="${HOME}/Library/Application Support/Claude/extensions/fmkadmapgofadopljbjfkapdkoienihi"
owner_marker="${profile_extension_dir}/.claude-styled-owned"
owner_signature="claude-styled:app.claudestyled.launcher:v1"
trash_dir="${HOME}/.Trash"

if [[ -e "${target_app}" ]]; then
  timestamp=$(/bin/date '+%Y%m%d-%H%M%S')
  /bin/mkdir -p "${trash_dir}"
  /bin/mv "${target_app}" "${trash_dir}/Claude Styled-${timestamp}.app"
  /bin/echo "启动器已移到废纸篓。"
else
  /bin/echo "未找到已安装的 Claude Styled.app。"
fi

recorded_owner=$(/bin/cat "${owner_marker}" 2>/dev/null || true)
if [[ "${recorded_owner}" == "${owner_signature}" ]]; then
  /bin/rm -rf "${profile_extension_dir}"
  /bin/echo "已移除 Claude Styled 创建的本地扩展目录。"
else
  /bin/echo "未移除 Claude 扩展目录：没有有效的 Claude Styled 所有权标记。"
fi

/bin/echo "官方 /Applications/Claude.app 未被修改。"
