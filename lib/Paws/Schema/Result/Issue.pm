package Paws::Schema::Result::Issue;
use strict;
use warnings;
use utf8;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw(TimeStamp Core));
__PACKAGE__->table('issue');
__PACKAGE__->add_column(
    id => {
        data_type => 'INT',
        is_nullable => 0,
        is_auto_increment => 1,
        extra => {
            unsigned => 1,
        },
    },
    status => {
        data_type => 'VARCHAR',
        size => '16',
        is_nullable => 0,
        default_value => 'open',
    },
    user_id => {
        data_type => 'INT',
        is_nullable => 1,
        extra => {
            unsigned => 1,
        },
    },
    created_at => {
        data_type => 'DATETIME',
        set_on_create => 1,
    },
    updated_at => {
        data_type => 'DATETIME',
        set_on_create => 1,
        set_on_update => 1,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(user => 'Paws::Schema::Result::User' => 'user_id');
__PACKAGE__->has_many(logs => 'Paws::Schema::Result::Log' => 'issue_id');
__PACKAGE__->has_many(issue_topics => 'Paws::Schema::Result::IssueTopic' => 'issue_id');
__PACKAGE__->many_to_many(topics => 'issue_topics' => 'topic');
__PACKAGE__->has_many(issue_users => 'Paws::Schema::Result::IssueUser' => 'issue_id');
__PACKAGE__->many_to_many(owners => 'issue_users' => 'user');

sub log { shift->search_related('logs', {action => 'issue'})->first }
sub format_content { shift->log->format_content }
sub summary { shift->log->summary }

sub owned_by_user {
    my ($self, $user) = @_;
    $self->owners->count({id => $user->id}) and return 1;
    for ($self->topics) {
        $_->owners->count({id => $user->id}) and return 1;
    }
    return 0;
}

1;
