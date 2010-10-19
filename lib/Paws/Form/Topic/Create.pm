package Paws::Form::Topic::Create;
use Ark '+Paws::Form::CRUD';

param 'name' => (
    label => 'tag',
    type => 'TextField',
);

1;
