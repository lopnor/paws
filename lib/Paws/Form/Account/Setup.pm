package Paws::Form::Account::Setup;
use Ark 'Form';
use Paws::Models;

param 'username' => (
    label => 'Username',
    type  => 'text',
    constraints => [
        'NOT_NULL',
        ['LENGTH', 0, 255],
    ],
);

param 'email' => (
    label => 'Email',
    type => 'EmailField',
);

sub custom_validation {
    my ($self, $form) = @_;

    models('Schema::User')->find({username => $form->param('username') || ''})
        and $form->set_error( username => 'DUPLICATE' );
}

sub messages {
    return {
        %{ shift->SUPER::messages },
        'username.duplicate' => 'This username has already taken.',
    };
}

1;
