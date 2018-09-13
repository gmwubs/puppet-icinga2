# == Define: icinga2::object::hostgroup
#
# Manage Icinga 2 HostGroup objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*display_name*]
#   A short description of the host group.
#
# [*groups*]
#   An array of nested group names.
#
# [*assign*]
#   Assign host group members using the group assign rules.
#
# [*target*]
#   Destination config file to store in this object. File will be declared at the
#   first time.
#
# [*order*]
#   String or integer to set the position in the target file, sorted alpha numeric. Defaults to 55.
#
# === Examples
#
# icinga2::object::hostgroup { 'monitoring-hosts':
#   display_name => 'Linux Servers',
#   groups       => [ 'linux-servers' ],
#   target       => '/etc/icinga2/conf.d/groups2.conf',
#   assign       => [ 'host.name == NodeName' ],
# }
#
#
define icinga2::object::hostgroup(
  Stdlib::Absolutepath        $target,
  Enum['absent', 'present']   $ensure         = present,
  String                      $hostgroup_name = $title,
  Optional[String]            $display_name   = undef,
  Optional[Array]             $groups         = undef,
  Array                       $assign         = [],
  Array                       $ignore         = [],
  Variant[String, Integer]    $order          = 55,
) {

  if $ignore != [] and $assign == [] {
    fail('When attribute ignore is used, assign must be set.')
  }

  # compose the attributes
  $attrs = {
    display_name   => $display_name,
    groups         => $groups,
  }

  # create object
  icinga2::object { "icinga2::object::HostGroup::${title}":
    ensure      => $ensure,
    object_name => $hostgroup_name,
    object_type => 'HostGroup',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    assign      => $assign,
    ignore      => $ignore,
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }
}
