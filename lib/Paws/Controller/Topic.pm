package Paws::Controller::Topic;
use Ark '+Paws::ControllerBase::CRUD';

#has need_login => default => 1;
has key_column => default => 'name';

after read => sub {
    my ($self, $c) = @_;
    $c->forward('add_form', 'Paws::Form::Issue::Create');
    $self->form->fill(
        {
            topic => $c->stash->{item}->name,
            token => $c->stash->{token},
        }
    );
};

sub ownership :Chained('item') :PathPart('ownership') :Args(0) :LoginUser :Form('Paws::Form::Ownership') {
    my ($self, $c) = @_;
    my $topic = $c->stash->{item};
    my $user = $c->user->obj;

    if ($c->req->method eq 'POST' && $self->form->submitted_and_valid) {
        if (my $ownership = $topic->user_topics({user_id => $user->id})->first) {
            $ownership->delete;
        } else {
            $topic->add_to_owners($user);
        }
    }
    $c->stash->{json} = {
        id => $topic->id,
        user_id => $user->id,
        ownership => $topic->owners->count({user_id => $user->id}) ? 1 : 0
    };
    $c->forward($c->view('JSON'));
}

1;
