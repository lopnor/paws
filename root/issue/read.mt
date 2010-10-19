? extends 'base';
? my $issue = $s->{item};
? block 'content' => sub {
<?= include('entry', $issue, $c->user) ?>
<? if ($c->user && $c->user->obj) { ?>
    <? my $user= $c->user->obj; ?>
    <span class="ownership">
    <? if ($issue->owned_by_user($user)) { ?>
        you are owner of this issue. <a href="<?= $c->uri_for('issue',$issue->id,'update') ?>">update issue status</a>
    <? } else { ?>
        <a href="<?= $c->uri_for('issue', $issue->id, 'ownership') ?>" class="ownership" id="ownership_<?= $issue->id ?>">take ownership</a>
    <? } ?>
    </span>
    <?= include('form', $s->{form}, 'leave your comment', $c->uri_for('/issue', $issue->id, 'comment')) ?>
<? } ?>
<? my @list = $issue->search_related('logs', {action => ['comment','update']},{order_by => 'id desc'}); ?>
<?= include('list', \@list) ?>
? };
