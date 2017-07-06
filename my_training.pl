#!/usr/bin/perl

use strict;
use Text::ParseWords;
use Data::Dumper;

my @lines = grep /$1/i, sort <>;

#print Dumper @lines;

my @data;

for my $l  ( @lines )  {
	my @values = quotewords("," => 0, $l) ;
	#print Dumper @values;
	push @data, join " -:- ", @values[3,13,1,9], "\n";
}

print sort @data;

=pod

=head1 NAME

My Training - For Red Hat GPTE - Extract your training from the CSV from roadmunk.com

=head1 SYNOPSIS

./my_training.pl I<your_name> I<filename>

=cut

