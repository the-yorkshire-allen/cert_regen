#!/bin/sh
puppet node clean $PT_agent_certnames;
$status = $?
if [ $PT_purge_data ] && [ $status == 0 ]; then
    puppet node purge $PT_agent_certnames;
    $status = $?
fi
exit $status