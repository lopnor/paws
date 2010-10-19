package Paws::Form::CRUD;
use Ark 'Form';

param 'token' => (
    type => 'hidden',
);

sub custom_validation {
    my ($self, $form) = @_;
    my $param = $form->param('token')
        or $form->set_error('token' => 'NOT_NULL') and return;
    my $session = $self->context->session;
    my $token = $session->get('__crud_token') || [];
    my $time = time;

    my $ok = grep { $_->{token} eq $param && $_->{expire} > $time } @$token;

    $session->set(
        '__crud_token', 
        [ grep { $_->{token} ne $param && $_->{expire} > $time } @$token ]
    );

    $ok or $form->set_error('token' => 'NOT_NULL');
}

1;
