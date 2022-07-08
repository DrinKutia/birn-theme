#!/usr/bin/perl -w
#
# HandleMail.t:
# Tests for the HandleMail functions
#
#  Copyright (c) 2009 UK Citizens Online Democracy. All rights reserved.
# Email: louise@mysociety.org; WWW: http://www.mysociety.org/

use strict;
use warnings; 

use Test::More tests => 317;

# Horrible boilerplate to set up appropriate library paths.
use FindBin;
use lib "$FindBin::Bin/../../../perllib";
#---------------------------------

sub create_test_message($){
    my $message_file = shift;
    open FILE, "<", "examples/" . $message_file or die $!;
    # my @lines = <FILE>;
    my @lines = ();
    my $line;
    while ($line = <FILE>) {
        chomp $line;
        push @lines, $line;
    }
    return @lines;
}

#---------------------------------

sub parse_dsn_bounce($){
    my $message_file = shift;
    my @lines = create_test_message($message_file);
    return mySociety::HandleMail::parse_dsn_bounce(\@lines);
}

#---------------------------------

sub parse_ill_formed_dsn_bounce($){
    my $message_file = shift;
    my @lines = create_test_message($message_file);
    return mySociety::HandleMail::parse_ill_formed_dsn_bounce(\@lines);
}

#---------------------------------

sub parse_mdn_bounce($){
    my $message_file = shift;
    my @lines = create_test_message($message_file);
    return mySociety::HandleMail::parse_mdn_bounce(\@lines);
}
#---------------------------------

sub parse_arf_mail($){
    my $message_file = shift;
    my @lines = create_test_message($message_file);
    return mySociety::HandleMail::parse_arf_mail(\@lines);
}
#---------------------------------

sub parse_bounce($){
    my $message_file = shift;
    my @lines = create_test_message($message_file);
    return mySociety::HandleMail::parse_bounce(\@lines);
}

#---------------------------------

BEGIN { use_ok('mySociety::HandleMail'); }

sub test_parse_dsn_bounce(){

    my $r = parse_dsn_bounce('aol-mailbox-full.txt');
    my %attributes = %{$r};
    is($attributes{status}, "5.2.2", 'parse_dsn_bounce should return a status of "5.2.2" for a "Mailbox full" bounce from AOL');
    is($attributes{recipient}, 'anon@aol.com', 'parse_dsn_bounce should return a recipient of "anon@aol.com" for a "Mailbox full" bounce from AOL');

    
    $r = parse_dsn_bounce('nhs-user-over-quota.txt');   
    %attributes = %{$r};
    is($attributes{status}, "5.1.1", 'parse_dsn_bounce should return a status of "5.1.1" for a "User over quota" bounce from the NHS');
    is($attributes{recipient}, 'anon@nhs.net', 'parse_dsn_bounce should return a recipient of "anon@nhs.net" for a "User over quota" bounce from the NHS');

    
    $r = parse_dsn_bounce('hotmail-improper-command-sequence.txt'); 
    %attributes = %{$r};  
    is($attributes{status}, "5.5.0", 'parse_dsn_bounce should return a status of "5.5.0" for an "Improper command sequence" bounce from Hotmail');
    is($attributes{recipient}, 'anon@hotmail.com', 'parse_dsn_bounce should return a recipient of "anon@hotmail.com" for an "Improper command sequence" bounce from Hotmail');


    $r = parse_dsn_bounce('messagelabs-unknown-user.txt');   
    is($r, undef, 'parse_dsn_bounce should return undef for a "Unknown user" bounce from MessageLabs without a DSN part');

    $r = parse_dsn_bounce('hotmail-mailbox-unavailable.txt');   
    is($r, undef, 'parse_dsn_bounce should return undef for a "Mailbox unavailable" bounce from Hotmail without a DSN part');
      
    $r = parse_ill_formed_dsn_bounce('dsn-with-extra-text-in-status-field.txt');
    %attributes = %{$r};     
    is($attributes{status}, '5.0.0', 'parse_ill_formed_dsn_bounce should return a status of "5.0.0" for an "Unknown address" bounce that is not well formed');
    is($attributes{recipient}, 'anon@anon.com', 'parse_ill_formed_dsn_bounce should return a recipient of "anon@anon.com" for an "Unknown address" bounce that is not well formed');

     
    $r = parse_ill_formed_dsn_bounce('mailbox-full-multipart-mixed-dsn.txt');   
    %attributes = %{$r};  
    is($attributes{status}, '5.2.2', 'parse_ill_formed_dsn_bounce should return a status of "5.2.2" for a DSN message whose content type is multipart/mixed'); 
    is($attributes{recipient}, 'anon@onmobile.com', 'parse_ill_formed_dsn_bounce should return a recipient of "anon@onmobile.com" for a DSN message whose content type is multipart/mixed'); 

    $r = parse_ill_formed_dsn_bounce('yahoo-dsn-bounce.txt');   
    %attributes = %{$r};  
    is($attributes{status}, '4.4.7', 'parse_ill_formed_dsn_bounce should return a status of "4.4.7" for a DSN message'); 
    is($attributes{recipient}, 'anon@osu.edu', 'parse_ill_formed_dsn_bounce should return a recipient of "anon@osu.edu" for a DSN message'); 

    $r = parse_ill_formed_dsn_bounce('exchange-rejected.txt');
    %attributes = %{$r};
    is($attributes{status}, '5.1.0', 'parse_ill_formed_dsn_bounce should return a status of "5.1.0" for an embedded DSN message from Exchange');
    is($attributes{recipient}, 'anon@anon.co.uk', 'parse_ill_formed_dsn_bounce should return a recipient of "anon@co.uk" for an embedded DSN message from Exchange'); 
 
    $r = parse_ill_formed_dsn_bounce('dsn-extra-mime-parts.txt');
    %attributes = %{$r};
    is($attributes{status}, '5.0.0', 'parse_ill_formed_dsn_bounce should return a status of "5.0.0" for a DSN message with extra mime parts and no domain given');
    is($attributes{recipient}, undef, 'parse_ill_formed_dsn_bounce should return a recipient of undef for a DSN message with extra mime parts and no domain given'); 
    
    return 1;
}

