package Paws::Controller::User;
use Ark 'Controller';
with 'Ark::ActionClass::Form';

sub auto :Private {
    1;
}

sub item :Chained :PathPart('user') :CaptureArgs(1) {
    my ($self, $c, $username) = @_;
    my $item = $c->model('Schema::User')->find(
        {
            username => $username,
        }
    );
    if ($item) {
        $c->stash->{item} = $item;
    } else {
        $c->res->status(404);
        $c->res->body('not found');
        $c->detach;
    }
}

sub read :Chained('item') :PathPart('') :Args(0) {}

1;
