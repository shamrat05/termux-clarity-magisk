#!/system/bin/sh

# Termux Clarity deliberately has no resident daemon, polling loop, or sysctl
# tuning. It only applies the two user-facing Termux files once per boot.
MODDIR=${0%/*}
TERMUX_HOME=/data/data/com.termux/files/home
TERMUX_DIR=$TERMUX_HOME/.termux
STATE_DIR=/data/adb/termux_clarity
BACKUP_DIR=$STATE_DIR/backup
LOG_FILE=$STATE_DIR/termux-clarity.log

mkdir -p "$BACKUP_DIR" 2>/dev/null

log_line() {
  printf '%s\n' "$1" >> "$LOG_FILE"
}

if [ ! -d "$TERMUX_HOME" ]; then
  log_line "Termux is not installed; nothing to apply"
  exit 0
fi

# Let Android finish mounting app data before touching Termux's private files.
sleep 8
mkdir -p "$TERMUX_DIR" 2>/dev/null

TERMUX_UID=$(stat -c '%u' /data/data/com.termux 2>/dev/null)
TERMUX_GID=$(stat -c '%g' /data/data/com.termux 2>/dev/null)
[ -n "$TERMUX_UID" ] || TERMUX_UID=10482
[ -n "$TERMUX_GID" ] || TERMUX_GID=$TERMUX_UID

install_file() {
  SOURCE=$1
  TARGET=$2
  BACKUP=$3

  if [ ! -f "$SOURCE" ]; then
    log_line "Missing module source: $SOURCE"
    return
  fi

  if [ ! -f "$BACKUP" ] && [ -f "$TARGET" ]; then
    cp -p "$TARGET" "$BACKUP" 2>/dev/null
  fi

  if [ ! -f "$TARGET" ]; then
    cp "$SOURCE" "$TARGET" 2>/dev/null
  elif cmp -s "$SOURCE" "$TARGET" 2>/dev/null; then
    :
  elif [ -f "$BACKUP" ] && cmp -s "$BACKUP" "$TARGET" 2>/dev/null; then
    cp "$SOURCE" "$TARGET" 2>/dev/null
  else
    log_line "Preserved user-edited file: $TARGET"
    return
  fi

  chown "$TERMUX_UID:$TERMUX_GID" "$TARGET" 2>/dev/null
  chmod 600 "$TARGET" 2>/dev/null
}

install_file "$MODDIR/termux.properties" \
  "$TERMUX_DIR/termux.properties" "$BACKUP_DIR/termux.properties"
install_file "$MODDIR/colors.properties" \
  "$TERMUX_DIR/colors.properties" "$BACKUP_DIR/colors.properties"

# Android's bundled monospaced font has clear 0/O, 1/l/I shapes. Do not
# replace an existing custom font; users can remove it to opt into this font.
if [ ! -f "$TERMUX_DIR/font.ttf" ] && [ -f /system/fonts/DroidSansMono.ttf ]; then
  cp /system/fonts/DroidSansMono.ttf "$TERMUX_DIR/font.ttf" 2>/dev/null
  chown "$TERMUX_UID:$TERMUX_GID" "$TERMUX_DIR/font.ttf" 2>/dev/null
  chmod 600 "$TERMUX_DIR/font.ttf" 2>/dev/null
  log_line "Installed DroidSansMono fallback font"
fi

# The old TermuxRootMods shell wrapper replaces the global Android shell with
# a native binary. Keep it disabled so root commands remain predictable.
OLD_MODULE=/data/adb/modules/TermuxRootMods
if [ -d "$OLD_MODULE" ]; then
  touch "$OLD_MODULE/disable" 2>/dev/null
  log_line "TermuxRootMods kept disabled; Clarity owns only Termux user config"
fi

log_line "Applied Termux Clarity"
exit 0
