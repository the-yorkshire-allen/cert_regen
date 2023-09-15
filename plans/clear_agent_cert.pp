# @summary Clear the agent certificates from the PuppetDB and refresh the agent nodes.
# @param targets The the agent nodes having their certificates renewed.
# @param primary The primary server node on which puppet node clean is run.
plan axa::clear_agent_cert (
  TargetSpec $targets,
  TargetSpec $primary,
) {
  $clear_certificates_result = run_task('axa::clear_node_cert', $targets, '_catch_errors' => true)

  $agent_names = join($clear_certificates_result.ok_set.names,' ')

  $remove_result = run_task('axa::remove_certificate', $primary, '_catch_errors' => true, 'agent_certnames' => $agent_names, 'purge_data' => false)

  return ({
      'successful_ssl_regen' => $remove_result.ok_set.names,
      'failed_agent_clear'  => $clear_certificates_result.error_set.names,
  })
}
