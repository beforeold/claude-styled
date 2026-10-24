# Privacy

Claude Styled is designed to work locally.

- The extension declares no Chrome permissions.
- It runs only on `https://claude.ai/*` inside Claude Desktop.
- The current JavaScript creates decorative DOM elements for rain or snow.
- The current source contains no analytics, telemetry, `fetch`, XHR, WebSocket, or beacon calls.
- It does not read or upload conversation text in the current implementation.

Because a content script can technically access page DOM, review every change before installing a fork or update. `make verify` performs a narrow automated check, but it is not a substitute for source review.
