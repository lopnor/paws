package Paws::Schema::Result::IssueUser;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw(TimeStamp Core));
__PACKAGE__->table('issue_user');
__PACKAGE__->add_column(
    issue_id => {
        data_type => 'INT',
        is_nullable => 0,
        extra => {
            unsigned => 1,
        },
    },
    user_id => {
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

__PACKAGE__->set_primary_key('issue_id', 'user_id');
__PACKAGE__->belongs_to(issue => 'Paws::Schema::Result::Issue' => 'issue_id');
__PACKAGE__->belongs_to(user => 'Paws::Schema::Result::User' => 'user_id');

1;

