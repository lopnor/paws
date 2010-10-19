<html>
    <head>
        <title><? block title => 'paws' ?></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <link rel="stylesheet" href="<?= $c->uri_for('/css/base.css') ?>" type="text/css" media="all" />
? if ($s->{token}) {
        <script type="text/javascript">document.paws_token = '<?= $s->{token} ?>';</script>
? }
        <script src="<?= $c->uri_for('/js/jquery.min.js') ?>" type="text/javascript"></script>
        <script src="<?= $c->uri_for('/js/paws.js') ?>" type="text/javascript"></script>
    </head>
    <body>
    <div id="container">
    <div id="header">
? block header => sub {
<a href="<?= $c->uri_for('/') ?>"><img src="<?= $c->uri_for('/images/logo.png') ?>" /></a>
<ul>
? if (my $user = $c->user) {
    <li>hello, <?= $user->obj ? $user->obj->username : 'new user' ?>!</li>
? } else {
    <li>hello, guiest!</li>
? }
    <li><a href="<?= $c->uri_for('/topic') ?>">topics</a></li>
? if (my $user = $c->user) {
    <li><a href="<?= $c->uri_for('/account/settings') ?>">settings</a></li>
    <li><a href="<?= $c->uri_for('/account/logout') ?>">logout</a></li>
? } else {
    <li><a href="<?= $c->uri_for('/account/login') ?>">login</a></li>
? }
</ul>
? };
    </div>
    <div id="content">
? block content => '';
    </div>
    <div id="footer">
? block footer => sub {
   <ul><li><a href="http://soffritto.org/">by Soffritto Inc.</a></li><ul>
? };
    </div>
    </div>
    </body>
</html>
