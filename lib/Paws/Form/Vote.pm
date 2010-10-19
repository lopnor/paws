package Paws::Form::Vote;
use Ark 'Form';

param 'value' => (
    type => 'ChoiceField',
    choices => ['-1', '1'],
    widget => 'radio',
);

1;
