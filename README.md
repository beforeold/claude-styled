<p align="center">
  <img src="assets/icon.svg" width="112" alt="Original Claude Styled project icon">
</p>

# Claude Styled

A local visual theme and launcher for Claude Desktop on macOS. It gives long-form responses more breathing room, uses a true-black dark canvas, narrows the message column, and adds subtle rain or snow ambience.

> **Unofficial project.** Claude Styled is not affiliated with, authorized by, or endorsed by Anthropic. Claude is a trademark of its respective owner.

![Sanitized reconstruction comparing the default Claude layout with Claude Styled](assets/typography-comparison.svg)

## What it changes

- Uses a 16 px system font with an approximately 26 px line height for body text.
- Limits the message column to a maximum width of 640 px.
- Uses a true-black background for the dark content canvas.
- Refines spacing for headings, lists, blockquotes, and inline code.
- Hides repository and pull request controls.
- Randomly displays subtle rain or snow ambience on each load.
- Automatically disables animation when macOS Reduce Motion is enabled.

![Sanitized reconstruction of the Claude Styled rain and snow ambience](assets/ambient-weather.svg)

## Installation

Requirements: macOS 13 or later, with the official Claude Desktop app installed at `/Applications/Claude.app`.

```bash
git clone https://github.com/beforeold/claude-styled.git
cd claude-styled
make install
open "$HOME/Applications/Claude Styled.app"
```

This project distributes source code only. `make install` assembles and ad-hoc signs the launcher on your Mac. It does not ask you to disable Gatekeeper and does not replace the official Claude app.

After installation, open Claude through `~/Applications/Claude Styled.app`. Launching the official Claude app directly will not load these styles.

## How it works

![Simplified overview of how Claude Styled works](assets/how-it-works.svg)

The launcher:

1. Confirms that the official Claude Desktop app is installed.
2. Updates the local extension files only when its ownership marker is valid.
3. Loads those files through an internal startup path in the current version of Claude Desktop.
4. Opens the official app that remains installed at `/Applications/Claude.app`.

Claude Styled does not modify the official application bundle. It places `manifest.json`, `style.css`, and `weather.js` in the current user's Claude application-data directory.

## Privacy and security

- The extension declares no browser permissions, background scripts, or external resources.
- The current `weather.js` only creates decorative DOM elements; it does not read or upload conversation content.
- The current source contains no telemetry and makes no `fetch`, XHR, WebSocket, or Beacon requests.
- `make verify` checks script and configuration syntax, common credential patterns, network APIs, build output, and signature integrity.
- The source is public and auditable. Review changes before installing an update.

The content script technically runs inside the signed-in `https://claude.ai/*` page. “The current implementation does not read content” should not be interpreted as absolute browser-level isolation. See [PRIVACY.md](PRIVACY.md) and [SECURITY.md](SECURITY.md).

## Compatibility and account risk

Claude Styled relies on an undocumented startup path in the current version of Claude Desktop and may stop working after an Anthropic update. This is not an extension mechanism supported by Anthropic. The current code does not perform account actions, but this project cannot assess future compatibility or terms-of-service risk on your behalf, and it cannot guarantee zero account risk.

## Uninstallation

Quit Claude completely, then run:

```bash
cd claude-styled
make uninstall
```

The launcher is moved to the Trash. Its local extension directory is removed only when the ownership marker matches exactly. The official `/Applications/Claude.app` is neither removed nor modified.

## Customization and development

- Typography and colors: `src/extension/style.css`
- Rain and snow ambience: `src/extension/weather.js`
- Launch behavior: `src/ClaudeStyled`
- Original icon source: `assets/icon.svg`

```bash
make verify  # Run all checks and build the app
make build   # Build dist/Claude Styled.app
make icon    # Regenerate the ICNS after editing icon.svg; requires librsvg
```

Read [CONTRIBUTING.md](CONTRIBUTING.md) before contributing.

## License

[MIT](LICENSE)
