#!/usr/bin/perl

use strict;
use Text::ParseWords;
use Data::Dumper;

open FH, @ARGV[1] or die $!;

my @lines = grep /@ARGV[0]/i, sort <FH>;

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

=head1 EXAMPLE

Do a CSV export of the roadmunk financial year you're interested in.  Note the filename.

 $ ./my_training.pl judd "/Users/jmaltin/Downloads/FY18 ILT Roadmap (3).csv"
 2017-06-19 -:- Delivered -:- PA - OpenShift Advanced Deployment - RHC - Raleigh (1 of 2) -:- Shachar Borenstein -:-
 2017-07-17 -:-  -:- OpenShift Advanced Deployment - Judd - Co-teach -:- Judd Maltin -:-
 2017-07-17 -:- Sponsor Confirmed -:- PA - OpenShift Advanced Deployment - RHC - Raleigh (1 of 2) -:- Wolfgang Kulhanek -:-
 2017-07-31 -:- Sponsor Confirmed -:- PA - OpenShift Advanced Deployment - Japan / GCG - Tokyo (1 of 2) -:- Judd Maltin -:-
 2017-08-14 -:- Sponsor Confirmed -:- PA - OpenShift Advanced Deployment - RHC/APP - Raleigh (1 of 2) -:- Judd Maltin -:-
 2017-09-25 -:- Requested -:- PA - OpenShift Advanced Deployment - RHC/APP - Raleigh (1 of 2) -:- Judd Maltin -:-
 2017-11-06 -:- Requested -:- PA - Advanced OpenShift Deployment - RHC/APP - Raleigh -:- Judd Maltin -:-
 $ 

=cut

