package authority::shared;

use 5.006;
use strict;
use Object::AUTHORITY 0 qw();

BEGIN {
	$authority::shared::AUTHORITY = 'cpan:TOBYINK';
	$authority::shared::VERSION   = '0.005';
}

use Carp qw(croak);
use Scalar::Util qw(blessed);
use Sub::Name qw(subname); # protects against namespace::autoclean.

sub import
{
	shift if $_[0] eq __PACKAGE__;
	my ($caller) = caller;
	
	no strict 'refs';
	push @{"$caller\::AUTHORITIES"}, @_;
	*{"$caller\::AUTHORITY"} = subname("$caller\::AUTHORITY", \&AUTHORITY);
}

sub AUTHORITY
{
	my ($invocant, $test) = @_;
	$invocant = ref $invocant if blessed($invocant);
	
	my @authorities = do {
		no strict 'refs';
		my @a = @{"$invocant\::AUTHORITIES"};
		unshift @a, ${"$invocant\::AUTHORITY"};
		@a;
		};
	
	if (scalar @_ > 1)
	{
		my $pass = undef;
		AUTH: for (@authorities)
		{
			next AUTH
				unless Object::AUTHORITY::reasonably_smart_match($_, $test);
			$pass = $_;
			last AUTH;
		}
		croak("Invocant ($invocant) has authority '$authorities[0]'")
			unless defined $pass;
		return $pass;
	}
	
	return wantarray ? @authorities : $authorities[0];
}

1;

__END__

=head1 NAME

authority::shared - a multi-AUTHORITY method for your classes

=head1 SYNOPSIS

 package MyApp;
 BEGIN { $MyApp::AUTHORITY = 'cpan:JOE'; }
 use authority::shared qw(cpan:ALICE cpan:BOB);
 
 package main;
 use feature qw(say);
 say scalar MyApp->AUTHORITY;     # says "cpan:JOE"
 MyApp->AUTHORITY('cpan:JOE');    # lives
 MyApp->AUTHORITY('cpan:ALICE');  # lives
 MyApp->AUTHORITY('cpan:BOB');    # lives
 MyApp->AUTHORITY('cpan:CAROL');  # croaks

=head1 DESCRIPTION

This module allows you to indicate that your module is issued by multiple
authorities. The package variable C<< $AUTHORITY >> should still be used
to indicate the primary authority for the package.

This module does two simple things:

=over

=item 1. Creates an C<< @AUTHORITIES >> array in the caller package,
populating it with the arguments passed to C<< authority::shared >>
on the "use" line.

=item 2. Exports an AUTHORITY function to your package that reads the
C<< $AUTHORITY >> and C<< @AUTHORITIES >> package variables.

=back

The main use case for shared authorities is for team projects. The team
would designate a URI to represent the team as a whole. For example, 
C<< http://datetime.perl.org/ >>, C<< http://moose.iinteractive.com/ >> 
or C<< http://www.perlrdf.org/ >>. Releases can then be officially stamped
with the authority of the team using:

 use authority::shared q<http://www.perlrdf.org/>;

And users can check they have an module released by the official team
using:

 RDF::TakeOverTheWorld->AUTHORITY(q<http://www.perlrdf.org/>);

which will croak if package RDF::TakeOverTheWorld doesn't have the
specified authority.

=head1 BUGS

An obvious limitation is that this module relies on honesty. Don't
release modules under authorities you have no authority to use.

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=authority-shared>.

=head1 SEE ALSO

=over

=item * L<Object::AUTHORITY> - an AUTHORITY method for your class

=item * I<authority::shared> (this module) - a more sophisticated AUTHORITY method for your class

=item * L<UNIVERSAL::AUTHORITY> - an AUTHORITY method for every class (deprecated)

=item * L<UNIVERSAL::AUTHORITY::Lexical> - an AUTHORITY method for every class, within a lexical scope

=item * L<authority> - load modules only if they have a particular authority

=back

Background reading: L<http://feather.perl6.nl/syn/S11.html>,
L<http://www.perlmonks.org/?node_id=694377>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2011 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

