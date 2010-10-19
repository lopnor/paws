? my ($list, $summary) = @_;
<ul class="list">
? for my $item (@$list) {
    <li>
    <?= include('entry', $item, $c->user, $summary) ?>
    </li>
? }
</ul>
