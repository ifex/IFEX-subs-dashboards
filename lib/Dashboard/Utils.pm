package Dashboard::Utils;

use strict;
use warnings;
use base 'Exporter';
use vars qw/@EXPORT_OK/;
@EXPORT_OK = qw/ config schema encrypt_email /;

use YAML::XS 'LoadFile';
use Subscriber::Schema;
use Digest::MD5 'md5_hex';

use File::Spec;
use Cwd qw/abs_path/;
my ( undef, $path ) = File::Spec->splitpath(__FILE__);

sub config {
    my @files = ( File::Spec->catfile( $path, '..', '..', 'dashboard.yml') );
    my $local_file = File::Spec->catfile( $path, '..', '..', 'dashboard_local.yml');
    push @files, $local_file if (-e $local_file);
    my $cfg = {};
    foreach my $file (@files) {
        my $config = LoadFile($file);
        $cfg = { %$cfg, %$config };
    }
    return $cfg;
}

sub schema {
    my $config = config();
    my $connect_info = $config->{'Model::DBIC'}->{connect_info};
    return Subscriber::Schema->connect( @$connect_info );
}

sub encrypt_email {
    my ($email) = @_;
    return md5_hex($email);
}

1;
__END__
