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
    BEGIN { extends 'Catalyst::Controller' }      # needed to allow Attributes
    with 'Catalyst::TraitFor::Controller::Ajax';  # no BEGIN{} here!!!
    
    # URL will be '/somecontroller/ajax/my_ajax_action
    sub my_ajax_action :Chained('ajax') :Args(0) {
        # ...
    }

=head1 DESCRIPTION

Chaining an action from 'ajax' will generate an URL like
C</somecontroller/ajax/my_action>. Additionally, a stash variable
C<is_ajax_request> is set to 0/1 depending on this chain has been used.

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

=head1 CAVEATS

=head2 begin() misbehaves if trait loaded inside a C<BEGIN> block

When using Attributes in your controller -- which is a usual case, you often
put the C<extends()> statement inside a C<BEGIN> block like this:

    package MyApp::Controller::MyController;
    BEGIN { extends 'Catalyst::Controller' }
    BEGIN { with 'Catalyst::TraitFor::Controller::Ajax'; } ### WRONG!
    
    sub begin :Private {
        # ...
    }
    
    # ... more code

What is wrong with the code above? Well, inside our Trait class we do some
tricks with the C<begin()> action mathod. These tricks only work if the
C<with()> statement is not put into a C<BEGIN> block.

=head1 AUTHOR

Wolfgang Kinkeldei, C<< <wki at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-catalyst-traitfor-controller-ajax at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Catalyst-TraitFor-Controller-Ajax>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 LICENSE AND COPYRIGHT

Copyright 2009 Wolfgang Kinkeldei.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Catalyst::TraitFor::Controller::Ajax
