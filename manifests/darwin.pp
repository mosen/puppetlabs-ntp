# Class: ntp::darwin
#
# This class manages NTP on Darwin/OSX via the `systemsetup` utility.
#
#
# Parameters:
#
#   $servers = [ 'time.apple.com' ]
#
# Actions:
#
#	Enables/Disables NTP time sources and configures the list of NTP time sources.
#
#
# Sample Usage:
# 
#	Refer to the top level NTP class for details on usage. This class will automatically
#   be included if the operatingsystem is detected as darwin.
#
# Limitations:
#
# 	NTP setting via `systemsetup` can only use a single DNS name on Darwin. If you supply an
#   array of servers, only the first server is actually used.
#
class ntp::darwin(
	$servers,
) {

	exec { "Enable NTP":
		command => "systemsetup -setusingnetworktime on",
		unless  => "test `systemsetup -getusingnetworktime |grep \"On\"`",
		path    => "/usr/sbin",
 	}

 	exec { "Set NTP Server":
 		command => "systemsetup -setnetworktimeserver ${servers[0]}",
 		unless  => "test `systemsetup -getnetworktimeserver |awk -F: '{print $2}'|cut -c 2-` = \"${servers[0]}\"",
 		require => Exec["Enable NTP"],
 	}

}