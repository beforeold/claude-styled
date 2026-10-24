#!/bin/zsh

set -eu

script_dir="${0:A:h}"
repo_dir="${script_dir:h}"
svg_path="${repo_dir}/assets/icon.svg"
iconset_dir="${repo_dir}/assets/ClaudeStyled.iconset"
output_path="${repo_dir}/assets/ClaudeStyled.icns"

if ! command -v rsvg-convert >/dev/null 2>&1; then
  /bin/echo "需要 rsvg-convert。可用 Homebrew 安装：brew install librsvg" >&2
  exit 1
fi

/bin/rm -rf "${iconset_dir}"
/bin/mkdir -p "${iconset_dir}"

for size in 16 32 128 256 512; do
  rsvg-convert -w "${size}" -h "${size}" "${svg_path}" -o "${iconset_dir}/icon_${size}x${size}.png"
  double_size=$((size * 2))
  rsvg-convert -w "${double_size}" -h "${double_size}" "${svg_path}" -o "${iconset_dir}/icon_${size}x${size}@2x.png"
done

/usr/bin/iconutil -c icns "${iconset_dir}" -o "${output_path}"
/bin/rm -rf "${iconset_dir}"
/bin/echo "已生成：${output_path}"
