#!/bin/sh
puppet node clean $PT_agent_certnames;
if [ $PT_purge_data ]; then
    puppet node purge $PT_agent_certnames;
fi
exit 0