#! /bin/sh

die()
{
    if ! test -z "$DBUS_SESSION_BUS_PID" ; then
        echo "killing message bus "$DBUS_SESSION_BUS_PID >&2
        kill -9 $DBUS_SESSION_BUS_PID
    fi
    echo $SCRIPTNAME: $* >&2

    exit 1
}


SCRIPTNAME=$0
MODE=$1

## so the tests can complain if you fail to use the script to launch them
DBUS_TEST_NAME_RUN_TEST_SCRIPT=1
export DBUS_TEST_NAME_RUN_TEST_SCRIPT

# Rerun ourselves with tmp session bus if we're not already
if test -z "$DBUS_TEST_NAME_IN_RUN_TEST"; then
  DBUS_TEST_NAME_IN_RUN_TEST=1
  export DBUS_TEST_NAME_IN_RUN_TEST
  exec $DBUS_TOP_SRCDIR/tools/run-with-tmp-session-bus.sh $SCRIPTNAME $MODE
fi 
echo "running test-ids"
${DBUS_TOP_BUILDDIR}/libtool --mode=execute $DEBUG $DBUS_TOP_BUILDDIR/test/name-test/test-ids || die "test-ids failed"

echo "running test-names"
${DBUS_TOP_BUILDDIR}/libtool --mode=execute $DEBUG $DBUS_TOP_BUILDDIR/test/name-test/test-names || die "test-names failed"

echo "running test-pending-call-dispatch"
${DBUS_TOP_BUILDDIR}/libtool --mode=execute $DEBUG $DBUS_TOP_BUILDDIR/test/name-test/test-pending-call-dispatch || die "test-pending-call-dispatch failed"

echo "running test-threads-init"
${DBUS_TOP_BUILDDIR}/libtool --mode=execute $DEBUG $DBUS_TOP_BUILDDIR/test/name-test/test-threads-init || die "test-threads-init failed"
