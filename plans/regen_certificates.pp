# @summary A plan to backup ssl folder, remove node certificate from primary and regenerate it.
# @param targets The targets that will have their certificates renewed
# @param primary The primary target that will be used to remove the certificates
plan cert_regen::regen_certificate (
  TargetSpec $targets,
  TargetSpec $primary,
) {
  get_targets($targets).each | $target | {
    out::message("Clearing SSL folder on ${target}")
    $clear_certificates_result = run_task('cert_regen::clear_certificates', $target, '_catch_errors' => true)
    if $clear_certificates_result.ok {
      $remove_result = run_task('cert_regen::remove_certificate', $primary, '_catch_errors' => true, 'agent_certnames' => $target.name, 'purge_data' => false)
      if $remove_result.ok {
        $wait_target = wait_until_available($target, wait_time => 60, '_catch_errors' => true)

        if $wait_target.ok {
          $verify_result = run_task('cert_regen::verify_ssl_folder', $target, '_catch_errors' => true)
        } else {
          out::message("Node ${target} failed to respond within given time")
        }
      }
    }
  }
}
