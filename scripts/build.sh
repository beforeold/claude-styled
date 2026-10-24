#!/bin/zsh

set -eu

script_dir="${0:A:h}"
repo_dir="${script_dir:h}"
dist_dir="${CLAUDE_STYLED_DIST_DIR:-${repo_dir}/dist}"
app_path="${dist_dir}/Claude Styled.app"
contents_dir="${app_path}/Contents"

if [[ "${dist_dir}" == "/" || -z "${dist_dir}" ]]; then
  /bin/echo "拒绝使用不安全的构建目录：${dist_dir}" >&2
  exit 1
fi

/bin/rm -rf "${app_path}"
/bin/mkdir -p "${contents_dir}/MacOS" "${contents_dir}/Resources/extension"
/bin/cp "${repo_dir}/src/Info.plist" "${contents_dir}/Info.plist"
/bin/cp "${repo_dir}/src/ClaudeStyled" "${contents_dir}/MacOS/ClaudeStyled"
/bin/cp "${repo_dir}/src/extension/manifest.json" "${contents_dir}/Resources/extension/manifest.json"
/bin/cp "${repo_dir}/src/extension/style.css" "${contents_dir}/Resources/extension/style.css"
/bin/cp "${repo_dir}/src/extension/weather.js" "${contents_dir}/Resources/extension/weather.js"
/bin/cp "${repo_dir}/assets/ClaudeStyled.icns" "${contents_dir}/Resources/ClaudeStyled.icns"
/bin/chmod 755 "${contents_dir}/MacOS/ClaudeStyled"

/usr/bin/codesign --force --deep --sign - "${app_path}"
/usr/bin/codesign --verify --deep --strict "${app_path}"

/bin/echo "已构建：${app_path}"
