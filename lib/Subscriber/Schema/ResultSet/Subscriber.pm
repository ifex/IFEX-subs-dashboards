package Subscriber::Schema::ResultSet::Subscriber;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';
use URI::GoogleChart;
use HTML::Entities;
use Dashboard::Consts qw/month_abbr/;

# get site overview or certain list stats
sub basic_stats {
    my ($self, $site_id, $list_id, $this_month) = @_;

    # set default month as this month
    unless ($this_month and $this_month =~ /^20(\d{2})\-(\d{2})$/) {
        my @d = localtime();
        $this_month = sprintf('%04d-%02d', $d[5] + 1900, $d[4] + 1);
    }

    my $schema = $self->result_source->schema;
    my $dbh = $schema->storage->dbh;

    my $vars;
    
    # total
    my $sth;
    if ($list_id) {
        my $sql = "SELECT COUNT( DISTINCT email ) FROM subscriber WHERE list_id = ? and active=1";
        $sth = $dbh->prepare($sql);
        $sth->execute($list_id);
    } else {
        my $sql = "SELECT COUNT( DISTINCT email ) FROM subscriber WHERE site_id = ? and active=1";
        $sth = $dbh->prepare($sql);
        $sth->execute($site_id); 
    }
    $vars->{total} = $sth->fetchrow_array;

    # example, this_month as '2010-03', last_month as '2010-02'
    my ($this_y, $this_m) = split(/\-/, $this_month);
    my $last_month = $this_m == 1 ? sprintf('%04d-%02d', $this_y - 1, 12) : sprintf('%04d-%02d', $this_y, $this_m - 1);
    
    # get min month and max month
    if ($list_id) {
        my $sql = 'SELECT DATE_FORMAT(created, "%Y-%m") as m FROM subscriber WHERE list_id = ? group by m order by m';
        $sth = $dbh->prepare($sql);
        $sth->execute($list_id);
    } else {
        my $sql = 'SELECT DATE_FORMAT(created, "%Y-%m") as m FROM subscriber WHERE site_id = ? group by m order by m';
        $sth = $dbh->prepare($sql);
        $sth->execute($site_id);
    }
    my @month_abbr = month_abbr();
    $vars->{month_abbr} = \@month_abbr;
    my @all_months;
    while (my ($mm) = $sth->fetchrow_array) {
        my ($y, $m) = split(/\-/, $mm);
        push @all_months, {
            label => $month_abbr[$m - 1] . ' ' . $y,
            value => sprintf('%04d-%02d', $y, $m)
        };
    }
    $vars->{all_months} = \@all_months;

    # get this month
    my $rs; # gain
    if ($list_id) {
        $rs = $self->search_literal('DATE_FORMAT(created, "%Y-%m") = ? AND list_id = ? and active=1', $this_month, $list_id);
    } else {
        $rs = $self->search_literal('DATE_FORMAT(created, "%Y-%m") = ? AND site_id = ? and active=1', $this_month, $site_id);
    }
    my (%this_countries, %this_source, %this_occupation);
    while (my $row = $rs->next) {
        $vars->{this_month_num}++;
        $this_countries{$row->country}++;
        $this_source{$row->source}++;
        $this_occupation{$row->occupation}++;
    }
    my $this_month_lose_num; # get lose for this month
    if ($list_id) {
        $this_month_lose_num = $self->count_literal('DATE_FORMAT(modified, "%Y-%m") = ? AND list_id = ? and active=0', $this_month, $list_id);
    } else {
        $this_month_lose_num = $self->count_literal('DATE_FORMAT(modified, "%Y-%m") = ? AND site_id = ? and active=0', $this_month, $site_id);
    }
    $vars->{this_month} = $this_month;
    $vars->{this_month_lose_num} = $this_month_lose_num;
    $vars->{this_countries} = \%this_countries;
    $vars->{this_source} = \%this_source;
    $vars->{this_occupation} = \%this_occupation;

    # get last month
    if ($list_id) {
        $rs = $self->search_literal('DATE_FORMAT(created, "%Y-%m") = ? AND list_id = ? and active=1', $last_month, $list_id);
    } else {
        $rs = $self->search_literal('DATE_FORMAT(created, "%Y-%m") = ? AND site_id = ? and active=1', $last_month, $site_id);
    }
    my (%last_countries, %last_source, %last_occupation);
    while (my $row = $rs->next) {
        $vars->{last_month_num}++;
        $last_countries{$row->country}++;
        $last_source{$row->source}++;
        $last_occupation{$row->occupation}++;
    }
    my $last_month_lose_num; # get lose for this month
    if ($list_id) {
        $last_month_lose_num = $self->count_literal('DATE_FORMAT(modified, "%Y-%m") = ? AND list_id = ? and active=0', $last_month, $list_id);
    } else {
        $last_month_lose_num = $self->count_literal('DATE_FORMAT(modified, "%Y-%m") = ? AND site_id = ? and active=0', $last_month, $site_id);
    }
    $vars->{last_month} = $last_month;
    $vars->{last_month_lose_num} = $last_month_lose_num;
    $vars->{last_countries} = \%last_countries;
    $vars->{last_source} = \%last_source;
    $vars->{last_occupation} = \%last_occupation;

    # charts
    # Country Chart
    my (@label, @data);
    foreach my $k (sort { $this_countries{$b} <=> $this_countries{$a} } keys %this_countries) {
        push @label, $k eq '' ? 'Undefined' : $k;
        push @data, $this_countries{$k};
    }
    my $country_chart = URI::GoogleChart->new('pie', 300, 160,
        data  => \@data,
        label => \@label,
        title => 'Subscribers By Countries',
    );
    $country_chart = encode_entities($country_chart);
    # Occupation Chart
    @label = (); @data = ();
    foreach my $k (sort { $this_occupation{$b} <=> $this_occupation{$a} } keys %this_occupation) {
        push @label, $k eq '' ? 'Undefined' : $k;
        push @data, $this_occupation{$k};
    }
    my $occupation_chart = URI::GoogleChart->new('pie', 400, 160,
        data  => \@data,
        label => \@label,
        title => 'Subscribers By Type',
    );
    $occupation_chart = encode_entities($occupation_chart);
    # Source Chart
    @label = (); @data = ();
    foreach my $k (sort { $this_source{$b} <=> $this_source{$a} } keys %this_source) {
        push @label, $k eq '' ? 'Undefined' : $k;
        push @data, $this_source{$k};
    }
    my $source_chart = URI::GoogleChart->new('pie', 300, 160,
        data  => \@data,
        label => \@label,
        title => 'Subscribers By Source',
    );
    $source_chart = encode_entities($source_chart);
    
    

    $vars->{country_chart} = $country_chart;
    $vars->{source_chart} = $source_chart;
    $vars->{occupation_chart} = $occupation_chart;
    $vars->{gain_lose_chart} = $self->gain_loss_over_time($site_id, $list_id, $this_month);
    
    return $vars;
}

