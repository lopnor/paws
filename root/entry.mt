? my ($item, $user, $summary) = @_;
? my $is_issue = ref $item eq 'Paws::Schema::Result::Issue' ? 1 : 0;
? my $iuser = $item->user;
<div id="comment">
<? if ($summary) { ?>
<p><a href="<?= $c->uri_for('/issue', $item->id) ?>"><?= $item->summary ?></a></p>
<? } else { ?>
<p><?= raw_string $item->format_content ?></p>
<? } ?>
<span class="meta">
<? if ($is_issue) { ?> issue <? } else { ?> <?= $item->action ?> <? } ?> 
posted at <?= $item->created_at->strftime('%F %T') ?>
<? if ($iuser) { ?>
    by <a href="<?= $c->uri_for('user', $iuser->username ) ?>"><?= $iuser->username ?></a>
<? } else { ?>
    by guest
<? } ?>
<? if ($is_issue) { ?>
    status:<?= $item->status ?>
    <ul class="topics">
    <? for my $topic ($item->topics) { ?>
        <li><a href="<?= $c->uri_for('topic', $topic->name) ?>"><?= $topic->name ?></a></li>
    <? } ?>
    </ul>
<? } ?>
<?= include('vote', ($is_issue ? $item->log->id : $item->id), $user) ?>
</span>
</div>
