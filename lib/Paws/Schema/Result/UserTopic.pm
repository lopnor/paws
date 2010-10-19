package Paws::Schema::Result::UserTopic;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw(TimeStamp Core));
__PACKAGE__->table('user_topic');
__PACKAGE__->add_column(
    user_id => {
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
    updated_at => {
        data_type => 'DATETIME',
        set_on_create => 1,
        set_on_update => 1,
    },
);

__PACKAGE__->set_primary_key('user_id', 'topic_id');
__PACKAGE__->belongs_to(user => 'Paws::Schema::Result::User' => 'user_id');
__PACKAGE__->belongs_to(topic => 'Paws::Schema::Result::Topic' => 'topic_id');

1;

1;
