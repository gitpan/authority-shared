package Local::Module;
BEGIN { $Local::Module::AUTHORITY = 'cpan:TOBYINK' ; }
use authority::shared qw(http://tobyinkster.co.uk/ mailto:tobyink@cpan.org);

package main;
use 5.010;
use Data::Dumper;
say Local::Module->AUTHORITY('cpan:TOBYINK');
say Local::Module->AUTHORITY('mailto:tobyink@cpan.org');
say Local::Module->AUTHORITY('cpan:JOE'); # should die
