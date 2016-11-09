# == Define: icinga2::object::downtime
#
# Manage Icinga2 downtime objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the endpoint object, absent disables it. Defaults to present.
# 
# [*host_name*]
#     Required. The name of the host this comment belongs to.
#
# [*service_name*]
#     Optional. The short name of the service this comment belongs to. If omitted, this comment object is treated as host comment.
#
# [*author*]
#     Required. The author's name.
#
# [*comment*]
#     Required. The comment text.
#
# [*start_time*]
#     Required. The start time as unix timestamp.
#
# [*end_time*]
#     Required. The end time as unix timestamp.
#
# [*duration*]
#     Required. The duration as number.
#
# [*entry_time*]
#     Optional. The unix timestamp when this downtime was added.
#
# [*fixed*]
#     Optional. Whether the downtime is fixed (true) or flexible (false). Defaults to flexible. Details in the advanced topics chapter.
#
# [*triggers*]
#     Optional. List of downtimes which should be triggered by this downtime.
#
# [*target*]
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# [*order*]
#   String to set the position in the target file, sorted alpha numeric. Defaults to 30.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
define icinga2::object::downtime (
  $ensure               = present,
  $host_name            = undef,
  $service_name         = undef,
  $author               = undef,
  $comment              = undef,
  $start_time           = undef,
  $end_time             = undef,
  $duration             = undef,
  $entry_time           = undef,
  $fixed                = undef,
  $triggers             = undef,
  $order                = '30',
  $target               = undef,
){
  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_absolute_path($target)
  validate_integer ( $order )

  validate_string($host_name)
  if $service_name { validate_string ($service_name) }
  validate_string($author)
  validate_string($comment)
  validate_integer($start_time)
  validate_integer($end_time)
  validate_integer($duration)
  if $entry_time { validate_integer($entry_time) }
  if $fixed { validate_bool($fixed) }
  if $triggers { validate_array($triggers) }

  # compose attributes
  $attrs = {
    'host_name'    => $host_name,
    'service_name' => $service_name,
    'author'       => $author,
    'comment'      => $comment,
    'start_time'   => $start_time,
    'end_time'     => $end_time,
    'duration'     => $duration,
    'entry_time'   => $entry_time,
    'fixed'        => $fixed,
    'triggers'     => $triggers,
  }

  # create object
  icinga2::object { "icinga2::object::Downtime::${title}":
    ensure      => $ensure,
    object_name => $name,
    object_type => 'Downtime',
    attrs       => $attrs,
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }

}
