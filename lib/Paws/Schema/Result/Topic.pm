package Paws::Schema::Result::Topic;
use strict;
use warnings;
use base 'DBIx::Class';
use Paws::Models;

__PACKAGE__->load_components(qw(TimeStamp Core));
__PACKAGE__->table('topic');
__PACKAGE__->add_column(
    id => {
        data_type => 'INT',
        is_nullable => 0,
        is_auto_increment => 1,
        extra => {
            unsigned => 1,
        },
    },
    name => {
        data_type => 'TEXT',
        is_nullable => 0,
    },
    created_by => {
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
__PACKAGE__->belongs_to(owner => 'Paws::Schema::Result::User' => 'created_by');
__PACKAGE__->has_many(issue_topics => 'Paws::Schema::Result::IssueTopic' => 'topic_id');
__PACKAGE__->many_to_many('issues' => 'issue_topics' => 'issue');
__PACKAGE__->add_unique_constraint(['name']);
__PACKAGE__->has_many(user_topics => 'Paws::Schema::Result::UserTopic' => 'topic_id');
__PACKAGE__->many_to_many(owners => 'user_topics' => 'user');

1;
