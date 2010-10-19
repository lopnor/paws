? my ($id, $u) = @_;
? my $res = $c->model('Schema::Vote')->summary($id, $u);
? my $plus = $res->{user} ? $res->{user} > 0 ? ' user' : '' : '';
? my $minus = $res->{user} ? $res->{user} < 0 ? ' user' : '' : '';
<div class="vote" id="vote_<?= $id ?>">
VOTES
<span class="plus<?= $plus ?>">
? if ($u && $u->obj) {
    <a href="<?= $c->uri_for('vote', $id, 1) ?>" class="up" id="vote_1_<?= $id ?>">
? }
+<?= $res->{plus} ? $res->{plus} || '0' : '0' ?>
? if ($u && $u->obj) {
    </a>
? }
</span>
<span class="minus<?= $minus ?>">
? if ($u && $u->obj) {
<a href="<?= $c->uri_for('vote', $id, -1) ?>" class="down" id="vote_-1_<?= $id ?>">
? }
-<?= $res->{minus} ? $res->{minus} || '0' : '0' ?>
? if ($u && $u->obj) {
    </a>
? }
</span>
</div>
