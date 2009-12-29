use Test::More 'no_plan'; #tests => 24;
use Test::Exception;
use Catalyst ();
use FindBin;
#use Path::Class::File;
#use lib "$FindBin::Bin/lib";

use_ok( 'Catalyst::TraitFor::Controller::Ajax' );

# setup our Catalyst :-)
my $c = Catalyst->new();
$c->setup_log();
$c->setup_home("$FindBin::Bin");


# CASE 1: try to create a controller w/o begin action
{
    package TestApp::Controller::NoBegin;
    use Moose;
    BEGIN { extends 'Catalyst::Controller' }
    with 'Catalyst::TraitFor::Controller::Ajax';
    
    ### we do not have a begin method inside our class
}

# setup our component w/o own begin() action
my $no_begin;
delete $c->stash->{is_ajax_request};
lives_ok { $no_begin = $c->setup_component('TestApp::Controller::NoBegin') } 'setup no-begin component worked';
can_ok($no_begin => qw(begin base ajax));
ok(!exists($c->stash->{is_ajax_request}), 'is_ajax_request stash entry not present');

lives_ok { $no_begin->begin($c); } 'begin() can get called';
is($c->stash->{is_ajax_request}, 0, 'is_ajax_request is 0');

lives_ok { $no_begin->ajax($c); } 'ajax() can get called';
is($c->stash->{is_ajax_request}, 1, 'is_ajax_request is 1');


# CASE 2: try to create a controller w/ begin action
{
    package TestApp::Controller::HasBegin;
    use Moose;
    BEGIN { extends 'Catalyst::Controller' }
    with 'Catalyst::TraitFor::Controller::Ajax';
    
    ### we have a begin method inside our class
    sub begin :Private {
        my ($self, $c) = @_;
        
        $c->stash->{just_nonsense} = '42';
    }
}

# setup our component w/ its own begin() action
my $has_begin;
delete $c->stash->{is_ajax_request};
delete $c->stash->{just_nonsense};

lives_ok { $has_begin = $c->setup_component('TestApp::Controller::HasBegin') } 'setup has-begin component worked';
can_ok($has_begin => qw(begin base ajax));
ok(!exists($c->stash->{is_ajax_request}), 'is_ajax_request stash entry not present');

lives_ok { $has_begin->begin($c); } 'begin() can get called';
is($c->stash->{is_ajax_request}, 0, 'is_ajax_request is 0');
is($c->stash->{just_nonsense}, 42, 'our begin() has been called');

lives_ok { $has_begin->ajax($c); } 'ajax() can get called';
is($c->stash->{is_ajax_request}, 1, 'is_ajax_request is 1');


# CASE 3: a controller that fails
{
    package TestApp::Controller::WillFail;
    use Moose;
    BEGIN { extends 'Catalyst::Controller' }
    BEGIN { with 'Catalyst::TraitFor::Controller::Ajax' } ### WRONG!!!
    
    ### we have a begin method inside our class
    sub begin :Private {
        my ($self, $c) = @_;
        
        $c->stash->{dummy_value} = '42';
    }
}

# setup our FAILING component w/ its own begin() action
my $will_fail;
delete $c->stash->{is_ajax_request};
delete $c->stash->{dummy_value};

lives_ok { $will_fail = $c->setup_component('TestApp::Controller::WillFail') } 'setup will-fail component worked';
can_ok($will_fail => qw(begin base ajax));
ok(!exists($c->stash->{is_ajax_request}), 'is_ajax_request stash entry not present');

lives_ok { $will_fail->begin($c); } 'begin() can get called';
ok(!exists($c->stash->{is_ajax_request}), 'is_ajax_request is not set to 0');
is($c->stash->{dummy_value}, 42, 'our begin() was called');

lives_ok { $will_fail->ajax($c); } 'ajax() can get called';
is($c->stash->{is_ajax_request}, 1, 'is_ajax_request is 1');

