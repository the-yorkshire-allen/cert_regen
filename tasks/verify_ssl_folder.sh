#!/bin/sh
source_path=$(puppet config print ssldir)
destination_path=$source_path"_old"

if [ -d $destination_path ] && [ -d $source_path ]
then
  echo "ssl folder successfully recreated; cleaning up"
  rm -rf $destination_path
  rm /tmp/run_agent.sh
  exit 0
fi

echo "ssl folder status unexpected"

exit 1