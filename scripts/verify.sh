#!/bin/zsh

set -eu

script_dir="${0:A:h}"
repo_dir="${script_dir:h}"

for script_path in \
  "${repo_dir}/src/ClaudeStyled" \
  "${repo_dir}/scripts/build.sh" \
  "${repo_dir}/scripts/install.sh" \
  "${repo_dir}/scripts/uninstall.sh" \
  "${repo_dir}/scripts/make-icon.sh" \
  "${repo_dir}/scripts/verify.sh"; do
  /bin/zsh -n "${script_path}"
done

/usr/bin/plutil -lint "${repo_dir}/src/Info.plist" >/dev/null
/usr/bin/python3 -m json.tool "${repo_dir}/src/extension/manifest.json" >/dev/null

/usr/bin/python3 - "${repo_dir}/src/extension/manifest.json" <<'PY'
import json
import pathlib
import sys

manifest = json.loads(pathlib.Path(sys.argv[1]).read_text())
assert manifest["manifest_version"] == 3
assert manifest.get("permissions", []) == []
assert "background" not in manifest
scripts = manifest.get("content_scripts", [])
assert len(scripts) == 1
assert scripts[0]["matches"] == ["https://claude.ai/*"]
assert scripts[0]["css"] == ["style.css"]
assert scripts[0]["js"] == ["weather.js"]
PY

if /usr/bin/grep -En 'fetch[[:space:]]*\(|XMLHttpRequest|WebSocket|sendBeacon' "${repo_dir}/src/extension/weather.js"; then
  /bin/echo "weather.js 中出现了网络 API，请人工审计。" >&2
  exit 1
fi

if /usr/bin/grep -ERn --exclude=verify.sh --exclude-dir=.git --exclude-dir=dist \
  '(/Users/|brookxy|dayuwuxian|com\.brookxy|gh[opusr]_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,}|BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY)' \
  "${repo_dir}"; then
  /bin/echo "发现个人路径、凭证形态或历史标识，请先脱敏。" >&2
  exit 1
fi

"${script_dir}/build.sh"

built_app="${repo_dir}/dist/Claude Styled.app"
/usr/bin/codesign --verify --deep --strict "${built_app}"
/usr/bin/plutil -lint "${built_app}/Contents/Info.plist" >/dev/null
/usr/bin/cmp "${repo_dir}/src/extension/style.css" "${built_app}/Contents/Resources/extension/style.css"
/usr/bin/cmp "${repo_dir}/src/extension/weather.js" "${built_app}/Contents/Resources/extension/weather.js"

/bin/echo "验证通过：语法、配置、隐私扫描、网络 API 检查、构建与签名。"
