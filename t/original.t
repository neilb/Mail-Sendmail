#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 2;

# unattended Mail::Sendmail test, sends a message to the author
# but you probably want to change $mail{To} below
# to send the message to yourself.

my (%mail, $server);

# if you change your mail server, you may need to change the From:
# address below.
$mail{From} = 'Sendmail Test <sendmail@alma.ch>';

$mail{To}   = 'Sendmail Test <sendmail@alma.ch>';
#$mail{To}   = 'Sendmail Test <sendmail@alma.ch>, You me@myaddress';

# if you want to get a copy of the test mail, you need to specify your
# own server here, by name or IP address
$server = 'mail.alma.ch';
#$server = 'my.usual.mail.server';
#
BEGIN { use_ok ('Mail::Sendmail'); };
SKIP: {
skip "Network testing prohibited", 1 if $ENV{NO_NETWORK_TESTING};

print <<EOT
Test Mail::Sendmail $Mail::Sendmail::VERSION

Trying to send a message to the author (and/or whomever if you edited
t/original.t)

(The test is designed so it can be run by Test::Harness from CPAN.pm.
Edit it to send the mail to yourself for more concrete feedback. If you
do this, you also need to specify a different mail server, and possibly
a different From: address.)

Current recipient(s): '$mail{To}'

EOT
;


if ($server) {
    $mail{Smtp} = $server;
    diag "Server set to: $server\n";
}

$mail{Subject} = "Mail::Sendmail version $Mail::Sendmail::VERSION test";

$mail{Message} = "This is a test message sent with Perl version $] from a $^O system.\n\n";
$mail{Message} .= "It contains an accented letter: à (a grave).\n";
$mail{Message} .= "It was sent on " . Mail::Sendmail::time_to_date() . "\n";
$mail{'Content-Type'} = 'text/plain; charset="utf-8"';

# Go send it
print "Sending...\n";

ok (my $res = sendmail %mail);
if ($res) {
    print "content of \$Mail::Sendmail::log:\n$Mail::Sendmail::log\n";
    if ($Mail::Sendmail::error) {
        diag "content of \$Mail::Sendmail::error:\n$Mail::Sendmail::error\n";
    }
}
else {
    diag "!Error sending mail:\n$Mail::Sendmail::error\n";
    diag "Content of \$Mail::Sendmail::log:\n$Mail::Sendmail::log\n";
}
} # END OF SKIP
