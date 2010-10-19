package Paws::Form::Issue::Create;
use Ark '+Paws::Form::CRUD';

param 'content' => (
    type => 'TextField',
    widget => 'textarea',
    label => 'input what you think!',
);

param 'topic' => (
    type => 'hidden',
);

1;
