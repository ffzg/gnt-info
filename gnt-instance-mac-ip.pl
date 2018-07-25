#!/usr/bin/perl
use warnings;
use strict;
use autodie;

my $mac2ip_vlan;
my ($in,$out);
open(my $in, '<', '/dev/shm/mac-ip-vlan');
while(<$in>) {
	print $out $_ if $out;
	chomp;
	my ( $mac, $ip, $vlan ) = split(/\s/,$_);
	$mac2ip_vlan->{$mac} = [ $ip, $vlan ];
}

open(my $gnt, '-|', qq{gnt-instance list --no-header --separator=' ' -o name,nic.macs,nic.bridges,tags});
while(<$gnt>) {
	chomp;
	my ( $name,$macs,$bridges,$tags ) = split(/\s/,$_,4);
	my @macs = split(/,/,$macs);
	my @br  = split(/,/,$bridges);
	for my $i ( 0 .. $#macs ) {
		my $mac = $macs[$i];
		print "$name $mac $br[$i] ";
		if ( exists $mac2ip_vlan->{$mac} ) {
			print join(' ', @{ $mac2ip_vlan->{$mac} });
		} else {
			print "? ?";
		}
		$tags =~ s/ganeti:watcher[^,]*,*//g;
		$tags =~ s/ganetimgr://g;
		print " $tags\n";
	}
}
