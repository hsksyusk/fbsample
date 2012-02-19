package fbsample::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;

use LWP::Protocol::https;
use Facebook::Graph;
use JSON qw(decode_json);

#my $fb = Facebook::Graph->new(
#	app_id   => '107952149328756',
#	secret   => '206c4646f84232f1673233a20f026446',
#	postback => 'http://fbsample-hsksyusk.dotcloud.com/callback',
#);

any '/' => sub {
    my ($c) = @_;
	my $data;
	my $token = $c->session->get('token');
	if( $token ) { #loggedin
		my $ua = LWP::UserAgent->new();
		my $res = $ua->get("https://graph.facebook.com/me/home?access_token=${token}");
		$res->is_success or die $res->status_line;
		$data = decode_json($res->decoded_content);
	}
	$c->render(
		'index.tt',
		{
			name => $c->session->get('name'),
			data => $data->{data},
		}
	);
};

any '/fbpage' => sub {
    my ($c) = @_;
	my $data;
	my $token = $c->session->get('token');
	if( $token ) { #loggedin
		my $ua = LWP::UserAgent->new();
		my $res = $ua->get("https://graph.facebook.com/me/home?access_token=${token}");
		$res->is_success or die $res->status_line;
		$data = decode_json($res->decoded_content);
	}
	$c->render(
		'fbpage.tt',
		{
			name => $c->session->get('name'),
			data => $data->{data},
		}
	);
};

=pod
get '/fbpage' => sub {
	my ($c) = @_;
	my $uri = $fb->authorize->extend_permissions(qw//)->uri_as_string;
	if(my $code = $c->req->param('code')) {
		$fb->request_access_token( $c->req->param('code') );
		my $me = $fb->fetch('hsksyusk');
		$c->render('me.tt', me => $me );
	}
	else {
		$c->render('auth_script.tt', uri=>$uri );
	}
};

get '/connect' => sub {
	my ($c) = @_;
	my $uri = $fb->authorize->extend_permissions(qw//)->uri_as_string;
	return $c->redirect($uri);
};

get '/callback' => sub {
	my ($c) = @_;
	$fb->request_access_token( $c->req->param('code') );
	my $me = $fb->fetch('hsksyusk');
	$c->render('me.tt', me => $me );
};
=cut
post '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    $c->redirect('/');
};

1;
