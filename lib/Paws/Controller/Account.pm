package Paws::Controller::Account;
use Ark 'Controller';
with 
    'Ark::ActionClass::Form',
    'Paws::ActionClass::LoginUser';

sub login :Local :Form('Paws::Form::Account::Login') {
    my ($self, $c) = @_;

    if (my $info = $c->authenticate) {
        if ($info->obj) {
            $c->redirect($c->session->remove('nexturl') || $c->uri_for('/'));
        } else {
            $c->redirect($c->uri_for('/account/setup'));
        }
        $c->detach;
    }
}

sub logout :Local {
    my ($self, $c) = @_;
    $c->logout;
    $c->redirect($c->session->remove('nexturl') || $c->uri_for('/'));
}


sub setup :Local :Form('Paws::Form::Account::Setup') {
    my ($self, $c) = @_;

    my $user = $c->user;
    unless ($user) {
        $c->redirect($c->uri_for('/account/login'));
        $c->detach;
    }
    if ($user->obj) {
        $c->redirect($c->uri_for('/account/settings'));
        $c->detach;
    }

    if ($c->req->method eq 'POST' and $self->form->submitted_and_valid) {
        $c->model('Schema::User')->create_from_form(
            {
                openid => $user,
                form => $self->form,
            }
        );
        $c->redirect($c->session->remove('nexturl') || $c->uri_for('/'));
    }
}

sub settings :Local :Form('Paws::Form::Account::Settings') :LoginUser {
    my ($self, $c) = @_;

    my $user = $c->user->obj;

    if ($c->req->method eq 'POST' and $self->form->submitted_and_valid) {
        $user->update( $self->form->params );
    }
    $self->form->fill({$user->get_columns});
}

1;