sub test_parse_mdn_bounce(){
    
    my ($disposition, $message) = parse_mdn_bounce('dovecot-mdn-quota-exceeded.txt');
    is($disposition, 'automatic-action/MDN-sent-automatically; deleted', 'parse_mdn bounce should return the correct disposition string for a "Quota exceeded" mail from Dovecot');
    is($message, 'Your message to <anon@virgin.net> was automatically rejected: Quota exceeded', 'parse_mdn bounce should return the correct message for a "Quota exceeded" mail from Dovecot');
    
    return 1;
}

sub test_parse_bounce(){

    my %expected_values = (smtp_code => '550', 
                           message => 'Recipient address rejected: User unknown in virtual mailbox table', 
                           dsn_code => '5.1.1', 
                           problem => mySociety::HandleMail::ERR_NO_USER,
                           email_address => 'anon@bigwidetalk.org', 
                           domain => 'bigwidetalk.org');
    expect_bounce_values('messagelabs unknown user mail','messagelabs-unknown-user.txt', %expected_values);
       
    %expected_values = (smtp_code => undef, 
                        message => 'Sorry, I couldn\'t find any host named targetbgt.com.',
                        dsn_code => '5.1.2', 
                        problem => mySociety::HandleMail::ERR_UNROUTEABLE,
                        email_address => 'anon@targetbgt.com', 
                        domain => 'targetbgt.com');
    expect_bounce_values('messagelabs no host mail','messagelabs-no-host.txt', %expected_values);
    
    %expected_values = (smtp_code => '550', 
                        message => 'Mailbox unavailable or access denied',
                        dsn_code => undef, 
                        problem => mySociety::HandleMail::ERR_MAILBOX_UNAVAILABLE,
                        email_address => 'anon@portman.co.uk', 
                        domain => 'portman.co.uk');
    expect_bounce_values('messagelabs mailbox unavailable mail','messagelabs-mailbox-unavailable.txt', %expected_values);
    
    %expected_values = (smtp_code => '550', 
                        message => 'Requested action not taken: mailbox unavailable', 
                        dsn_code => undef,
                        problem => mySociety::HandleMail::ERR_MAILBOX_UNAVAILABLE,
                        email_address => 'anon@hotmail.com', 
                        domain => 'hotmail.com');
    expect_bounce_values('hotmail mailbox unavailable mail','hotmail-mailbox-unavailable.txt', %expected_values);

    %expected_values = (smtp_code => undef, 
                        message => 'The users mailfolder is over the allowed quota (size).', 
                        dsn_code => '5.2.2',
                        problem => mySociety::HandleMail::ERR_MAILBOX_FULL,
                        email_address => 'anon@boltblue.com', 
                        domain => 'boltblue.com');
    expect_bounce_values('qmail over quota mail','qmail-over-quota.txt', %expected_values);

    %expected_values = (smtp_code => undef, 
                        message => 'retry time not reached for any host after a long failure period', 
                        dsn_code => undef,
                        problem => mySociety::HandleMail::ERR_TIMEOUT,
                        email_address => 'anon@lycos.co.uk', 
                        domain => 'lycos.co.uk');
    expect_bounce_values('exim long retry mail','exim-long-retry.txt', %expected_values);

    %expected_values = (smtp_code => undef, 
                        message => 'Your message to <anon@virgin.net> was automatically rejected: Quota exceeded', 
                        dsn_code => undef,
                        problem => mySociety::HandleMail::ERR_MAILBOX_FULL,
                        email_address => 'anon@virgin.net', 
                        domain => 'virgin.net');
    expect_bounce_values('mdn quota exceeded','dovecot-mdn-quota-exceeded.txt', %expected_values);
    
    %expected_values = (smtp_code => undef, 
                        message => 'Your mail to the following recipients could not be delivered because they are not accepting mail from hassle@hassleme.co.uk: anon', 
                        dsn_code => undef,
                        problem => mySociety::HandleMail::ERR_SPAM,
                        email_address => 'anon@aol.com', 
                        domain => 'aol.com');
    expect_bounce_values('aol spam','aol-spam.txt', %expected_values);
    
    %expected_values = (smtp_code => undef, 
                        message => 'unable to connect to remote server [194.73.73.127:25]: Operation timed out I\'m not going to try again; this message has been in the queue too long.', 
                        dsn_code => undef,
                        problem => mySociety::HandleMail::ERR_TIMEOUT,
                        email_address => 'anon@btinternet.com', 
                        domain => 'btinternet.com');
    expect_bounce_values('yahoo timeout','yahoo-timeout.txt', %expected_values);
    
    %expected_values = (problem => mySociety::HandleMail::ERR_OUT_OF_OFFICE, 
                        message => 'I will be out of the office starting 09/08/2008 and will not return until 09/11/2008. I will respond to your message when I return.');
                        
    expect_bounce_values('out of office', 'out-of-office.txt', %expected_values);

    %expected_values = (smtp_code => undef, 
                        message => 'delivery retry timeout exceeded',
                        dsn_code => undef,
                        problem => mySociety::HandleMail::ERR_TIMEOUT,
                        email_address => 'anon@example.org', 
                        domain => 'example.org');
    expect_bounce_values('exim long retry mail','kundenserver.txt', %expected_values);

    return 1;
}

