class upgradedb(
  $artifact_dir = hiera('artifact_dir'),
  $artifact_exe = hiera('artifact_exe'),
  $artifact_exe_url = hiera('artifact_exe_url'),
  $artifact_name = hiera('artifact_name'),
  $artifact_url = hiera('artifact_url'),
  $project = hiera('project'),
  $allow_snapshot = hiera('allow_snapshot'),
  $allow_rollback = hiera('allow_rollback')
) {

  if $allow_rollback == true {
    $allowrollback = "-allowrollback"
  } else {
    $allowrollback = ""
  }

  if $allow_snapshot == true {
    $snap = "-snap"
  } else {
    $snap = ""
  }

  file {$artifact_dir:
    ensure => directory,
  }

  file {"#{artifact_dir}\#{project}":
    ensure => directory,
    mode => 660,
    require => File[$artifact_dir],
  }

  file {"#{artifact_dir}\#{artifact_exe}":
    ensure => present,
    mode => 500,
    source => $artifact_exe_url,
    require => File[$artifact_dir],
  }

  file {"#{artifact_dir}\#{project}\#{artifact_name}":
    ensure => present,
    mode => 600,
    source => $artifact_url,
    require => File["#{artifact_dir}\#{project}"],
  }

  exec {"#{artifact_exe} -a='#{artifact_dir}\#{artifact_name}' #{snap} #{allowrollback}":
    cwd => $artifact_dir,
    path => $artifact_dir,
    require => File[$artifact_dir,"#{artifact_dir}\#{project}\#{artifact_name}"],
  }

}