sub gain_loss_over_time {
    my ($self, $site_id, $list_id, $this_month) = @_;
    
    my $schema = $self->result_source->schema;
    my $dbh = $schema->storage->dbh;
    
    my ($this_y, $this_m) = split(/\-/, $this_month);
    my $last_six_month = $this_m > 6 ? sprintf('%04d-%02d', $this_y, $this_m - 6) : sprintf('%04d-%02d', $this_y - 1, $this_m + 6);
    
    # Chart: Growth/loss over time
    my $sth;
    if ($list_id) {
        my $sql = qq~select DATE_FORMAT(created, "%Y-%m") as dt, count(*) from subscriber where list_id = ? and active=1 and created >= ? group by dt;~;
        $sth = $dbh->prepare($sql);
        $sth->execute($list_id, $last_six_month);
    } else {
        my $sql = qq~select DATE_FORMAT(created, "%Y-%m") as dt, count(*) from subscriber where site_id = ? and active=1 and created >= ? group by dt;~;
        $sth = $dbh->prepare($sql);
        $sth->execute($site_id, $last_six_month);
    }
    my %gain_stats;
    while (my ($dt, $cnt) = $sth->fetchrow_array) {
        $gain_stats{$dt} = $cnt;
    }
    # Loss
    if ($list_id) {
        my $sql = qq~select DATE_FORMAT(modified, "%Y-%m") as dt, count(*) from subscriber where list_id = ? and active=0 and modified >= ? group by dt;~;
        $sth = $dbh->prepare($sql);
        $sth->execute($list_id, $last_six_month);
    } else {
        my $sql = qq~select DATE_FORMAT(modified, "%Y-%m") as dt, count(*) from subscriber where site_id = ? and active=0 and modified >= ? group by dt;~;
        $sth = $dbh->prepare($sql);
        $sth->execute($site_id, $last_six_month);
    }
    my %loss_stats;
    while (my ($dt, $cnt) = $sth->fetchrow_array) {
        $loss_stats{$dt} = $cnt;
    }

    my (@label, @gain, @loss);
    my @month_abbr = month_abbr();
    my @all_months = (keys %gain_stats, keys %loss_stats);
    my %all_months = map { $_ => 1 } @all_months;
    @all_months = sort( keys %all_months );
    foreach my $m (@all_months) {
        my ($ty, $tm) = split(/\-/, $m);
        push @label, $month_abbr[$tm - 1];
        push @gain,  $gain_stats{$m} || 0;
        push @loss,  $loss_stats{$m} || 0;
    }

    my $gain_lose_chart = URI::GoogleChart->new('lines', 300, 200,
        data => [
            { range => "a", v => \@gain },
    	    { range => "a", v => \@loss },
        ],
        range => {
    	    a => { round => 1, show => "left" },
        },
        color => ["red", "blue"],
        label => ["Gain", "Loss"],
        chxl => "0:|" . join('|', @label),
        chxt => "x",
        margin => 30,
        title => 'Gain/Lose Over Time'
    );
    $gain_lose_chart = encode_entities($gain_lose_chart);
    return $gain_lose_chart;
}

1;