package Paws::Controller::Root;
use Ark 'Controller';
with 
    'Ark::ActionClass::Form',
    'Paws::ActionClass::CreateToken';

use Paws::Models;

has '+namespace' => default => '';

# default 404 handler
sub default :Path :Args {
    my ($self, $c) = @_;

    $c->res->status(404);
    $c->res->body('404 Not Found');
}

sub index :Path :Args(0) :Form('Paws::Form::Issue::Create') :CreateToken {
    my ($self, $c) = @_;

    my @list = models('Schema::Issue')->search(
        {},
        {
            order_by => 'id desc',
            rows => 20,
            page => $c->req->param('page') || 1,
        }
    );

    $self->form->fill({token => $c->stash->{token}});
    $c->stash->{list} = \@list;
}

sub end :Private {
    my ($self, $c) = @_;
    unless ($c->res->body || $c->res->status =~ /^3\d{2}$/) {
        $c->forward($c->view('MT'));
    }
}

1;
