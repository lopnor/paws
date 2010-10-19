package Paws::ActionClass::LoginUser;
use Any::Moose '::Role';

around ACTION => sub {
    my ($next, $self, $action, $c, @args) = @_;

    if ($action->attributes->{LoginUser}->[0]) {
#        my $c = $self->context;
        
        my $user = $c->user;
        unless ($user) {
            $c->session->set(nexturl => $c->req->uri);
            $c->redirect($c->uri_for('/account/login'));
            return;
        }
        unless ($user->obj) {
            $c->session->set(nexturl => $c->req->uri);
            $c->redirect($c->uri_for('/account/setup'));
            return;
        }
    }

    $next->($self, $action, $c, @args);
};

sub _parse_LoginUser_attr {
    my ($self, $name, $value) = @_;
    return LoginUser => 1;
}

1;
