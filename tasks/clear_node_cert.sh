#!/bin/sh
# Puppet Task Name: clear_node_cert

cat <<EOF > /tmp/clear_agent_cert.sh
#!/bin/bash
puppet resource service puppet ensure=stopped enable=true

while [ puppet agent --fingerprint | grep -q '(SHA256)' ]; do
  sleep 2
done

puppet ssl clean

puppet resource service puppet ensure=running enable=true
EOF

chmod +x /tmp/clear_agent_cert.sh
(set -m; setsid --fork /tmp/clear_agent_cert.sh &>/dev/null &)

echo "Puppet agent has been run to reset SSL configuration"
exit 0