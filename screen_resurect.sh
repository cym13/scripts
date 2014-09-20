#!/bin/sh

screen -ls | grep Detached | while read screen_session ; do
    ss_id=$(echo $screen_session | sed "s/^[^.]\+.\([^ ]\+\).*$/\1/")
    urxvt -e screen -r $ss_id &
done
