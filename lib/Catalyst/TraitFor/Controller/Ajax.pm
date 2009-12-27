package Catalyst::TraitFor::Controller::Ajax;
use MooseX::MethodAttributes::Role;

=head1 NAME

Catalyst::TraitFor::Controller::Ajax - simple and handy AJAX requests

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    package MyApp::SomeController;
    use Moose;
    BEGIN { extends 'Catalyst::Controller' }
    with 'Catalyst::TraitFor::Controller::Ajax';
    
    # URL will be '/somecontroller/ajax/my_ajax_action
    sub my_ajax_action :Chained('ajax') :Args(0) {
        # ...
    }

=head1 METHODS

=head2 begin

=cut

# just provided to allow after() to work in any case
sub begin :Private {}

after begin => sub {
    my ($self, $c) = @_;
    
    $c->stash->{is_ajax_request} = 0;
};

=head2 base

the startpoint of our ajax chain is path-prefix of the controller using us.

=cut

sub base :PathPrefix :Chained :CaptureArgs(0) {}

=head2 ajax

the relevant part of the ajax chain 'ajax'

=cut

sub ajax :Chained('base') :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{wrapper} = undef; # don't wrap
    $c->stash->{is_ajax_request} = 1;
}

=head1 AUTHOR

Wolfgang Kinkeldei, C<< <wki at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-catalyst-traitfor-controller-ajax at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Catalyst-TraitFor-Controller-Ajax>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 LICENSE AND COPYRIGHT

Copyright 2009 Wolfgang Kinkeldei.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Catalyst::TraitFor::Controller::Ajax
