#!/bin/perl

use 5.010;
sub invoke_local_command{
	my $command = shift;
	my $exec_result = `$command`;
	say "local~: [$command] [$exec_result]....";
	chomp($exec_result);
	return $exec_result;
}

my @urls = qw(
https://cpan.metacpan.org/authors/id/R/RJ/RJBS/IPC-Run3-0.048.tar.gz
https://cpan.metacpan.org/authors/id/J/JH/JHI/Set-Scalar-1.23.tar.gz
https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.30.tar.gz
https://cpan.metacpan.org/authors/id/T/TO/TODDR/IO-Tty-1.12.tar.gz
https://cpan.metacpan.org/authors/id/A/AD/ADAMK/File-HomeDir-1.00.tar.gz
https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.19.tar.gz
https://cpan.metacpan.org/authors/id/S/SA/SALVA/Net-OpenSSH-0.34.tar.gz
https://cpan.metacpan.org/authors/id/A/AG/AGENT/SSH-Batch-0.029.tar.gz
);

foreach my $url (@urls){
	invoke_local_command("wget --no-check-certificate $url");
	$url =~ m#/(([^/]+)\.tar\.gz)#;
	my $tar_name = $1;
	my $dir_name = $2;
	invoke_local_command("tar -xzvf $tar_name; cd $dir_name; perl Makefile.PL; make; make test; make install;");
	invoke_local_command("rm -rf /root/perl-devops/$tar_name");
}