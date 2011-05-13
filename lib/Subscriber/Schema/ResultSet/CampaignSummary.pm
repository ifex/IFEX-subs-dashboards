package Subscriber::Schema::ResultSet::CampaignSummary;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

my %campaign_type = (
    open => 1,
    click => 2,
);

sub rebuild {
    my ($self) = @_;

    my $schema = $self->result_source->schema;
    my $dbh = $schema->storage->dbh;

    my $sql = 'SELECT DATE_FORMAT(created, "%Y-%m") as mon, campaign_id, list_id from emails where type=? group by campaign_id, mon order by mon;';
    my $sth = $dbh->prepare($sql);
    my $num_sql = 'SELECT count(DISTINCT(subscriber_id)) FROM emails WHERE type = ? AND DATE_FORMAT(created, "%Y-%m") = ? AND campaign_id = ?';
    my $num_sth = $dbh->prepare($num_sql);
    
    my %months;
    
    # open
    $sth->execute( $campaign_type{open} ) or die $dbh->errstr;
    $self->search( { type => $campaign_type{open} } )->delete; # delete then insert
    while (my ($mon, $campaign_id, $list_id) = $sth->fetchrow_array ) {
        unless ( exists $months{$mon}{$list_id} ) {
            $months{$mon}{$list_id} = _get_subscriber_num($schema, $mon, $list_id);
        }
        $num_sth->execute( $campaign_type{open}, $mon, $campaign_id ) or die $dbh->errstr;
        my ($cnt) = $num_sth->fetchrow_array;
        $self->update_or_create( {
            campaign_id => $campaign_id,
            type => $campaign_type{open},
            mon  => $mon . '-01',
            num  => $cnt,
            total => $months{$mon}{$list_id},
            list_id => $list_id,
        } );
    }
    
    # click
    $sth->execute( $campaign_type{click} ) or die $dbh->errstr;
    $self->search( { type => $campaign_type{click} } )->delete; # delete then insert
    while (my ($mon, $campaign_id, $list_id) = $sth->fetchrow_array ) {
        unless ( exists $months{$mon}{$list_id} ) {
            $months{$mon}{$list_id} = _get_subscriber_num($schema, $mon, $list_id);
        }
        $num_sth->execute( $campaign_type{click}, $mon, $campaign_id ) or die $dbh->errstr;
        my ($cnt) = $num_sth->fetchrow_array;
        $self->update_or_create( {
            campaign_id => $campaign_id,
            type => $campaign_type{click},
            mon  => $mon . '-01',
            num  => $cnt,
            total => $months{$mon}{$list_id},
            list_id => $list_id,
        } );
    }
}

sub _get_subscriber_num {
    my ($schema, $mon, $list_id) = @_;
    
    my ($y, $m) = split('-', $mon);
    $m++;
    if ($m == 13) { $m = 1; $y++ };
    
    return $schema->resultset('Subscriber')->count_literal('created < ? AND list_id = ? and active=1', sprintf('%04d-%02d-01', $y, $m), $list_id);
}

1;
