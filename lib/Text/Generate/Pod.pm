
package Text::Generate::Pod;

use strict;
use warnings;

use IO::String;
use Pod::Usage qw(pod2usage);

use File::Temp qw{tmpnam};
use File::Slurp qw( write_file );
use Try::Tiny;

use parent qw( Text::Generate::Base );

###__ACCESSORS_SCALAR
our @scalar_accessors=qw();

###__ACCESSORS_HASH
our @hash_accessors=qw();

###__ACCESSORS_ARRAY
our @array_accessors=qw();

__PACKAGE__
    ->mk_scalar_accessors(@scalar_accessors)
    ->mk_array_accessors(@array_accessors)
    ->mk_hash_accessors(@hash_accessors)
    ->mk_new;

sub init {
    my $self = shift;

    $self->Text::Generate::Base::init;

    $self->_pod_line('=pod');

}

sub cut {
    my $self=shift;

    $self->_pod_line('=cut');

}

sub _pod_line {
    my $self=shift;

    my $text=shift;

    $self->_add_line($text);
    $self->_add_line(' ');

}

sub back {
    my $self=shift;

    $self->_pod_line('=back');
}

sub over {
    my $self=shift;

    my $ref=shift;

    my $items;
    my $indent=4;
	
	unless(ref $ref){
        $indent=$ref;
        $self->_pod_line('=over ' . $indent ); 
        return;
        
	}elsif(ref $ref eq "ARRAY"){
	    
	}elsif(ref $ref eq "HASH"){
        $items=$ref->{items};
	}

    $self->_pod_line('=over ' . $indent);

    foreach my $item (@$items) {
        $self->item($item);
    }

    $self->_pod_line('=back');

}


sub head1 {
    my $self=shift;

    my $text=shift;

    $self->_pod_line('=head1 ' . $text);

}

sub head2 {
    my $self=shift;

    my $text=shift;

    $self->_pod_line('=head2 ' . $text);

}

sub head3 {
    my $self=shift;

    my $text=shift;

    $self->_pod_line('=head3 ' . $text);

}

sub head4 {
    my $self=shift;

    my $text=shift;

    $self->_pod_line('=head4 ' . $text);

}


sub item {
    my $self=shift;

    my $item=shift;

    $self->_pod_line('=item ' . $item);

}

sub _print_man {
    my $self=shift;

    $self->_print_pod(2);
}

sub _print_help {
    my $self=shift;

    $self->_print_pod(1);
}


sub _print_pod {
    my $self=shift;

    my $verbose=shift;

    my $POD=tmpnam();

    try { 
        write_file($POD,$self->text);
    } catch {
        warn "Failed to write temporary file " . $POD;
        $POD=IO::String->new($self->text);
    } finally {
        pod2usage( -input => $POD, -verbose => $verbose );
    }


}

1;
