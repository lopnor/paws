? extends 'base';
? block content => sub {
<?= include('form', $s->{form}, 'post entry with this tag', $c->uri_for('/issue/create') ) ?>
<? if (my $u = $c->user && $c->user->obj) { ?>
    <span class="ownership">
    <? if ($s->{item}->owners->search({id => $u->id})->first) { ?>
    you are owner of issues with this topic.
    <a class="ownership" id="topic_<?= $s->{item}->id ?>" href="<?= $c->uri_for('/topic', $s->{item}->name, 'ownership') ?>">switch off</a>
    <? } else { ?>
    <a class="ownership" id="topic_<?= $s->{item}->id ?>" href="<?= $c->uri_for('/topic', $s->{item}->name, 'ownership') ?>">take ownership of issues with this topic automatically</a>
    <? } ?>
    </span>
<? } ?>
<?= include('list', [ $s->{item}->issues ], 'summary' ) ?> 
? }
