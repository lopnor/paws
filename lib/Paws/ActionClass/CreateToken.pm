package Paws::ActionClass::CreateToken;
use Any::Moose '::Role';

before ACTION => sub {
    my ($self, $action, $c, @args) = @_;

    if ($action->attributes->{CreateToken}->[0]) {
        my $now = time;
        my @arr = grep {
            $_->{expire} > $now
        } @{$c->session->get('__crud_token') || []};
        my $expire = time + 300;
        my $token = Digest::SHA1::sha1_hex(time, {}, $$, rand);
        push @arr, {token => $token, expire => $expire};
        $c->session->set('__crud_token', \@arr);
        $c->stash->{token} = $token;
    }
};

sub _parse_CreateToken_attr {
    my ($self, $name, $value) = @_;
    return CreateToken => 1;
}

1;
