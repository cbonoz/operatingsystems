#! /usr/bin/perl -w

open(FOO, "osprd.c") || die "Did you delete osprd.c?";
$lines = 0;
$lines++ while defined($_ = <FOO>);
close FOO;

@tests = (


# interrupting a blocked lock doesn't destroy the wait order
    # 16
    [ # Run in a separate subshell with job control enabled.
      '(set -m; ' .
      # (1) At 0s, grab write lock; after 0.5s, write 'aaa' and exit
      '(echo aaa | ./osprdaccess -w 3 -l -d 0.5) & ' .
      # (2) At 0.1s, wait for read lock; print first character then X
      '(sleep 0.1 && ./osprdaccess -r 1 -l | sed s/$/X/ && sleep 1) & ' .
      'bgshell1=$! ; ' .
      # (3) At 0.2s, wait for read lock; print first character then Y
      '(sleep 0.2 && ./osprdaccess -r 1 -l | sed s/$/Y/ && sleep 1) & ' .
      'bgshell2=$! ; ' .
      # (4) At 0.3s, kill processes in (2); this may introduce a "bubble"
      #     in the wait queue that would prevent (3) from running
      'sleep 0.3 ; kill -9 -$bgshell1 ; ' .
      # (5) At 0.6s, kill processes in (3)
      'sleep 0.3 ; kill -9 -$bgshell2 ' .
      # Clean up separate shell.
      ') 2>/dev/null',
      "aY"
    ],

    # 17
    [ # Run in a separate subshell with job control enabled.
      '(set -m; ' .
      # (1) At 0s, grab write lock; after 0.5s, write 'aaa' and exit
      '(echo aaa | ./osprdaccess -w 3 -l -d 0.5) & ' .
      # (2) At 0.1s, wait for read lock; print first character then X
      '(sleep 0.1 && ./osprdaccess -r 1 -l | sed s/$/X/ && sleep 1) & ' .
      'bgshell1=$! ; ' .
      # (3) At 0.2s, wait for read lock; print first character then Y
      '(sleep 0.2 && ./osprdaccess -r 1 -l | sed s/$/Y/ && sleep 1) & ' .
      'bgshell2=$! ; ' .
      # (4) At 0.3s, kill processes in (3); this may introduce a 'bubble'
      #     in the wait queue that would prevent (2) from running
      'sleep 0.3 ; kill -9 -$bgshell2 ; ' .
      # (5) At 0.6s, kill processes in (2)
      'sleep 0.3 ; kill -9 -$bgshell1 ' .
      # Clean up separate shell.
      ') 2>/dev/null',
      "aX"
    ],
    );

my($ntest) = 0;

my($sh) = "bash";
my($tempfile) = "lab2test.txt";
my($ntestfailed) = 0;
my($ntestdone) = 0;
my($zerodiskcmd) = "./osprdaccess -w -z";
my(@disks) = ("/dev/osprda", "/dev/osprdb", "/dev/osprdc", "/dev/osprdd");

my(@testarr, $anytests);
foreach $arg (@ARGV) {
    if ($arg =~ /^\d+$/) {
	$anytests = 1;
	$testarr[$arg] = 1;
    }
}

foreach $test (@tests) {

    $ntest++;
    next if $anytests && !$testarr[$ntest];

    # clean up the disk for the next test
    foreach $disk (@disks) {
	`$sh <<< "$zerodiskcmd $disk"`
    }

    $ntestdone++;
    print STDOUT "Starting test $ntest\n";
    my($in, $want) = @$test;
    open(F, ">$tempfile") || die;
    print F $in, "\n";
    print STDERR $in, "\n";
    close(F);
    $result = `$sh < $tempfile 2>&1`;
    $result =~ s|\[\d+\]||g;
    $result =~ s|^\s+||g;
    $result =~ s|\s+| |g;
    $result =~ s|\s+$||;

    next if $result eq $want;
    next if $want eq 'Syntax error [NULL]' && $result eq '[NULL]';
    next if $result eq $want;
    print STDERR "Test $ntest FAILED!\n  input was \"$in\"\n  expected output like \"$want\"\n  got \"$result\"\n";
    $ntestfailed++;
}

unlink($tempfile);
my($ntestpassed) = $ntestdone - $ntestfailed;
print "$ntestpassed of $ntestdone tests passed\n";
exit(0);
