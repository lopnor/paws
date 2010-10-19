package Paws::Schema::Result::User;
use strict;
use warnings;
use base 'DBIx::Class';
__PACKAGE__->load_components(qw(TimeStamp Core));
__PACKAGE__->table('user');
__PACKAGE__->add_columns(
    id => {
        data_type => 'INT',
        is_nullable => 0,
        is_auto_increment => 1,
        extra => {
            unsigned => 1,
        }
    },
    username => {
        data_type => 'VARCHAR',
        size => '255',
        is_nullable => 1,
    },
    email => {
        data_type => 'VARCHAR',
        size => '255',
        is_nullable => 1,
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
__PACKAGE__->add_unique_constraint(['username']);
__PACKAGE__->has_many('logs', 'Paws::Schema::Result::Log', 'user_id');
__PACKAGE__->has_many('issue_users', 'Paws::Schema::Result::IssueUser', 'user_id');
__PACKAGE__->many_to_many(issues => issue_users => 'issue');
__PACKAGE__->has_many('user_topics', 'Paws::Schema::Result::UserTopic', 'user_id');
__PACKAGE__->many_to_many(topics => user_topics => 'topic');

1;
