package fbsample::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;

use Facebook::Graph;

my $fb = Facebook::Graph->new(
	app_id   => '107952149328756',
	secret   => '206c4646f84232f1673233a20f026446',
	postback => 'http://localhost:5000/callback',
);

any '/' => sub {
    my ($c) = @_;
    $c->render('index.tt');
};

get '/connect' => sub {
	my ($c) = @_;
	my $uri = $fb->authorize->extend_permissions(qw//)->uri_as_string;
	return $c->redirect($uri);
};

get '/callback' => sub {
	my ($c) = @_;
	$fb->request_access_token( $c->req->param('code') );
	my $me = $fb->fetch('me');
	$c->render('me.tt', me => $me );
};

post '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    $c->redirect('/');
};

1;
