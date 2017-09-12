#!/bin/sh
slack_url="https://hooks.slack.com/services/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"

#function notify_slack
#{
#  curl -X POST --data-urlencode payload@- $slack_url << EOF
#{"username": "Diskbot", "icon_emoji": ":floppy_disk:", "text":"Running out of disk space on $(hostname) as of $(date)"}
#EOF
#}

df -H | grep -vE '^Filesystem|/dev/sda1|tmpfs|cdrom|/exports|udev' | awk '{ print $5 " " $1 }' | while read output;
do
  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge 75 ]; then
    echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)"
    curl -X POST --data-urlencode 'payload={"username": "Diskbot", "icon_emoji": ":floppy_disk:", "text": "Running out of disk space '"$partition"' is '"$usep"'% full on '"$(hostname)"' as of '"$(date)"'"}' $slack_url
  fi
done