sub expect_bounce_values($$%){
    my ($example, $file, %values) = @_;
    my %data = parse_bounce($file);
    for my $key (keys %values) {
        is($data{$key}, $values{$key}, 'parse_bounce can correctly extract ' . $key . ' from ' . $example);
    }
    
}

sub expect_parse_remote_host_values($$%){
    my ($example, $text, %values) = @_;
    my %data = mySociety::HandleMail::parse_remote_host_error($text);
    for my $key (keys %values) {
        is($data{$key}, $values{$key}, 'parse_remote_host_error can correctly extract ' . $key . ' from ' . $example);
    }

}

sub expect_parse_smtp_values($$%){
    my ($example, $text, %values) = @_;
    my %data = mySociety::HandleMail::parse_smtp_error($text);
    for my $key (keys %values) {
        is($data{$key}, $values{$key}, 'parse_smtp_error can correctly extract ' . $key . ' from ' . $example);
    }
    
}

sub expect_parse_qmail_values($$%){
    my ($example, $text, %values) = @_;
    my %data = mySociety::HandleMail::parse_qmail_error($text);
    for my $key (keys %values) {
        is($data{$key}, $values{$key}, 'parse_qmail_error can correctly extract ' . $key . ' from ' . $example);
    }
}

sub expect_parse_exim_values($$%){
    my ($example, $text, %values) = @_;
    my %data = mySociety::HandleMail::parse_exim_error($text);
    for my $key (keys %values) {
        is($data{$key}, $values{$key}, 'parse_exim_error can correctly extract ' . $key . ' from ' . $example);
    }
}

sub expect_parse_yahoo_values($$%){
    my ($example, $text, %values) = @_;
    my %data = mySociety::HandleMail::parse_yahoo_error($text);
    for my $key (keys %values) {
        is($data{$key}, $values{$key}, 'parse_yahoo_error can correctly extract ' . $key . ' from ' . $example);
    }
}

sub expect_parse_out_of_office_values($$%){
    my ($example, $text, %values) = @_;
    my %data = mySociety::HandleMail::parse_out_of_office($text);
    for my $key (keys %values) {
        is($data{$key}, $values{$key}, 'parse_out_of_office can correctly extract ' . $key . ' from ' . $example);
    }
}

