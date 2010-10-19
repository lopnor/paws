package Paws::OpenID;
use Ark::Plugin 'Auth';

has cred_openid_user_field => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        my $self = shift;
        $self->class_config->{user_field} || 'url';
    },
);

# XXX: need to ponder re-designing
around authenticate => sub {
    my $prev = shift->(@_);
    return $prev if $prev;

    my ($self, $info) = @_;

    my $c = $self->context;

    my $claimed_uri = $c->req->method eq 'GET'
        ? $c->req->query_parameters->{openid_identifier}
        : $c->req->body_parameters->{openid_identifier};

    unless ($claimed_uri or $c->req->param('openid-check')) {
        return;
    }

    # my job
    $self->ensure_class_loaded('Net::OpenID::Consumer');
#    $self->ensure_class_loaded('LWPx::ParanoidAgent');
    $self->ensure_class_loaded('LWP::UserAgent');

    my $secret = $self->class_config->{consumer_secret} || do {
        my $s = join '+', __PACKAGE__,
            ref( $self->app ), sort keys %{ $self->app->config };
        $s = substr($s, 0, 255) if length $s > 255;
        $s;
    };

    my $csr = Net::OpenID::Consumer->new(
#        ua              => LWPx::ParanoidAgent->new,
        ua              => LWP::UserAgent->new,
        args            => $c->req->parameters->mixed,
        consumer_secret => $secret,
    );

    if ($claimed_uri) {
        my $current = $c->uri_for( $c->req->uri->path );

        my $identity = $csr->claimed_identity($claimed_uri)
            or die $csr->err;

        # email and nickname!
        $identity->set_extension_args(
            "http://openid.net/extensions/sreg/1.1",
            {required => join(",", qw/email nickname/)}
        );

        my $check_url = $identity->check_url(
            return_to      => $current . '?openid-check=1',
            trust_root     => $current,
            delayed_return => 1,
        );
        $c->redirect_and_detach($check_url);
    }
    elsif ($c->req->param('openid-check')) {
        if (my $setup_url = $csr->user_setup_url) {
            $c->redirect_and_detach($setup_url);
        }
        elsif ($csr->user_cancel) {
        }
        elsif (my $identity = $csr->verified_identity) {
            warn $identity;
            my $user = +{ map { $_ => scalar $identity->$_ }
                    qw(url display rss atom foaf declared_rss
                       declared_atom declared_foaf foafmaker) };

            my $user_obj = $self->find_user(
                $user->{ $self->cred_openid_user_field }, $user
            );

            if ($user_obj) {
                $self->persist_user($user_obj);
                return $user_obj;
            }
        }
    }

    return;
};

1;
