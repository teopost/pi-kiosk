#!/bin/sh

export DISPLAY=:0
bgproc=0
delay=6
media_folder='/mnt/uie-kiosk/slides'

trap ctrl_c INT

ctrl_c() {
   echo "** Trapped CTRL-C"
   kill_feh
   exit
}

start_slideshow()
{
   /usr/bin/feh --quiet --recursive --full-screen --slideshow-delay ${delay} ${media_folder} &
   bgproc=$!
   echo "start slideshow, pid $bgproc"
}

folder_hash ()
{
  md5=$(find $media_folder -type f -print0 | xargs -0 | md5sum | cut -f1 -d" ")
  echo $md5
}

kill_feh ()
{
  killall -q feh
}


# Main
# ----
echo "START"
hash=$(folder_hash)
kill_feh
start_slideshow

while :
do
        # detect folder changes
        hash_new=$(folder_hash)

	if [ $hash != $hash_new ]
	then
		echo "detect changes, kill pid $bgproc"
                hash=$hash_new
                kill -9 $bgproc
                sleep 1
                start_slideshow
	fi
done
