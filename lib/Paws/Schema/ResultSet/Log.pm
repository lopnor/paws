package Paws::Schema::ResultSet::Log;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub comment {
    my ($self, $form) = @_;
    my $c = $form->context;
    my $user = $c->user->obj;
    my $issue = $c->stash->{item};
    my $params = $form->params;

    my $txn_guard = $self->result_source->schema->txn_scope_guard;

    my $comment = $self->create(
        {
            action => 'comment',
            user_id => $user->id,
            issue_id => $issue->id,
            content => $params->{content},
        }
    );
    
    $txn_guard->commit;

    $comment;
}

1;
