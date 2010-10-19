package Paws::Schema::Result::Log;
use strict;
use warnings;
use utf8;
use base 'DBIx::Class';
use Paws::Models;
use String::Filter;
use HTML::Entities qw(encode_entities);

__PACKAGE__->load_components(qw(TimeStamp Core));
__PACKAGE__->table('comment');
__PACKAGE__->add_column(
    id => {
        data_type => 'INT',
        is_nullable => 0,
        is_auto_increment => 1,
        extra => {
            unsigned => 1,
        },
    },
    issue_id => {
        data_type => 'INT',
        is_nullable => 0,
        extra => {
            unsigned => 1,
        },
    },
    action => {
        data_type => 'VARCHAR',
        size => 255,
    },
    content => {
        data_type => 'TEXT',
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
__PACKAGE__->belongs_to(issue => 'Paws::Schema::Result::Issue' => 'issue_id');
__PACKAGE__->has_many(votes => 'Paws::Schema::Result::Vote' => 'log_id');

my $sf = String::Filter->new(
    rules => [
        '[\r\n]+' => sub {
            my $r = shift;
            "<br/>\n";
        },
        'http://[A-Za-z0-9_\\-\\~\\.\\%\\?\\#\\@/]+',
        sub {
            my $url = shift;
            sprintf(
                '<a href="%s">%s</a>',
                encode_entities($url),
                encode_entities($url),
            );
        },
    ],
    default_rule => sub {
        my $text = shift;
        encode_entities($text);
    },
);

sub format_content {
    my ($self) = @_;
    my $content = $self->content;
    $sf->filter($self->content);
}

sub summary {
    my ($self, $length) =@_;
    $length ||= 140;
    my $content = $self->content;
    length $content > $length ?  substr($content, 0, $length) . '...' : $content;
}

1;
