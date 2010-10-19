? extends 'base';
? my $user = $s->{item};
? block 'content' => sub {
<?= $user->username ?>
<?= include('list', [ $user->issues ], 'summary') ?> 
? };
