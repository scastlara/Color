#################################################################################
#                               Gradient.pm										#
#################################################################################

#================================================================================
#        Copyright (C) 2014 
# This is a modified version of the script found here: 
# http://blogs.perl.org/users/ovid/2010/12/perl101-red-to-green-gradient.html
#================================================================================

package Color::Gradient;

use Moose;

# --------------------------------------------
# ATTRIBUTES

has 'number' => (
	isa => "Int",
	is => "rw",
	required => 1
);

has 'test' => (
	isa => "Bool",
	is => "rw"
);


# --------------------------------------------
# METHODS

sub get_gradient {
	my $self = shift;
	my $steps = $self->number;
	my $first = [ 0xFF, 0x00, 0x00 ];
	my $last = [ 0x00, 0xFF, 0x00 ];

	if ($self->test) {
		open my $html_fh, '>', "test_$steps.html",
			or die "Canot write to test_$steps.html : $!\n";

		__print_header($html_fh);
	}
	
	my $step = [
    	__step( $first->[0], $last->[0], $steps ),
    	__step( $first->[1], $last->[1], $steps ),
    	__step( $first->[2], $last->[2], $steps ),
	];

	my $gradients = [ ( undef ) x $steps ];

	my @colors;

	for my $i ( 0 .. $#{ $gradients } ) {
		if ( $i == 0 ) {
		    $gradients->[$i] = $first;
		} elsif ( $i == $#{ $gradients } ) {
		    $gradients->[$i] = $last;
		} else {
			$gradients->[$i] = [
   		        $gradients->[ $i - 1 ][0] + $step->[0],
   		        $gradients->[ $i - 1 ][1] + $step->[1],
   		        $gradients->[ $i - 1 ][2] + $step->[2],
   		    ];
   		}

		my $hex = sprintf "%02X%02X%02X", @{ $gradients->[ $i ] };
		push @colors, $hex;

		if ($self->test) {
			open my $html_fh, '>>', "test_$steps.html",
				or die "Canot write to test_$steps.html : $!\n";
			print $html_fh "<tr><td bgcolor=\"$hex\">$hex</td></tr>", "\n";
		}

	} # for gradient

	return \@colors;

} # sub get_gradient


# --------------------------------------------
sub __step { # PRIVATE!
    my ( $first, $last, $steps ) = @_;

    $steps -= 1;

    my $sign = $last <=> $first;
    my $step = int( ( $first + $last ) / $steps );

    return $sign == 0 ? $step : $sign * $step;
} 

# --------------------------------------------
sub __print_header {
	my $fh   = shift;


	print $fh <<'EOF'
Content-Type: text/html; charset=ISO-8859-1

<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html
        PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en-US" xml:lang="en-US"><head><title>Untitled Document</title>
</head><body><table cellspacing="0"><tr><td>Offsets 31 54 55</td></tr>
EOF
;

	return;
}



1;
