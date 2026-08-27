# Termux Clarity Magisk Module

Termux Clarity is a small, reversible Magisk module for Termux readability and
consistent shell presentation. It is intentionally not a “RAM booster”: there
is no resident service, polling loop, CPU governor change, network tweak, or
notification-blocking optimization.

## What it changes

- Uses a dark, high-contrast palette with a slightly warm foreground.
- Adds modest terminal margins and keeps scrollback at 2,000 rows so the
  terminal stays responsive.
- Uses a bar cursor with a slower blink and a compact two-row computer-style
  key layout with `SHIFT`, navigation, editing, Enter, and keyboard buttons.
- Installs Android's `DroidSansMono.ttf` only when no custom Termux font exists.
- Disables the legacy `TermuxRootMods` global shell wrapper if it is present;
  the wrapper remains installed for rollback, but no longer intercepts shells.
- Backs up the existing `termux.properties` and `colors.properties` under
  `/data/adb/termux_clarity/backup/` before the first change.

Termux's font size is an app preference rather than a supported
`termux.properties` key. After installation, choose **Termux → Settings →
Font size** and use 19–20 if 18 still feels small. Run
`termux-reload-settings` or open a new Termux session after applying.

## Install

1. Build `dist/TermuxClarity-v1.0.1.zip`, or download the release asset.
2. Flash the ZIP from Magisk → Modules → Install from storage.
3. Reboot once.
4. Run `termux-reload-settings` in Termux, or open a new session.

The module does not force-stop Termux or close active sessions. If a setting
does not appear immediately, reload it manually.

## Rollback

Disable or uninstall the module in Magisk. The uninstall script restores the
original files only when they were not edited after installation. The backup
directory is retained so the original configuration remains recoverable.

## Build

```sh
./build.sh
```

The ZIP is a standard Magisk module archive with `module.prop` at its root.

## Upstream references

The property names follow Termux's supported property constants and shared
property implementation:

- <https://github.com/termux/termux-app/blob/master/termux-shared/src/main/java/com/termux/shared/termux/settings/properties/TermuxPropertyConstants.java>
- <https://github.com/termux/termux-app/blob/master/termux-shared/src/main/java/com/termux/shared/termux/settings/properties/TermuxSharedProperties.java>
