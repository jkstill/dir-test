#!/usr/bin/perl

# mtf.pl - make test files

use strict;

=head1

http://poirot/docs/perl/cdlib/cookbook/ch09_02.htm

example shows how to call utime:

$SECONDS_PER_DAY = 60 * 60 * 24;
($atime, $mtime) = (stat($file))[8,9];
$atime -= 7 * $SECONDS_PER_DAY;
$mtime -= 7 * $SECONDS_PER_DAY;

utime($atime, $mtime, $file)
    or die "couldn't backdate $file by a week w/ utime: $!";

You must call utime with both atime and mtime values. If you only want to change one, you must call stat first to get the other:

$mtime = (stat $file)[9];
utime(time, $mtime, $file);

=cut

use constant INTERVAL => 14;
use constant MAXFILES => 500000;

my($atime, $mtime);
$atime = $mtime = time;

my $dir = 'audit';

-d "$dir" || mkdir $dir;
-d "$dir" || die "cannot read dir $dir\n - $! \n";

my ($fileBase,$fileExt) = ("${dir}/+asm1_ora_",'aud');

for (my $i=0;$i<=MAXFILES;$i++) {
	my $filename = "${fileBase}${i}.${fileExt}";
	open FH, (">$filename") || die "cannot create $filename - $!\n";
	close FH;
	utime($atime,$mtime,$filename);
	$atime = $mtime -= INTERVAL;
}


my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset) = localtime($mtime);

print "oldest file created: ", 1900+$yearOffset, "-$month-$dayOfMonth $hour:$minute:$second\n";




