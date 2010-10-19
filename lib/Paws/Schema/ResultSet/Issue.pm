package Paws::Schema::ResultSet::Issue;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub create_from_form {
    my ($self, $form) = @_;
    my $c = $form->context;
    my $user = $c->user;

    my $txn_guard = $self->result_source->schema->txn_scope_guard;

    my $params = $form->params;
    delete $params->{token};
    my $topicname = delete $params->{topic};
    my $content = delete $params->{content};

    my $issue = $self->create(
        {
            $user ? ( user_id => $user->obj->id ) : (),
            %$params,
        }
    );
    $issue->add_to_logs(
        {
            action => 'issue',
            content => $content,
            $user ? ( user_id => $user->obj->id ) : (),
        }
    );
    if ($topicname) {
        my $topic = $c->model('Schema::Topic')->find_or_create(
            {name => $topicname}
        );
        $issue->add_to_topics($topic);
    }
    $issue->add_to_owners($user->obj) if $user && $user->obj;

    $txn_guard->commit;

    $issue;
}

sub update_by_form {
    my ($self, $item, $form) = @_;
    my $user = $form->context->user;

    my $txn_guard = $self->result_source->schema->txn_scope_guard;

    $item->update(
        {
            status => $form->param('status'),
        }
    );
    $item->add_to_logs(
        {
            action => 'update',
            content => $form->param('comment'),
            user_id => $user->obj->id,
        }
    );

    $txn_guard->commit;

    $item;
}

1;
