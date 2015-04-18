#!/bin/bash

action=${1}

cecBin="/usr/local/bin/cec-client"

onCommand='echo "on 0" | ${cecBin} -s'
offCommand='echo "standby 0" | ${cecBin} -s'
inputCommand='echo "as" | ${cecBin} -s'

do_on()
{
eval ${onCommand} > /dev/null 2>&1
}

do_off()
{
eval ${offCommand} > /dev/null 2>&1
}

do_input()
{
eval ${inputCommand} > /dev/null 2>&1
}

case ${action} in

        on)
                do_on
                exit 0
                ;;

        off)
                do_off
                exit 0
                ;;

        input)
                do_input
                exit 0
                ;;

        *)
                echo $"Usage: $0 {on|off|input}"
                exit 1
                ;;

esac
