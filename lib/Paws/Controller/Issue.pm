package Paws::Controller::Issue;
use Ark '+Paws::ControllerBase::CRUD';

after read => sub {
    my ($self, $c) = @_;
    $c->forward('add_form', 'Paws::Form::Comment');
};

sub comment :Chained('item') :PathPart('comment') :Args(0) :Form('Paws::Form::Comment') :LoginUser {
    my ($self, $c) = @_;

    if ($c->req->method eq 'POST' && $self->form->submitted_and_valid) {
        $c->model('Schema::Log')->comment($self->form);
    }
    $c->redirect($c->uri_for('/issue', $c->stash->{item}->id));
}

sub ownership :Chained('item') :PathPart('ownership') :Args(0) :Form('Paws::Form::Ownership') :LoginUser {
    my ($self, $c) = @_;

    my $issue = $c->stash->{item};
    my $user = $c->user->obj;

    if ($c->req->method eq 'POST' && $self->form->submitted_and_valid) {
        if (my $ownership = $issue->issue_users({user_id => $user->id})->first) {
            $ownership->delete;
        } else {
            $issue->add_to_owners($user);
        }
    }
    $c->stash->{json} = {
        id => $issue->id,
        user_id => $user->id,
        ownership => $issue->owners->count({user_id => $user->id}) ? 1 : 0
    };
    $c->forward($c->view('JSON'));
}

around update => sub {
    my ($next, $self, $c) = @_;

    {
        my $user = $c->user or last;
        $user->obj or last;
        $c->stash->{item}->owned_by_user($user->obj) or last;
        $next->($self, $c);
        return;
    }
    $c->res->status(403);
    $c->res->body('403 Forbidden');
};

1;
