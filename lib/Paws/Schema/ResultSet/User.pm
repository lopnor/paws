package Paws::Schema::ResultSet::User;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';
use MIME::Base64 ();
use Paws::Models;

sub create_from_form {
    my ($self, $args) = @_;
    my $form = $args->{form};
    my $info = $args->{openid};

    my $txn_guard = $self->result_source->schema->txn_scope_guard;

    my $openid = models('Schema::OpenID')->find(
        { id => $info->{hash}->{openid_id} }
    ) or return;
    
    my $user = $self->create( $form->params );
    
    $openid->update({user_id => $user->id});

    $txn_guard->commit;

    $user;
}

1;
