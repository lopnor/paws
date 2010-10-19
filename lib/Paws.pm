package Paws;
use Ark;

our $VERSION = '0.01';

use_model 'Paws::Models';
use_plugins qw(
    Session
    Session::State::Cookie
    Session::Store::Model
    Authentication
    +Paws::OpenID
    Authentication::Store::Model
);

config 'Plugin::Session' => {
    expires => '+30d',
};

config 'Plugin::Session::Store::Model' => {
    model => 'cache',
};

config 'Plugin::Authentication::Store::Model' => {
    model => 'Schema::OpenID',
};

1;
