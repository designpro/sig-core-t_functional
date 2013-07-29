#!/bin/bash
# Author: James Hogarth <james.hogarth@gmail.com>
#

# Need admin credentials
kdestroy &> /dev/null

klist 2>&1  | grep "No credentials" &> /dev/null

t_CheckExitStatus $?

expect -f - &> /dev/null <<EOF
set send_human {.1 .3 1 .05 2}
spawn kinit admin
sleep 1
expect "Password for admin@C6IPA.LOCAL:"
send -h "p455w0rd\r"
sleep 1
close
EOF

klist | grep "admin@C6IPA.LOCAL" &> /dev/null

t_CheckExitStatus $?



t_Log "Running $0 - test adding user"
userdetails="$(ipa user-add --first=test --last=user --random testuser)"
echo "$userdetails" | grep 'Added user "testuser"' &> /dev/null 

t_CheckExitStatus $?

t_Log "Running $0 - verify details of user"

echo "$userdetails" | grep ' First name: test' &> /dev/null 

t_CheckExitStatus $?

echo "$userdetails" | grep 'Last name: user' &> /dev/null 

t_CheckExitStatus $?

echo "$userdetails" | grep 'Full name: test user' &> /dev/null 

t_CheckExitStatus $?

echo "$userdetails" | grep 'Home directory: /home/testuser' &> /dev/null 

t_CheckExitStatus $?

t_Log "Running $0 - testing initial password change of user"
kdestroy &> /dev/null

expect -f - &> /dev/null  <<EOF
set send_human {.1 .3 1 .05 2}
spawn kinit testuser
sleep 1
expect "Password for testuser@C6IPA.LOCAL: "
send -h -- "$(echo "$userdetails" | awk '$0 ~ /Random password/ {print $3}')\r"
sleep 1
expect "Enter new password: "
send -h -- "newp455w0rd\r"
sleep 1
expect "Enter it again: "
send -h -- "newp455w0rd\r"
sleep 1
close
EOF

klist | grep "testuser@C6IPA.LOCAL" &> /dev/null

t_CheckExitStatus $?

kdestroy &> /dev/null



