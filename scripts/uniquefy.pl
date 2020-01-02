#!/usr/bin/perl
use warnings;
use strict;
use v5.24; # Required for use with <<>>

# Hash for holding unique fOTU ids
my %fOTUs;

# Read all input arguments in order line by line
while (<<>>) {
  # Remove \n
  chomp;
  # Check if the current fOTU isn't already added to the hash
  if (!exists $fOTUs{$_}) {
    # If not added add the fOTU as key
    $fOTUs{$_} = 1;
  }
}

# Gather all the keys to an array
my @unique_fOTUs = keys %fOTUs;

# Print all unique fOTUs to STDOUT
foreach (@unique_fOTUs){
  say $_;
}