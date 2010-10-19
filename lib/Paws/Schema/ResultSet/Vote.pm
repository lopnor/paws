package Paws::Schema::ResultSet::Vote;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub summary {
    my ($self, $log_id, $user) = @_;

    my $res = {};
    if ($user && $user->obj) {
        my $vote = $self->search(
            {
                log_id => $log_id,
                user_id => $user->obj->id,
            }
        )->first;
        $res->{user} = $vote->value if $vote;
    }
    my @sum = $self->search(
        {
            log_id => $log_id,
        },
        {
            select => [
                {count => '*'},
                'value'
            ],
            as => [qw(count value)],
            group_by => ['value'],
        }
    )->all;
    for (@sum) {
        my $c = $_->get_column('count');
        my $v = $_->get_column('value');
        $res->{$v > 0 ? 'plus' : 'minus'} = $c;
        $res->{total} += $v * $c;
    }
    $res;
}

sub create_from_form {
    my ($self, $form) = @_;
    my $c = $form->context;
    my $user = $c->user->obj if $c->user;
    my $log = $c->stash->{item};

    my $txn_guard = $self->result_source->schema->txn_scope_guard;

    my $vote = $self->search(
        {
            user_id => $user->id,
            log_id => $log->id,
        }
    )->first;
    if ($vote) {
        $vote->update({value => $form->param('value')});
    } else {
        $vote = $self->create(
            {
                value => $form->param('value'),
                user_id => $user->id,
                log_id => $log->id,
            }
        );
    }

    $txn_guard->commit;

    $vote;
}

1;
