#!/bin/sh
# Author: Athmane Madjoudj <athmanem@gmail.com>

t_Log "Running $0 - NTP is using CentOS server pool test."

grep ".centos.pool.ntp.org" /etc/ntp.conf > /dev/null 2>&1

t_CheckExitStatus $?