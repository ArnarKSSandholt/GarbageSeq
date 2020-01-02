#!/usr/bin/perl
use warnings;
use strict;
use v5.10; # Required when using "say"

# Reading infile arguments
my $infile1 = $ARGV[0]; 
my $infile2 = $ARGV[1];

# Reading outfile arguments
my $outfile1 = $ARGV[2];
my $outfile2 = $ARGV[3];


open my $INFILE1, '<', $infile1 or die "Could not open $infile1: $!";
open my $INFILE2, '<', $infile2 or die "Could not open $infile2: $!";
open my $OUTFILE1, '>', $outfile1 or die "Could not open $outfile1: $!";
open my $OUTFILE2, '>', $outfile2 or die "Could not open $outfile2: $!";



# Read both files into arrays (since they aren't so big)
# Also remove the new line characters from the end of each line
chomp(my @lines1 = <$INFILE1>);
chomp(my @lines2 = <$INFILE2>);

# Hash for holding common fOTUs
my %common;

# Make hashes from the arrays with the fOTU id as key
# and as value 
my %fOTUs1 = map { $_ => $_ } @lines1;
my %fOTUs2 = map { $_ => $_ } @lines2;

# Loop through all fOTUs in the second file and print
# the ones found in both
foreach my $key (sort keys %fOTUs1) {
  my $value = delete $fOTUs2{$key};
  # If the fOTU was found populate with common fOTUs
  if ($value){
    $common{$key} = $value;
  }
}

# Remove common fOTUs from first hash
foreach my $key (sort keys %common) {
  my $value = delete $fOTUs1{$key};
  # Print the fOTUs in common to STDOUT
  say $key;
}

# Print all unique fOTUs
foreach my $key (sort keys %fOTUs1) {
  say $OUTFILE1 $key;
}
foreach my $key (sort keys %fOTUs2) {
  say $OUTFILE2 $key;
}


close $INFILE1;
close $INFILE2;
close $OUTFILE1;
close $OUTFILE2;