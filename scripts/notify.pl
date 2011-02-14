## Modified notify script.. edited for Awesome window manager
## Put me in ~/.irssi/scripts/autorun
##

use Irssi;
use vars qw($VERSION %IRSSI);
# all these should be replaced by settings but for now this will do
use constant false   => 0;
use constant true    => 1;
use constant len     => 50;
use constant ntime   => 4000;
use constant stime   => 0;
use constant normal_color 		=> "#FFFFFF";
use constant query_color 		=> "#FF0044";
use constant hilight_color 		=> "#9393DD";
use constant disconnect_color 	=> "#CC9393";
use constant connect_color 		=> "#7F9F7F";

$VERSION = "0.01";
%IRSSI = (
    authors     => 'Harry Delmolino',
    contact     => 'harry@anapnea.net',
    name        => 'notify.pl',
    description => 'notify Awesome WM of irssi message',
    license     => 'MIT',
);

sub sanitize {
  my ($text) = @_;
  $text =~ s/&/&amp;/g; # That could have been done better.
  $text =~ s/</&lt;/g;
  $text =~ s/>/&gt;/g;
  $text =~ s/`/&apos;/g;
  $text =~ s/'/&apos;/g;
  $text =~ s/"/&quot;/g;
  return $text;
}

sub trim {
	my ($text) = @_;
	if ( length $text > len) {
		substr ($text, len -3, length $text, "");
		$text = $text . "...";	
	} elsif (length $text < len) {
		for ($i =length $text; $i < len; $i++) {
			$text = $text . " ";
		}
	}
	return $text;
}

sub get_nick {
	my ($text) = @_;
	my $start = index($text, '<');	
	my $end = index($text, '>');
	return substr($text, $start, $end);
}

sub notify {
    my ($title, $text, $color, $sticky) = @_;
	my $time;
	if ($sticky){
		$time = stime;
	} else {
		$time = ntime;
	}
	
	my $cmd = sprintf("notify-send -t %s \"<span color='%s'>%s</span>\" \"%s\"", $time, $color, sanitize($title), sanitize(trim($text)));
	system(sprintf("%s 2>/dev/null",$cmd));
}

sub highlight {
    my ($dest, $msg, $stripped) = @_;
    my $window = Irssi::active_win();
   	
	if (($dest->{level} & MSGLEVEL_HILIGHT) && ($dest->{level} & MSGLEVEL_PUBLIC)) {
		notify($dest->{target}, $stripped, hilight_color, true);
	} elsif (($dest->{level} & MSGLEVEL_PUBLIC) && ($dest->{level} & MSGLEVEL_PUBLIC)) {
		notify($dest->{target}, $stripped, normal_color, false);
    }
}

sub query {
    my ($server, $msg, $nick, $addr) = @_;
	my $window = Irssi::active_win();
	my $itemwindow = $server->window_find_item($nick);
	if ($window->{refnum} != $itemwindow->{refnum}) {
        notify($nick, $msg, query_color, true);
    } else {
		notify($nick, $msg, query_color, false);
	}
}

sub sig_join {
    my ($server,$channel,$nick,$address) = @_;
	notify("Connected: ", $nick, connect_color, false);
}

sub sig_leave {
    my ($server,$nick,$address) = @_;
	notify("Disconnected: ", $nick, disconnect_color, false);
}

Irssi::signal_add('print text', 'highlight');
Irssi::signal_add('message private', 'query');
Irssi::signal_add_first('message join', \&sig_join);
Irssi::signal_add_first('message part', \&sig_leave);
Irssi::signal_add_first('message quit', \&sig_leave);
