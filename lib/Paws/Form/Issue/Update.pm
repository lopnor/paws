package Paws::Form::Issue::Update;
use Ark '+Paws::Form::CRUD';

param 'comment' => (
    type => 'TextField',
    widget => 'textarea',
    label => 'comment',
);

param 'status' => (
    type => 'ChoiceField',
    choices => [
        'open', 'open',
        'fixed', 'fixed', 
        'reject', 'reject', 
        'dumplicate', 'duplicate'
    ],
    widget => 'select',
);

1;
