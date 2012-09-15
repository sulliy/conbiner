#!/usr/bin/perl

use strict;
use warnings;

my $usage = <<USAGE;
usage : [-a] [-b] [-t]
    -a == [file path of file A]
    -b == [file path of file B]
    -t == [AandB | AsubB | BsubA] (Optinal)
	AandB --- output lines exist in A or in B
	AsubB --- output lines exist in A not in B
	BsubA --- output lines exist in B not in A
USAGE

if((! our $a) || (! our $b)) {
	print "input parameters are incorrect.\n";
	print $usage;
	die "";
}

my $aandb = "AandB";
my $asubb = "AsubB";
my $bsuba = "BsubA";
my $style;

if(our $t){
	$style = $t;
	#case insensitive
	if(! ($style =~ /^$aandb/i) && ! ($style =~ /^$asubb/i) && ! ($style =~ /^$bsuba/i)) {
		$style = "AandB";
		print "-t (type) is incorrect, use default type: AandB";
	}
}else{
	$style = "AandB"
}

#print "$style\n";

# open file to the handle <FILE>
open(FILEA, "<$a") || die "Could not read from $a, program halting.";
open(FILEB, "<$b") || die "Could not read from $a, program halting.";
open(OUTPUT, ">output.txt") || die "Could not read from $a, program halting.";

my $linea;
my $lineb;

my $found = 0;
my $cmp_str_a = "";
my $cmp_str_b = "";

if($style =~ /^$aandb/i){
	my @lineas = <FILEA>;
	my @linebs = <FILEB>;
	push(@lineas, @linebs);
	
	my @lines_sorted = sort(@lineas);
	my $i = 0;
	my $last_write_line = "";
	while($i <= $#lines_sorted){
		# if current line is unequal to the prior line
		if($last_write_line ne $lines_sorted[$i]){
			print OUTPUT ($lines_sorted[$i]);
		}
		$last_write_line = $lines_sorted[$i];
		$i++;
	}
}elsif($style =~ /^$asubb/i){
	while($linea = <FILEA>){
		$cmp_str_a = $linea;
		chomp($cmp_str_a);
		$found = 0;
		seek(FILEB, 0, 0);
		while($lineb = <FILEB>){
			$cmp_str_b = $lineb;
			chomp($cmp_str_b);
			if($cmp_str_a eq $cmp_str_b){
				$found++;
			}		
		}
		if($found == 0){
			print OUTPUT ($linea);
		}
	}	
}elsif($style =~ /^$bsuba/i){
	while($lineb = <FILEB>){
		$cmp_str_b = $lineb;
		chomp($cmp_str_b);
		$found = 0;
		seek(FILEA, 0, 0);
		while($linea = <FILEA>){
			$cmp_str_a = $linea;
			chomp($cmp_str_a);
			if($cmp_str_b eq $cmp_str_a){
				$found++;
			}		
		}
		if($found == 0){
			print OUTPUT ($lineb)
		}
	}	
}

close(FILEA);
close(FILEB);
close(OUTPUT);

#end