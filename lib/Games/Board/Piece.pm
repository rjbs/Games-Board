use strict;
use warnings;

package Games::Board::Piece;

use Carp;

=head1 NAME

Games::Board::Piece -- a parent class for board game pieces

=head1 VERSION

 $Id$

=cut

our $VERSION = '1.011';

=head1 SYNOPSIS

  use Games::Board;

  my $board = Games::Board->new;

  $board->add_space(
  	id   => 'go',
	dir  => { next => 'mediterranean', prev => 'boardwalk' },
	cost => undef
  );

  my $tophat = Games::Board::Piece->new(id => 'tophat')->move(to => 'go');

=head1 DESCRIPTION

This module provides a base class for representing the pieces in a board game.  

=cut

=head1 METHODS

=over

=item C<< new >>

This method constructs a new game piece and returns it.

=cut

sub new {
  my ($class, %args) = @_;

  return unless $args{id};
  return unless eval { $args{board}->isa('Games::Board') };

  my $piece = { %args };

  bless $piece => $class;
}

=item C<< id >>

This returns the piece's id.

=cut

sub id {
  my $self = shift;
  $self->{id};
}

=item C<< board >>

This returns the board object to which the piece is related.

=cut

sub board {
  my $self = shift;
  $self->{board};
}

=item C<< current_space_id >>

This returns the id of the space on which the piece currently rests, if any.
It it's not on any space, it returns undef.

=cut

sub current_space_id {
  my $piece = shift;
  $piece->{current_space};
}

=item C<< current_space >>

This returns the Space on which the piece currently rests, if any.  It it's not
on any space, it returns undef.

=cut

sub current_space {
  my $piece = shift;
  return unless $piece->{current_space};
  $piece->board->space($piece->{current_space});
}

=item C<< move(dir => 'up') >>

=item C<< move(to  => $space) >>

This method moves the piece to a new space on the board.  If the method call is
in the first form, the piece is moved to the space in the given direction from
the piece's current space.  If the method call is in the second form, and
C<$space> is a Games::Board::Space object, the piece is moved to that space.

=cut 

sub move {
  my $piece = shift;
  my ($how, $which) = @_;
  my $space;
  
  if ($how eq 'dir') {
	return unless $piece->current_space;
	return unless $space = $piece->current_space->dir($which);
  } elsif ($how eq 'to') {
	return unless eval { $which->isa('Games::Board::Space') };
	$space = $which;
  } else {
	return;
  }
  
  $space->receive($piece);
}

=back

=head1 TODO

implement this dist!

=head1 AUTHOR

Ricardo SIGNES E<lt>rjbs@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2003-2004 by Ricardo Signes E<lt>rjbs@cpan.orgE<gt>

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut

1;
