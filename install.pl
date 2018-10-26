#!/bin/perl

use 5.010;
sub invoke_local_command{
	my $command = shift;
	say "local~command: [$command]....";
	my $exec_result = `$command`;
	say "local~results: [$command] [$exec_result]....";
	chomp($exec_result);
	return $exec_result;
}

sub install_postgreSQL{
	unless (-e "/var/lib/pgsql/10/data/postgresql.conf") {
		# $ su - postgres
		# 	psql
		# postgres=# alter user postgres with password '123456';
		invoke_local_command("wget -P /tmp https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm");
		invoke_local_command("rpm -ivh /tmp/pgdg-centos10-10-2.noarch.rpm"); 
		invoke_local_command("yum install -y postgresql10-server postgresql10-contrib postgresql-devel");
		invoke_local_command("mkdir -p /usr/pgsql-10/include");
		invoke_local_command("echo \"export POSTGRES_HOME=/usr/pgsql-10\" >> /etc/profile");
		invoke_local_command("source /etc/profile");
		invoke_local_command("/usr/pgsql-10/bin/postgresql-10-setup initdb");
		invoke_local_command("echo \"listen_addresses = '*'\" >>> /var/lib/pgsql/10/data/postgresql.conf");
		#invoke_local_command("echo \"host\t\tall\t\tall\t\t远程ip/24\t\tmd5\" >> /var/lib/pgsql/10/data/pg_hba.conf");
		invoke_local_command("systemctl restart postgresql-10.service && systemctl enable postgresql-10.service");
	}else{
		say "-------------------------------->the postgreSQL have installed,skip install";
	}
}

sub install_perl_modules{
	invoke_local_command("sudo yum -y install openssl-devel perl-CPAN");
	my @urls = qw(
	https://cpan.metacpan.org/authors/id/R/RJ/RJBS/IPC-Run3-0.048.tar.gz
	https://cpan.metacpan.org/authors/id/J/JH/JHI/Set-Scalar-1.23.tar.gz
	https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.30.tar.gz
	https://cpan.metacpan.org/authors/id/T/TO/TODDR/IO-Tty-1.12.tar.gz
	https://cpan.metacpan.org/authors/id/A/AD/ADAMK/File-HomeDir-1.00.tar.gz
	https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.19.tar.gz
	https://cpan.metacpan.org/authors/id/S/SA/SALVA/Net-OpenSSH-0.34.tar.gz
	https://cpan.metacpan.org/authors/id/A/AG/AGENT/SSH-Batch-0.029.tar.gz
	IO::Compress::Gzip
	);
	invoke_local_command("sudo wget http://xrl.us/cpanm -O /usr/bin/cpanm; sudo chmod +x /usr/bin/cpanm");
	invoke_local_command("alias cpanm='cpanm --sudo --mirror http://mirrors.163.com/cpan --mirror-only --force --installdeps'");
	foreach my $url (@urls){
		invoke_local_command("cpanm $url");
	}
	say "-------------------------------->install Mojolicious";
	my @modules = qw(Mojolicious Mojo::Pg Minion Digest::MD5 Expect Compress::Raw::Zlib);
	foreach my $module (@modules){
		invoke_local_command("cpanm $module");
	}
}

sub update_curl{
	unless (-e "/etc/yum.repos.d/CentOS-Base.repo.backup") {
		invoke_local_command("mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup");
		invoke_local_command("wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo");
		invoke_local_command("yum makecache");
	}
	invoke_local_command("yum -y update nss curl");
}
say "-------------------------------->update curl";
update_curl();
say "-------------------------------->install postgreSQL";
install_postgreSQL();

say "-------------------------------->install perl modules";
install_perl_modules();

say "-------------------------------->check perl modules";
invoke_local_command("perl /root/perl-devops/check.pl");