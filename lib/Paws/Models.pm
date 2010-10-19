package Paws::Models;
use strict;
use warnings;
use Ark::Models '-base';

register Schema => sub {
    my $self = shift;
    my $conf = $self->get('conf')->{database}
        or die 'database config needed!';
    $self->ensure_class_loaded('Paws::Schema');
    Paws::Schema->connect(@$conf);
};

for my $table (qw(User OpenID Issue Topic Vote Log)) {
    register "Schema::$table" => sub {
        my $self = shift;
        $self->get('Schema')->resultset($table);
    }
}

register cache => sub {
    my $self = shift;
    my $conf = $self->get('conf')->{cache}
        or die 'requires cache config';

    $self->ensure_class_loaded('Cache::FastMmap');
    Cache::FastMmap->new(%$conf);
};

1;