sub test_parse_smtp_error(){

    my $text = 'anon@hotmail.com
    SMTP error from remote mail server after RCPT TO:<anon@hotmail.com>:
    host mx3.hotmail.com [65.55.37.104]: 550 Requested action not taken:
    mailbox unavailable
    ';
    my %expected_values = (domain => 'hotmail.com', 
                           smtp_code => '550', 
                           dsn_code => undef, 
                           email_address => 'anon@hotmail.com',
                           problem => mySociety::HandleMail::ERR_MAILBOX_UNAVAILABLE,
                           message => 'Requested action not taken: mailbox unavailable');
    expect_parse_smtp_values('hotmail example', $text, %expected_values);

    $text = 'anon@fcg.com
    SMTP error from remote mail server after RCPT TO:<anon@fcg.com>:
    host smtp2.fcg.com [199.196.56.212]: 550 No such user (anon@fcg.com)
    ';
    %expected_values = (domain => 'fcg.com', 
                        smtp_code => '550', 
                        dsn_code => undef, 
                        problem => mySociety::HandleMail::ERR_NO_USER,
                        email_address => 'anon@fcg.com',
                        message => 'No such user (anon@fcg.com)');
    expect_parse_smtp_values('fcg example', $text, %expected_values);
    
    $text = 'anon@server.fsnet.co.uk
    SMTP error from remote mail server after RCPT TO:<anon@server.fsnet.co.uk>:
    host mail-in.freeserve.com [193.252.22.184]: 552 5.2.2 <anon@server.fsnet.co.uk>:
    Recipient address rejected: Over quota
    ';
    %expected_values = (domain => 'server.fsnet.co.uk', 
                        smtp_code => '552', 
                        dsn_code => '5.2.2', 
                        problem => mySociety::HandleMail::ERR_MAILBOX_FULL,
                        email_address => 'anon@server.fsnet.co.uk',
                        message => 'Recipient address rejected: Over quota');
    expect_parse_smtp_values('fsnet example', $text, %expected_values);
    
    $text = 'anon@abbeyfm.co.uk
    SMTP error from remote mail server after RCPT TO:<anon@abbeyfm.co.uk>:
    host abbeyfm.co.uk [87.106.26.53]: 553 sorry, that domain isn\'t in my list of allowed rcpthosts; no valid cert for gatewaying (#5.7.1)
    ';
    %expected_values = (domain => 'abbeyfm.co.uk', 
                        smtp_code => '553', 
                        dsn_code => '5.7.1', 
                        problem => mySociety::HandleMail::ERR_NO_RELAY,
                        email_address => 'anon@abbeyfm.co.uk',
                        message => "sorry, that domain isn't in my list of allowed rcpthosts; no valid cert for gatewaying");
    expect_parse_smtp_values('abbeyfm example', $text, %expected_values);

    $text = 'anon@ntlworld.com
    SMTP error from remote mail server after RCPT TO:<anon@ntlworld.com>:
    host smtpin.ntlworld.com [81.103.221.10]: 550 Invalid recipient:
    <anon@ntlworld.com>
    ';
    %expected_values = (domain => 'ntlworld.com', 
                        smtp_code => '550', 
                        dsn_code => undef, 
                        problem => mySociety::HandleMail::ERR_NO_USER,
                        email_address => 'anon@ntlworld.com',
                        message => 'Invalid recipient: <anon@ntlworld.com>');
    expect_parse_smtp_values('ntlworld example', $text, %expected_values);
    
    $text = 'anon@anon.com
    SMTP error from remote mail server after RCPT TO:<anon@anon.com>:
    host cluster1.eu.messagelabs.com [195.245.230.115]:
    553-you are trying to use me [server-10.tower-57.messagelabs
    553-.com] as a relay, but I have not been configured to let
    553-you [82.111.230.211, sponge.ukcod.org.uk] do this.
    553-Please visit www.messagelabs.com/support for more
    553-details about this error message and instructions to
    553 resolve this issue. (#5.7.1)
    ';
    %expected_values = (domain => 'anon.com', 
                        smtp_code => '553', 
                        dsn_code => '5.7.1', 
                        email_address => 'anon@anon.com',
                        problem => mySociety::HandleMail::ERR_NO_RELAY,
                        message => 'you are trying to use me [server-10.tower-57.messagelabs 553-.com] as a relay, but I have not been configured to let 553-you [82.111.230.211, sponge.ukcod.org.uk] do this. 553-Please visit www.messagelabs.com/support for more 553-details about this error message and instructions to 553 resolve this issue.');
    expect_parse_smtp_values('messagelabs example', $text, %expected_values);
    
    
    $text = 'anon@askal.com
      SMTP error from remote mail server after end of data:
      host mail.askal.com [81.137.231.49]: 554 Sorry, message looks like SPAM to me
      ';
    %expected_values = (domain => 'askal.com', 
                        smtp_code => '554', 
                        dsn_code => undef, 
                        email_address => 'anon@askal.com',
                        problem => mySociety::HandleMail::ERR_SPAM,
                        message => 'Sorry, message looks like SPAM to me');
    expect_parse_smtp_values('askal example', $text, %expected_values);
    
    $text = 'anon@fsw.vu.nl
      SMTP error from remote mail server after end of data:
      host mx-1.mf.surf.net [195.169.124.153]: 554 5.7.1 Message scored extremely high on spam scale.  No incident created.
      ';
    %expected_values = (domain => 'fsw.vu.nl', 
                        smtp_code => '554', 
                        dsn_code => '5.7.1', 
                        email_address => 'anon@fsw.vu.nl',
                        problem => mySociety::HandleMail::ERR_SPAM,
                        message => 'Message scored extremely high on spam scale. No incident created.');
    expect_parse_smtp_values('vu example', $text, %expected_values);
    
    $text = 'anon@fairadsl.co.uk
        SMTP error from remote mail server after end of data:
        host email3.bootsit.com [84.45.84.225]: 550 5.7.1 Relay Denied
    ';
    %expected_values = (domain => 'fairadsl.co.uk', 
                        smtp_code => '550', 
                        dsn_code => '5.7.1', 
                        email_address => 'anon@fairadsl.co.uk',
                        problem => mySociety::HandleMail::ERR_NO_RELAY,
                        message => 'Relay Denied');
    expect_parse_smtp_values('fairadsl example', $text, %expected_values);
    
    $text = 'anon@toynbeehall.org.uk
          SMTP error from remote mail server after end of data:
          host service24.mimecast.com [212.2.3.153]: 554 email rejected due to security policies - MCSpamSignature.sa.28.6
    ';
    %expected_values = (domain => 'toynbeehall.org.uk', 
                        smtp_code => '554', 
                        dsn_code => undef, 
                        email_address => 'anon@toynbeehall.org.uk',
                        problem => mySociety::HandleMail::ERR_SPAM,
                        message => 'email rejected due to security policies - MCSpamSignature.sa.28.6');
    expect_parse_smtp_values('toynbeehall example', $text, %expected_values);    
    
    $text = 'anon@Youth-Action.net
      SMTP error from remote mail server after MAIL FROM:<twfy-bounce@theyworkforyou.com> SIZE=5050:
      host mailserver.youth-action.net [81.86.250.118]:
      550 This message has been blocked by Policy Patrol
    ';
    %expected_values = (domain => 'Youth-Action.net', 
                        smtp_code => '550', 
                        dsn_code => undef, 
                        email_address => 'anon@Youth-Action.net',
                        problem => mySociety::HandleMail::ERR_SPAM,
                        message => 'This message has been blocked by Policy Patrol');
    expect_parse_smtp_values('youth action example', $text, %expected_values);    
    
    $text = 'anon@sunderland.gov.uk
      SMTP error from remote mail server after initial connection:
      host mail.sunderland.gov.uk [193.195.42.194]:
      550 Requested action not taken: mailbox unavailable.
    ';
    %expected_values = (domain => 'sunderland.gov.uk', 
                        smtp_code => '550', 
                        dsn_code => undef, 
                        email_address => 'anon@sunderland.gov.uk',
                        problem => mySociety::HandleMail::ERR_MAILBOX_UNAVAILABLE,
                        message => 'Requested action not taken: mailbox unavailable.');
    expect_parse_smtp_values('sunderland example', $text, %expected_values);
      
    $text = 'anon@btinternet.com
        SMTP error from remote mailer after initial connection:
        host mx1.bt.mail.yahoo.com [217.146.188.189]:
        421 4.7.0 [TS02] Messages from 77.92.95.112 temporarily deferred due to user complaints - 4.16.56.1; see http://postmaster.yahoo.com/421-ts02.html:
        retry timeout exceeded
    ';
    %expected_values = (domain => 'btinternet.com', 
                        smtp_code => '421', 
                        dsn_code => '4.7.0', 
                        email_address => 'anon@btinternet.com',
                        problem => mySociety::HandleMail::ERR_TEMPORARILY_DEFERRED,
                        message => '[TS02] Messages from 77.92.95.112 temporarily deferred due to user complaints - 4.16.56.1; see http://postmaster.yahoo.com/421-ts02.html: retry timeout exceeded');
    expect_parse_smtp_values('btinternet example', $text, %expected_values);
    
    $text = 'anon@anon.com
      SMTP error from remote mail server after RCPT TO:<anon@anon.com>:
      host anon.com [91.121.84.154]: 550-Verification failed for <twfy-bounce@theyworkforyou.com>
      550-The mail server could not deliver mail to twfy-bounce@theyworkforyou.com.  The account or domain may not exist, they may be blacklisted, or missing the proper dns entries.
      550 Sender verify failed
      ';
    %expected_values = (domain => 'anon.com', 
                      smtp_code => '550', 
                      dsn_code => undef, 
                      email_address => 'anon@anon.com',
                      problem => mySociety::HandleMail::ERR_VERIFICATION_FAILED,
                      message => 'Verification failed for <twfy-bounce@theyworkforyou.com> 550-The mail server could not deliver mail to twfy-bounce@theyworkforyou.com. The account or domain may not exist, they may be blacklisted, or missing the proper dns entries. 550 Sender verify failed');
    expect_parse_smtp_values('sender verify example', $text, %expected_values);
      
    $text = 'anon@redmail.com
    SMTP error from remote mail server after pipelined DATA:
    host relay-1.mail.fido.net [194.70.36.21]: 597 we have a reason to believe this message is unwanted here
    ';  
    %expected_values = (domain => 'redmail.com', 
                      smtp_code => '597', 
                      dsn_code => undef, 
                      email_address => 'anon@redmail.com',
                      problem =>  mySociety::HandleMail::ERR_SPAM,
                      message => 'we have a reason to believe this message is unwanted here');
    expect_parse_smtp_values('redmail example', $text, %expected_values);
    
    $text = 'anon@surreycc.gov.uk
      SMTP error from remote mail server after RCPT TO:<anon@surreycc.gov.uk>:
      host a.surreycc.gov.uk [212.137.33.124]:
      550 5.7.1 Unable to deliver to <anon@surreycc.gov.uk>
      ';   
    %expected_values = (domain => 'surreycc.gov.uk', 
                    smtp_code => '550', 
                    dsn_code => '5.7.1', 
                    email_address => 'anon@surreycc.gov.uk',
                    problem =>  mySociety::HandleMail::ERR_MESSAGE_REFUSED,
                    message => 'Unable to deliver to <anon@surreycc.gov.uk>');
    expect_parse_smtp_values('surreycc example', $text, %expected_values);
      
    $text = 'anon@anon.com
      SMTP error from remote mail server after RCPT TO:<anon@anon.com>:
      host anon.com [67.228.55.144]: 503 This mail server requires authentication when attempting to send to a non-local e-mail address. Please check your mail client settings or contact your administrator to verify that the domain or address is defined for this server.
      ';
    %expected_values = (domain => 'anon.com', 
                  smtp_code => '503', 
                  dsn_code => undef, 
                  email_address => 'anon@anon.com',
                  problem =>  mySociety::HandleMail::ERR_AUTH_REQUIRED,
                  message => 'This mail server requires authentication when attempting to send to a non-local e-mail address. Please check your mail client settings or contact your administrator to verify that the domain or address is defined for this server.');
    expect_parse_smtp_values('auth example', $text, %expected_values);
    
    $text = 'anon@itaubank.com.br
      SMTP error from remote mail server after MAIL FROM:<hm@sandwich.ukcod.org.uk> SIZE=2175:
      host post3.itau.com.br [200.196.152.253]: 501 Syntax error in parameters or arguments -
      ';
    %expected_values = (domain => 'itaubank.com.br', 
                  smtp_code => '501', 
                  dsn_code => undef, 
                  email_address => 'anon@itaubank.com.br',
                  problem =>  mySociety::HandleMail::ERR_BAD_SYNTAX,
                  message => 'Syntax error in parameters or arguments -');
    expect_parse_smtp_values('syntax example', $text, %expected_values);
    
    $text = 'anon@tiscali.co.uk
      SMTP error from remote mail server after RCPT TO:<anon@tiscali.co.uk>:
      host mx2.uk.tiscali.com [212.74.100.148]: 550 5.1.1 <anon@tiscali.co.uk> user disabled
      ';
     
    %expected_values = (domain => 'tiscali.co.uk', 
                    smtp_code => '550', 
                    dsn_code => '5.1.1', 
                    email_address => 'anon@tiscali.co.uk',
                    problem =>  mySociety::HandleMail::ERR_MAILBOX_UNAVAILABLE,
                    message => '<anon@tiscali.co.uk> user disabled');
    expect_parse_smtp_values('tiscali example', $text, %expected_values);

    $text = 'anon@anon.org
          SMTP error from remote mail server after RCPT TO:<anon@anon.org>:
          host grey-area.mailhostingserver.com [209.62.85.74]:
          554 5.7.1 <sponge.ukcod.org.uk[82.111.230.211]>:
          Client host rejected: Access denied
          ';
    %expected_values = (domain => 'anon.org', 
                  smtp_code => '554', 
                  dsn_code => '5.7.1', 
                  email_address => 'anon@anon.org',
                  problem =>  mySociety::HandleMail::ERR_SPAM,
                  message => 'Client host rejected: Access denied');
    expect_parse_smtp_values('grey area example', $text, %expected_values);

          
    $text = 'anon@anon.com
           SMTP error from remote mail server after RCPT TO:<anon@anon.com>:
           host athena.hosts.co.uk [85.233.160.20]: 550 Rejected
           ';
    %expected_values = (domain => 'anon.com', 
                 smtp_code => '550', 
                 dsn_code => undef, 
                 email_address => 'anon@anon.com',
                 problem =>  mySociety::HandleMail::ERR_MESSAGE_REFUSED,
                 message => 'Rejected');
    expect_parse_smtp_values('athena example', $text, %expected_values);

    $text = 'anon@anon.com
    SMTP error from remote mail server after RCPT TO:<anon@anon.com>:
    host anon.com [141.163.66.134]:
    550 Prohibited: Recipient not known at this site
           ';
    %expected_values = (domain => 'anon.com', 
                 smtp_code => '550', 
                 dsn_code => undef, 
                 email_address => 'anon@anon.com',
                 problem =>  mySociety::HandleMail::ERR_NO_USER,
                 message => 'Prohibited: Recipient not known at this site');
    expect_parse_smtp_values('recipient not known example', $text, %expected_values);

    $text = 'anon@anon.co.za
      SMTP error from remote mail server after RCPT TO:<anon@anon.co.za>:
      host mail.anon.co.za [41.203.18.177]: 550 Unroutable address   
           ';
    %expected_values = (domain => 'anon.co.za', 
                 smtp_code => '550', 
                 dsn_code => undef, 
                 email_address => 'anon@anon.co.za',
                 problem =>  mySociety::HandleMail::ERR_UNROUTEABLE,
                 message => 'Unroutable address');
    expect_parse_smtp_values('Unroutable co.za example', $text, %expected_values);

    $text = 'anon@anon.co.uk
      SMTP error from remote mail server after RCPT TO:<anon@anon.co.uk>:
      host anon.co.uk [62.172.47.144]: 552 5.2.2 Message would exceed quota for <anon@anon.co.uk> 
           ';
    %expected_values = (domain => 'anon.co.uk', 
                 smtp_code => '552', 
                 dsn_code => '5.2.2', 
                 email_address => 'anon@anon.co.uk',
                 problem =>  mySociety::HandleMail::ERR_MAILBOX_FULL,
                 message => 'Message would exceed quota for <anon@anon.co.uk>');
    expect_parse_smtp_values('Quota .co.uk example', $text, %expected_values);
    
    return 1;
}

sub test_parse_remote_host_error(){
    
    my $text = '217.112.88.213 does not like recipient.
    Remote host said: 550 5.1.1 <anon@bigwidetalk.org>: Recipient address rejected: User unknown in virtual mailbox table
    ';
    my %expected_values = (domain => 'bigwidetalk.org', 
                           smtp_code => '550', 
                           dsn_code => '5.1.1', 
                           email_address => 'anon@bigwidetalk.org',
                           problem => mySociety::HandleMail::ERR_NO_USER,
                           message => "Recipient address rejected: User unknown in virtual mailbox table");
    expect_parse_remote_host_values('abbeyfm example', $text, %expected_values);
    
    return 1;
}

sub test_parse_qmail_error(){
    
    my $text = 'Hi. This is the qmail-send program at yourheartland.org.uk.
    I\'m afraid I wasn\'t able to deliver your message to the following addresses.
    This is a permanent error; I\'ve given up. Sorry it didn\'t work out.

    <anon@tory.org>:
    Mail quota exceeded.
    ';
    my %expected_values = (domain => 'tory.org', 
                           message => 'Mail quota exceeded.', 
                           problem => mySociety::HandleMail::ERR_MAILBOX_FULL,
                           email_address => 'anon@tory.org');
    expect_parse_qmail_values('tory example', $text, %expected_values);
    
    $text = 'Hi. This is the qmail-send program at boltblue.net.
    I\'m afraid I wasn\'t able to deliver your message to the following addresses.
    This is a permanent error; I\'ve given up. Sorry it didn\'t work out.
    *
    * You\'ve experienced some sort of problem sending mail to one of our users.
    * (Please contact us at <support@boltblue.com> if you require assistance)
    *
    * Below is the original mail and the failure reason:
    *


    <anon@boltblue.com>:
    The users mailfolder is over the allowed quota (size). (#5.2.2)
    ';
    %expected_values = (domain => 'boltblue.com', 
                        message => 'The users mailfolder is over the allowed quota (size).', 
                        dsn_code => '5.2.2',
                        problem => mySociety::HandleMail::ERR_MAILBOX_FULL,
                        email_address => 'anon@boltblue.com');
    expect_parse_qmail_values('boltblue example', $text, %expected_values);
    
    return 1;
}

sub test_parse_out_of_office(){
    
    my $text = '

    I am out of the office from Friday 3rd April to Monday 13th April. Back in on Tuesday 14th.

    If you need an urgent response please contact Someone Else (anon@anon.org.uk) Tel 555 5555 555.

    Regards,

    me';
    my %expected_values = (domain => undef, 
                           message => 'I am out of the office from Friday 3rd April to Monday 13th April. Back in on Tuesday 14th. If you need an urgent response please contact Someone Else (anon@anon.org.uk) Tel 555 5555 555. Regards, me', 
                           problem => mySociety::HandleMail::ERR_OUT_OF_OFFICE,
                           email_address => undef);
    expect_parse_out_of_office_values('out of office example', $text, %expected_values);
    return 1;
}

sub test_parse_yahoo_error(){
    
    my $text = 'Message from yahoo.co.uk.
    Unable to deliver message to the following address(es).

    <anon@yahoo.co.uk>:
    Sorry your message to anon@yahoo.co.uk cannot be delivered. This account has been disabled or discontinued [#102].
    ';
    my %expected_values = (domain => 'yahoo.co.uk',
                           message => 'Sorry your message to anon@yahoo.co.uk cannot be delivered. This account has been disabled or discontinued [#102].', 
                           problem => mySociety::HandleMail::ERR_MAILBOX_UNAVAILABLE,
                           email_address => 'anon@yahoo.co.uk');
    expect_parse_yahoo_values('yahoo example', $text, %expected_values);
   
    $text = "Message from  yahoo.com.
    Unable to deliver message to the following address(es).

    <anon\@btinternet.com>:
    unable to connect to remote server [194.73.73.127:25]: Operation timed out
    I'm not going to try again; this message has been in the queue too long.
    ";
    %expected_values = (domain => 'btinternet.com',
                        message => 'unable to connect to remote server [194.73.73.127:25]: Operation timed out I\'m not going to try again; this message has been in the queue too long.', 
                        problem => mySociety::HandleMail::ERR_TIMEOUT,
                        email_address => 'anon@btinternet.com');
    expect_parse_yahoo_values('yahoo example', $text, %expected_values);
    
    return 1;
}

sub test_parse_exim_error(){
    
    my $text = 'This message was created automatically by mail delivery software.

    A message that you sent could not be delivered to one or more of its
    recipients. This is a permanent error. The following address(es) failed:

      anon@fsnet.co.uk
        Unrouteable address
    ';
    my %expected_values = (domain => 'fsnet.co.uk',
                           message => 'Unrouteable address', 
                           problem => mySociety::HandleMail::ERR_UNROUTEABLE,
                           email_address => 'anon@fsnet.co.uk');
    expect_parse_exim_values('fsnet example', $text, %expected_values);
        
    $text = 'This message was created automatically by mail delivery software.

    A message that you sent could not be delivered to one or more of its
    recipients. This is a permanent error. The following address(es) failed:

      anon@supanet.com
        mailbox is full: retry timeout exceeded
    ';
    %expected_values = (domain => 'supanet.com',
                        message => 'mailbox is full: retry timeout exceeded', 
                        problem => mySociety::HandleMail::ERR_MAILBOX_FULL,
                        email_address => 'anon@supanet.com');
    expect_parse_exim_values('supanet example', $text, %expected_values);
        
    $text = 'This message was created automatically by mail delivery software.

    A message that you sent could not be delivered to one or more of its
    recipients. This is a permanent error. The following address(es) failed:

      anon@lycos.co.uk
        retry time not reached for any host after a long failure period
    ';
    %expected_values = (domain => 'lycos.co.uk',
                        message => 'retry time not reached for any host after a long failure period', 
                        problem => mySociety::HandleMail::ERR_TIMEOUT,
                        email_address => 'anon@lycos.co.uk');
    expect_parse_exim_values('lycos example', $text, %expected_values);
        
    $text = 'This message was created automatically by mail delivery software.

    A message that you sent could not be delivered to one or more of its
    recipients. This is a permanent error. The following address(es) failed:

    anon@anon.co.uk
        retry timeout exceeded
    ';
    %expected_values = (domain => 'anon.co.uk',
                        message => 'retry timeout exceeded',
                        problem => mySociety::HandleMail::ERR_TIMEOUT,
                        email_address => 'anon@anon.co.uk');
    expect_parse_exim_values('anon.co.uk example', $text, %expected_values);

    $text = 'This message was created automatically by mail delivery software.

    A message that you sent could not be delivered to one or more of its
    recipients. This is a permanent error. The following address(es) failed:

      anon@uk.com
        all relevant MX records point to non-existent hosts
    ';
    %expected_values = (domain => 'uk.com',
                        message => 'all relevant MX records point to non-existent hosts', 
                        problem => mySociety::HandleMail::ERR_UNROUTEABLE,
                        email_address => 'anon@uk.com');
    expect_parse_exim_values('uk.com example', $text, %expected_values);

    $text = 'This message was created automatically by mail delivery software.

    A message that you sent could not be delivered to all of its recipients.
    The following address(es) failed:

      anon@anon.karoo.co.uk
        mailbox is full
    ';
    %expected_values = (domain => 'anon.karoo.co.uk',
                        message => 'mailbox is full', 
                        problem => mySociety::HandleMail::ERR_MAILBOX_FULL,
                        email_address => 'anon@anon.karoo.co.uk');
    expect_parse_exim_values('karoo example', $text, %expected_values);
        
    $text = 'This message was created automatically by mail delivery software.

    A message that you sent could not be delivered to one or more of its
    recipients. This is a permanent error. The following address(es) failed:

      anon@canterbury.ac.uk
      (generated from anon@canterbury.ac.uk)
      retry timeout exceeded
    ';
    %expected_values = (domain => 'canterbury.ac.uk',
                        message => 'retry timeout exceeded',
                        problem => mySociety::HandleMail::ERR_TIMEOUT,
                        email_address => 'anon@canterbury.ac.uk');
    expect_parse_exim_values('canterbury example', $text, %expected_values); 
     
    $text = 'This message was created automatically by mail delivery software.

    A message that you sent could not be delivered to one or more of its
    recipients. This is a permanent error. The following address(es) failed:

    anon@mosaichomes.co.uk
      all relevant MX records point to non-existent hosts or (invalidly) to IP addresses
    ';
    %expected_values = (domain => 'mosaichomes.co.uk',
                        problem => mySociety::HandleMail::ERR_UNROUTEABLE,
                        message => 'all relevant MX records point to non-existent hosts or (invalidly) to IP addresses', 
                        email_address => 'anon@mosaichomes.co.uk');
    expect_parse_exim_values('mosaichomes example', $text, %expected_values);
      
    $text = 'This message was created automatically by mail delivery software.

      A message that you sent could not be delivered to one or more of its
      recipients. This is a permanent error. The following address(es) failed:

        anon@anon.keele.ac.uk
          (ultimately generated from anon@anon.keele.ac.uk)
          mailbox is full: retry timeout exceeded
    ';
    %expected_values = (domain => 'anon.keele.ac.uk',
                        problem => mySociety::HandleMail::ERR_MAILBOX_FULL,
                        message => 'mailbox is full: retry timeout exceeded', 
                        email_address => 'anon@anon.keele.ac.uk');
    expect_parse_exim_values('keele example', $text, %expected_values);
    
    $text = "This message was created automatically by mail delivery software.
    A message that you sent has not yet been delivered to one or more of its
    recipients after more than 24 hours on the queue on sandwich.ukcod.org.uk.

    The message identifier is:     1L7v7Z-00025a-Qx
    The subject of the message is: Don't forget to... 
    The date of the message is:    Wed, 03 Dec 2008 17:02:41 +0000

    The address to which the message has not yet been delivered is:

      anon\@yahoo.com

    No action is required on your part. Delivery attempts will continue for
    some time, and this warning may be repeated at intervals if the message
    remains undelivered. Eventually the mail delivery software will give up,
    and when that happens, the message will be returned to you.";
    %expected_values = (domain => 'yahoo.com',
                        problem => mySociety::HandleMail::ERR_DELAY,
                        message => 'A message that you sent has not yet been delivered to one or more of its recipients after more than 24 hours on the queue on sandwich.ukcod.org.uk.', 
                        email_address => 'anon@yahoo.com');
    expect_parse_exim_values('yahoo delay example', $text, %expected_values);
    
    return 1;
}

sub expect_sender($$$$$){
    my ($prefix, $domain, $recipient, $expected_sender, $message) = @_;
    my $sender = mySociety::HandleMail::verp_envelope_sender($recipient, $prefix, $domain);
    is($sender, $expected_sender, $message);
}

sub test_verp_envelope_sender(){
    
    my $recipient = 'aperson@a.nother.dom';
    my $prefix = 'bounce-tests';
    my $domain = 'www.example.com';
    my $expected_sender = 'bounce-tests+aperson=a.nother.dom@www.example.com';
    expect_sender($prefix, $domain, $recipient, $expected_sender, 'A standard VERP envelope sender can be created');
    
    $recipient = 'test+me@a.nother.dom';
    $expected_sender = 'bounce-tests+test+me=a.nother.dom@www.example.com';
    expect_sender($prefix, $domain, $recipient, $expected_sender, 'A VERP envelope sender can be created for an email with a plus sign in it');

    $recipient = 'test=me@a.nother.dom';
    $expected_sender = 'bounce-tests+test=me=a.nother.dom@www.example.com';
    expect_sender($prefix, $domain, $recipient, $expected_sender, 'A VERP envelope sender can be created for an email with an equals sign in it');
   
    return 1;
}

sub expect_bounced_address($$$$$){
    my ($prefix, $domain, $address, $expected_address, $message) = @_;
    ($address) = Mail::Address->parse($address);
    my $bounced_address = mySociety::HandleMail::get_bounced_address($address, $prefix, $domain);
    is($bounced_address, $expected_address, $message);
    
}
sub test_get_bounced_address(){
    
    my $prefix = 'bounce-tests';
    my $domain = 'www.example.com';
    
    my $address = 'bounce-tests+aperson=a.nother.dom@www.example.com';
    my $expected_address = 'aperson@a.nother.dom';
    expect_bounced_address($prefix, $domain, $address, $expected_address, 'A standard VERP bounce can be parsed');
    
    $address = 'bounce-tests+test+me=a.nother.dom@www.example.com';
    $expected_address = 'test+me@a.nother.dom';
    expect_bounced_address($prefix, $domain, $address, $expected_address, 'A VERP bounce for an address with a plus sign in it can be parsed');

    $address = 'bounce-tests+test=me=a.nother.dom@www.example.com';
    $expected_address = 'test=me@a.nother.dom';
    expect_bounced_address($prefix, $domain, $address, $expected_address, 'A VERP bounce for an address with an equals sign in it can be parsed');
    
    $address = 'not-a-verp-bounce@www.example.com';
    $expected_address = undef;
    expect_bounced_address($prefix, $domain, $address, $expected_address, 'A non VERP bounce returns an undef bounced address');
    
    return 1;
}

sub test_parse_arf_mail(){

    my $r = parse_arf_mail('messagelabs-unknown-user.txt');   
    is($r, undef, 'parse_arf_mail should return undef for a "Unknown user" bounce from MessageLabs');

    $r = parse_arf_mail('aol-arf.txt');
    my %attributes = %{$r};
    my $expected_original = join("\n", create_test_message('aol-arf-original-message.txt'));
    is($attributes{original_message}, $expected_original, 'parse_arf_mail should return an original message for an "Abuse Reporting Format" mail from AOL');
    is($attributes{feedback_type}, 'abuse', 'parse_arf_mail should return a feedback_type of "abuse" for an "Abuse Reporting Format" mail from AOL');
    is($attributes{user_agent}, 'AOL SComp', 'parse_arf_mail should return a user_agent of "AOL SComp" for an "Abuse Reporting Format" mail from AOL');

    return 1;
}

ok(test_parse_arf_mail() == 1, 'Ran all tests for parse_arf_mail');  
ok(test_parse_dsn_bounce() == 1, 'Ran all tests for parse_dsn_bounce');
ok(test_parse_mdn_bounce() == 1, 'Ran all tests for parse_mdn_bounce');
ok(test_parse_bounce() == 1, 'Ran all tests for parse_bounce');
ok(test_parse_smtp_error() == 1, 'Ran all tests for parse_smtp_error');
ok(test_parse_remote_host_error() == 1, 'Ran all tests for parse_remote_host_error');
ok(test_parse_qmail_error() == 1, 'Ran all tests for parse_qmail_error');
ok(test_parse_exim_error() == 1, 'Ran all tests for parse_exim_error');
ok(test_parse_yahoo_error() == 1, 'Ran all tests for parse_yahoo_error');
ok(test_parse_out_of_office() == 1, 'Ran all tests for parse_out_of_office');
ok(test_verp_envelope_sender() == 1, 'Ran all tests for verp_envelope_sender');
ok(test_get_bounced_address() == 1, 'Ran all tests for get_bounced_address');
