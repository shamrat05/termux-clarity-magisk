#!/system/bin/sh

# Magisk Manager action: apply the same safe config on demand.
MODDIR=${0%/*}
exec "$MODDIR/service.sh"
