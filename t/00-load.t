#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Devel::REPL::Plugin::LoadScript' ) || print "Bail out!\n";
}

diag( "Testing Devel::REPL::Plugin::LoadScript $Devel::REPL::Plugin::LoadScript::VERSION, Perl $], $^X" );
