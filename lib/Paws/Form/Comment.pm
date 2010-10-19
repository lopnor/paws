package Paws::Form::Comment;
use Ark 'Form';

param content => (
    type => 'TextField',
    widget => 'textarea',
    label => 'leave your comment',
);

1;
