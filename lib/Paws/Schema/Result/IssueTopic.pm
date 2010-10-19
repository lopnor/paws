package Paws::Schema::Result::IssueTopic;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw(TimeStamp Core));
__PACKAGE__->table('issue_topic');
__PACKAGE__->add_column(
    issue_id => {
        data_type => 'INT',
        is_nullable => 0,
        extra => {
            unsigned => 1,
        },
    },
    topic_id => {
        data_type => 'INT',
        is_nullable => 0,
        extra => {
            unsigned => 1,
        },
    },
    created_at => {
        data_type => 'DATETIME',
        set_on_create => 1,
    },
);
__PACKAGE__->set_primary_key('issue_id', 'topic_id');
__PACKAGE__->belongs_to(issue => 'Paws::Schema::Result::Issue' => 'issue_id');
__PACKAGE__->belongs_to(topic => 'Paws::Schema::Result::Topic' => 'topic_id');

1;
