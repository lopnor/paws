? extends 'base';
? block content => sub {
<ul>
? for my $item (@{$s->{list}}) { 
    <li><a href="<?= $c->uri_for('topic', $item->name) ?>"><?= $item->name ?></a>
? }
</ul>
? };
