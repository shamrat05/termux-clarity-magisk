#!/system/bin/sh

# Restore only files that are still exactly the module's managed copies. If a
# user edited them after installation, leave those edits intact.
MODDIR=${0%/*}
TERMUX_DIR=/data/data/com.termux/files/home/.termux
BACKUP_DIR=/data/adb/termux_clarity/backup
TERMUX_UID=$(stat -c '%u' /data/data/com.termux 2>/dev/null)
TERMUX_GID=$(stat -c '%g' /data/data/com.termux 2>/dev/null)
[ -n "$TERMUX_UID" ] || TERMUX_UID=10482
[ -n "$TERMUX_GID" ] || TERMUX_GID=$TERMUX_UID

restore_file() {
  SOURCE=$1
  TARGET=$2
  BACKUP=$3
  if [ -f "$SOURCE" ] && [ -f "$TARGET" ] && [ -f "$BACKUP" ] && cmp -s "$SOURCE" "$TARGET"; then
    cp "$BACKUP" "$TARGET" 2>/dev/null
    chown "$TERMUX_UID:$TERMUX_GID" "$TARGET" 2>/dev/null
    chmod 600 "$TARGET" 2>/dev/null
  fi
}

restore_file "$MODDIR/termux.properties" "$TERMUX_DIR/termux.properties" "$BACKUP_DIR/termux.properties"
restore_file "$MODDIR/colors.properties" "$TERMUX_DIR/colors.properties" "$BACKUP_DIR/colors.properties"

# Keep the old wrapper disabled on uninstall; enabling a shell replacement
# implicitly would be surprising and can affect every root shell.
exit 0
