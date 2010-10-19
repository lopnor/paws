package Paws::Schema::ResultSet::Topic;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub create_from_form {
    my ($self, $form) = @_;
    my $c = $form->context;
    $c->user && $c->user->obj or return;
    my $user = $c->user->obj;

    my $txn_guard = $self->result_source->schema->txn_scope_guard;

    my $item = $self->create(
        {
            name => $form->param('name'),
            created_by => $user->id,
        }
    );
    $item->add_to_owners($user);

    $txn_guard->commit;

    $item;
}

1;
