package Text::DoubleMetaphone;

use strict;
use Carp;
use vars qw( $VERSION @ISA @EXPORT_OK $AUTOLOAD );

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw( Exporter DynaLoader );
@EXPORT_OK = qw( double_metaphone );

$VERSION = '0.01';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    my $constname;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "& not defined" if $constname eq 'constant';
    my $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	if ($! =~ /Invalid/) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
		croak "Your vendor has not defined DoubleMetaphone macro $constname";
	}
    }
    no strict 'refs';
    *$AUTOLOAD = sub () { $val };
    goto &$AUTOLOAD;
}

bootstrap Text::DoubleMetaphone $VERSION;

1;

__END__

=head1 NAME

Text::DoubleMetaphone - Phonetic encoding of words. 

=head1 SYNOPSIS

  use Text::DoubleMetaphone qw( double_metaphone);
  my($code1, $code2) = double_metaphone("Aubrey");   

=head1 DESCRIPTION

This module implements a "sounds like" algorithm developed
by Lawrence Philips which he published in the June, 2000 issue
of I<C/C++ Users Journal>.  Double Metaphone is an improved
version of Philips' original Metaphone algorithm. 

In contrast to the Soundex and Metaphone algorithms,
Double Metaphone will sometimes return two encodings for
words that can be plausibly pronounced multiple ways.      

For additional details, see Philips' Double Metaphone article at:

  http://www.cuj.com/archive/1806/feature.html

=head1 FUNCTIONS

=over 4

=item double_metaphone( STRING )

Takes a word and returns a phonetic encoding.  In
an array context, it returns one or two phonetic encodings
for the word.  In a scalar context, it returns the first encoding.
The first encoding is usually based on the most commonly 
heard U.S. pronounciation of the word.

=back

=head1 AUTHOR

Copyright 2000, Maurice Aubrey E<lt>maurice@hevanet.comE<gt>.
All rights reserved.

This module is free software; you may redistribute it and/or
modify it under the same terms as Perl itself.  

=head1 SEE ALSO

=head2 Man Pages

L<Text::MetaPhone>, L<Text::Soundex>

=head2 Additional References

=over 3

=item Philips, Lawrence. I<C/C++ Users Journal>, June, 2000.
=item Philips, Lawrence. I<Computer Language>, Vol. 7, No. 12 (December), 1990.

=back

=cut