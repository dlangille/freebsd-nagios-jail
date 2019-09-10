#!/bin/sh

SUDO="/usr/local/bin/sudo"

PKG_BASE_AUDIT="/usr/local/etc/periodic/security/405.pkg-base-audit"

RESULT=`${SUDO} ${PKG_BASE_AUDIT} 2>&1`
CODE=$?

if [ "${CODE}" == "0" ]
then
  echo 'No problems found'
  exit 0
else
  echo ${RESULT}
  exit 2
fi
