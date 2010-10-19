package Paws::ControllerBase::CRUD;
use Ark 'Controller';
with
    'Paws::ActionClass::LoginUser',
    'Ark::ActionClass::Form',
    'Paws::ActionClass::CreateToken';

use Encode;
use Digest::SHA1;


has model => (
    is => 'ro',
    isa => 'Str',
    default => sub {
        my $self = shift;
        my ($class) = ( ref($self) =~ m{::([^:]+)$} );
        "Schema::$class";
    }
);

has need_login => ( is => 'ro', isa => 'Bool', default => sub {0} );
has private => ( is => 'ro', isa => 'Bool', default => sub {0} );
has key_column => ( is => 'ro', isa => 'Str', default => 'id' );

sub _parse_NeedLoginCheck_attr {
    my ($self, $name, $value) = @_;
    return LoginUser => $self->need_login;
}

sub _parse_PathPrefix_attr {
    my ($self, $name, $value) = @_;
    return PathPart => $self->namespace;
}

sub _parse_AutoForm_attr {
    my ($self, $name, $value) = @_;
    my $class = ref($self);
    $class =~ s/Controller/Form/;
    $class .= "::".ucfirst($name);

    return Form => $class;
}

sub auto :Private :NeedLoginCheck :CreateToken { 1 }

sub index :Path :Args(0) {
    my ($self, $c) = @_;
    $c->stash->{list} = [
        $c->model($self->model)->search(
            {
                ($self->need_login ? (user_id => $c->user->obj->id) : ())
            }
        )
    ];
}

sub create :Local :AutoForm :Args(0) {
    my ($self, $c) = @_;

    if ($c->req->method eq 'POST' and $self->form->submitted_and_valid) {
        my $item = $c->model($self->model)->create_from_form(
            $self->form
        );
        $c->redirect( $c->uri_for($self->namespace, $item->get_column($self->key_column)) );
    }
    $self->form->fill({token => $c->stash->{token}});
}

sub item :Chained :PathPrefix :CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    $id = Encode::decode('utf8', $id);
    
    $c->stash->{item} = $c->model($self->model)->search(
        {
            ($self->need_login ? (user_id => $c->user->obj->id) : ()),
            $self->key_column, $id,
        }
    )->first;
    unless ($c->stash->{item}) {
        $c->res->status(404);
        $c->res->body('not found');
        $c->detach;
    }
}

sub read :Chained('item') :PathPart('') :Args(0) {}

sub update :Chained('item') :PathPart('update') :AutoForm :Args(0) {
    my ($self, $c) = @_;
    my $form = $self->form;
    my $item = $c->stash->{item};

    if ($c->req->method eq 'POST' and $form->submitted_and_valid) {
        $c->model($self->model)->update_by_form($item, $form);
        $c->redirect( $c->uri_for($self->namespace, $item->id) );
    }
    $form->fill(
        {
            $item->get_columns,
            token => $c->stash->{token},
        }
    );
}

sub delete :Chained('item') :PathPart('delete') :AutoForm :Args(0) {
    my ($self, $c) = @_;
    if ($c->req->method eq 'POST' and $self->form->submitted_and_valid) {
        $c->stash->{item}->delete;
        $c->redirect( $c->uri_for($self->namespace) );
    }
    $self->form->fill({token => $c->stash->{token}});
}

sub add_form :Private {
    my ($self, $c, $form_class) = @_;

    $c->ensure_class_loaded($form_class);
    my $form = $form_class->new($c->request, $c);
    $self->form($form);
    $c->stash->{form} = $form;
}

1;
