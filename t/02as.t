package Local::Module;
BEGIN { $Local::Module::AUTHORITY = 'cpan:TOBYINK' ; }
use authority::shared qw(http://tobyinkster.co.uk/ mailto:tobyink@cpan.org);

package main;
use Test::More tests => 3;
use Test::Exception;

is (
	Local::Module->AUTHORITY('cpan:TOBYINK'),
	'cpan:TOBYINK',
	);

is (
	Local::Module->AUTHORITY('mailto:tobyink@cpan.org'),
	'mailto:tobyink@cpan.org',
	);

dies_ok { Local::Module->AUTHORITY('cpan:JOE') };
