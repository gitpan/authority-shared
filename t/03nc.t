use Test::More;
use lib ".";
use lib "t";

plan skip_all => 'Need Sub::Name'
	unless eval 'require Sub::Name; 1';

plan skip_all => 'Need Devel::Sub::Which'
	unless eval 'require Devel::Sub::Which; 1';

plan skip_all => 'Need namespace::autoclean'
	unless eval 'require namespace::autoclean; 1';

require Example89; 
plan tests => 2;
is(
	Example89->which('AUTHORITY'),
	'Example89::AUTHORITY'
	);
is(
	Example89->AUTHORITY('http://tobyinkster.co.uk/#i'),
	'http://tobyinkster.co.uk/#i'
	);
