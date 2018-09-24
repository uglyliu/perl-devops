use Mojolicious::Lite;



#首页
get '/' => sub ($c) {
  	$c->render(template => '');
};

websocket '/channel' => sub {
  my $c = shift;

  $c->inactivity_timeout(3600);


  $c->on(message => sub {
    	my ($c, $msg) = @_;
    	$c->send("echo: $msg");
  });

  $c->on(finish => sub {
    	my ($c, $code, $reason) = @_;
    	$c->app->log->debug("WebSocket closed with status $code");
  });
};

app->start;
__DATA__