package Devel::REPL::Plugin::LoadScript;

use 5.006;
use strict;
use warnings FATAL => 'all';
use Devel::REPL::Plugin;
use Path::Tiny;
use LWP::UserAgent;
use JSON;
use namespace::autoclean;

=encoding utf8

=head1 NAME

Devel::REPL::Plugin::LoadScript - The great new Devel::REPL::Plugin::LoadScript!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

At Devel::REPL prompt
    
    $ $_REPL->load_plugin('LoadScript')
    $ #loadscript scripts/myscript.pl

=cut

=head1 Methods

=cut

=head2 command_loadscript

Try to load and eval the script.

=cut

sub command_loadscript {

  my ($self, undef, $filename) = @_;

  my $file = path($filename);
  if ($file->exists) {
    return $self->formatted_eval($file->slurp);
  } 
  return 'File does not exists!';
}

=head2 command_loadgist

Try to load an eval a gist

=cut

sub command_loadgist {
    my ($self, undef, $gisturl) = @_;

    if ($gisturl =~ m{https://gist.github.com(?:.*)/([^/]+)}) {
        my $api_url = 'https://api.github.com/gists/' . $1;
        my $ua = LWP::UserAgent->new;
        my $response = $ua->get($api_url); 
        if ($response->is_error) {
            my $text = $response->status_line;
            return 'Failed: ' . $text;
        }
        my $files = decode_json($response->content)->{'files'};
        my @filenames = keys %$files;
        if (scalar @filenames == 1) {
            return $self->formatted_eval($files->{$filenames[0]}{'content'});
        }
    } else {
        return 'URL not recognized: ' . $gisturl;
    }
}

=head2 BEFORE_PLUGIN

Load Turtles plugin and "register" the command

=cut

sub BEFORE_PLUGIN {
    my ( $repl ) = @_;

    $repl->load_plugin('Turtles');
    $repl->add_turtles_matcher(sub {
        my ( $line ) = @_;

        my $prefix = $repl->default_command_prefix;

        if($line =~ /^${prefix}loadscript/) {
            return {}; 
        }

        return;
    });
}

=head1 AUTHOR

Pablo Rodríguez González, C<< <pablo.rodriguez.gonzalez at bigwebserachenginemailservice> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-devel-repl-plugin-loadscript at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Devel-REPL-Plugin-LoadScript>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Devel::REPL::Plugin::LoadScript


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Devel-REPL-Plugin-LoadScript>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Devel-REPL-Plugin-LoadScript>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Devel-REPL-Plugin-LoadScript>

=item * Search CPAN

L<http://search.cpan.org/dist/Devel-REPL-Plugin-LoadScript/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2014 Pablo Rodríguez González.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of Devel::REPL::Plugin::LoadScript
