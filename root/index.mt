? extends 'base';
? block 'content' => sub {
<?= include('form', $s->{form}, 'submit', $c->uri_for('/issue/create') ) ?>
<?= include('list', $s->{list}, 'summary') ?> 
? };
