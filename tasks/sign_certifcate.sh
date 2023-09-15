#!/bin/sh

while [ puppetserver ca list --certname $PT_agent_certname | grep -q 'Missing' ]; do
  sleep 2
done

while ! [ puppetserver ca list --certname $PT_agent_certname | grep -q 'Unsigned' ]; do
  sleep 2
done

puppetserver ca sign --certname $PT_agent_certname

exit $?