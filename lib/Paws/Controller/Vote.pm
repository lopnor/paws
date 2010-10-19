package Paws::Controller::Vote;
use Ark 'Controller';
with 'Paws::ActionClass::LoginUser',
    'Ark::ActionClass::Form';

sub auto :Private :LoginUser {1}

sub vote :Path :Args(2) :Form('Paws::Form::Vote') {
    my ($self, $c, $logid, $value) = @_;

    $c->stash->{item} = $c->model('Schema::Log')->find($logid);

    my $model = $c->model('Schema::Vote');
    if ($c->req->method eq 'POST' && $self->form->submitted_and_valid) {
        $model->create_from_form($self->form);
    }
    $c->stash->{json} = $model->summary(
        $c->stash->{item}->id,
        $c->user,
    );
    $c->forward($c->view('JSON'));
}

1;
