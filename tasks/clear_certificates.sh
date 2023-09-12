#!/bin/bash
source_path=$(puppet config print ssldir)
destination_path=$source_path"_old"
echo "Source Path: ${source_path}"
echo "Destination Path: ${destination_path}"

if [ -d "$destination_path" ]
then
  echo "backup folder already exists"
  exit 1
else
  echo "folder does not exist, move SSL folder"
  mv -f $source_path $destination_path
  if [ $? -ne 0 ]; then
    echo "Failed to moved path. Error code: $?"
    exit 2
  fi

fi

cat <<EOF > /tmp/run_agent.sh
#!/bin/bash
sleep 10
puppet agent -t
EOF

chmod +x /tmp/run_agent.sh
(set -m; setsid --fork /tmp/run_agent.sh &>/dev/null &)

echo "Puppet agent has been run to reset SSL configuration"
exit 0