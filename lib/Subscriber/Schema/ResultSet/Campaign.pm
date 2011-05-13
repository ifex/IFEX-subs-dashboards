package Subscriber::Schema::ResultSet::Campaign;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';
use URI::GoogleChart;
use HTML::Entities;
use List::Util 'shuffle';
use Dashboard::Consts qw/month_abbr/;

my %campaign_type = (
    open => 1,
    click => 2,
);

# get site overview or certain list stats
sub basic_stats {
    my ($self, $list_id, $this_month) = @_;
    
    # set default month as this month
    unless ($this_month and $this_month =~ /^20(\d{2})\-(\d{2})\-01$/) {
        my @d = localtime();
        $this_month = sprintf('%04d-%02d-01', $d[5] + 1900, $d[4] + 1);
    }

    my $schema = $self->result_source->schema;
    my $dbh = $schema->storage->dbh;

    my %vars;
    my %campaigns;
    
    # example, this_month as '2010-03', last_month as '2010-02'
    my ($this_y, $this_m) = split(/\-/, $this_month);
    my $last_month = $this_m == 1 ? sprintf('%04d-%02d-01', $this_y - 1, 12) : sprintf('%04d-%02d-01', $this_y, $this_m - 1);
    $vars{this_month} = $this_month;
    
    # get all months
    my @month_abbr = month_abbr();
    $vars{month_abbr} = \@month_abbr;
    my $sql = 'SELECT mon FROM campaign_summary WHERE list_id = ? group by mon order by mon';
    my $sth = $dbh->prepare($sql);
    $sth->execute($list_id);
    my @all_months;
    while (my ($mm) = $sth->fetchrow_array) {
        my ($y, $m) = split(/\-/, $mm);
        push @all_months, {
            label => $month_abbr[$m - 1] . ' ' . $y,
            value => sprintf('%04d-%02d-01', $y, $m)
        };
    }
    $vars{all_months} = \@all_months;

    # this month
    $self->_openclick_by_month($list_id, $this_month, \%vars, \%campaigns);
    $self->_avg_openclick_by_last6month($list_id, $this_month, \%vars);

    $vars{campaigns} = \%campaigns;
    return \%vars;
}

sub _openclick_by_month {
    my ($self, $list_id, $month, $vars, $campaigns) = @_;
    
    my $schema = $self->result_source->schema;
    
    ### we have two parts, open and click
    # open
    my $rs = $schema->resultset('CampaignSummary')->search( {
        mon => $month,
        list_id => $list_id,
        type => $campaign_type{open}
    }, {
        order_by => 'num desc'
    } );
    while (my $row = $rs->next) {
        unless (exists $campaigns->{ $row->campaign_id }) {
            $campaigns->{ $row->campaign_id } = $self->find( $row->campaign_id );
        }
        push @{ $vars->{open} }, $row;
    }
    $vars->{open} ||= [];
    my %colors = %URI::GoogleChart::COLOR_ALIAS;
    delete $colors{white};
    delete $colors{transparent};
    my @colors = shuffle values %colors;
    while (scalar(@colors) < scalar(@{ $vars->{open} })) { push @colors, shuffle values %colors };
    @colors = splice(@colors, 0, scalar(@{ $vars->{open} }));
    $vars->{open_colors} = [ @colors ];

    # click
    $rs = $schema->resultset('CampaignSummary')->search( {
        mon => $month,
        list_id => $list_id,
        type => $campaign_type{click}
    }, {
        order_by => 'num desc'
    } );
    while (my $row = $rs->next) {
        unless (exists $campaigns->{ $row->campaign_id }) {
            $campaigns->{ $row->campaign_id } = $self->find( $row->campaign_id );
        }
        push @{ $vars->{click} }, $row;
    }
    $vars->{click} ||= [];
    @colors = shuffle values %colors;
    while (scalar(@colors) < scalar(@{ $vars->{click} })) { push @colors, shuffle values %colors };
    @colors = splice(@colors, 0, scalar(@{ $vars->{click} }));
    $vars->{click_colors} = [ @colors ];
}

sub _avg_openclick_by_last6month {
    my ($self, $list_id, $month, $vars) = @_;
    
    my $schema = $self->result_source->schema;
    my $dbh = $schema->storage->dbh;
    
    # get all months
    my ($y, $m) = split('-', $month);
    my @all_months = ($month);
    while (1) {
        $m--;
        if ($m == 0) { $y--; $m = 12 }
        unshift @all_months, sprintf('%04d-%02d-01', $y, $m);
        last if @all_months >= 6;
    }

    my $sql = 'SELECT SUM(FLOOR( 100 * num DIV total + 0.5 )), COUNT(*) FROM campaign_summary WHERE type = ? AND mon = ? AND list_id = ?';
    my $sth = $dbh->prepare($sql);

    # get open data
    my @avg_open;
    foreach my $mon (@all_months) {
        $sth->execute( $campaign_type{open}, $mon, $list_id ) or die $dbh->errstr;
        my ($sum, $cnt) = $sth->fetchrow_array;
        push @avg_open, $cnt > 0 ? int($sum/$cnt) : 0;
    }
    
    # get click data
    my @avg_click;
    foreach my $mon (@all_months) {
        $sth->execute( $campaign_type{click}, $mon, $list_id ) or die $dbh->errstr;
        my ($sum, $cnt) = $sth->fetchrow_array;
        push @avg_click, $cnt > 0 ? int($sum/$cnt) : 0;
    }

    my @labels;
    my @month_abbr = month_abbr();
    foreach my $i (0 .. $#all_months) {
        my $mon = $all_months[$i];
        my ($ty, $tm) = split(/\-/, $mon);
        push @labels, $month_abbr[$tm - 1];
    }

    my $gain_lose_chart = URI::GoogleChart->new('lines', 300, 200,
        data => [
            { range => "a", v => \@avg_open },
    	    { range => "a", v => \@avg_click },
        ],
        range => {
    	    a => { round => 1, show => "left" },
        },
        color => ["red", "blue"],
        label => ["Open", "Click"],
        chxl => "0:|" . join('|', @labels),
        chxt => "x",
        margin => 30,
        title => 'Open/Click Over Time'
    );
    $vars->{openclick_last6month} = encode_entities($gain_lose_chart);
}

1;