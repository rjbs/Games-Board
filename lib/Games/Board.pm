#!/usr/bin/perl

package Games::Board;

use Carp;
use Games::Board::Space;
use Games::Board::Piece;

=head1 NAME

Games::Board -- a parent class for board games

=head1 SYNOPSIS

	use Games::Board;

	my $board = Games::Board->new;

	$board->add_space(
		id  => 'go',
		dir => { next => 'mediterranean', prev => 'boardwalk' },
		cost => undef
	);

	my $tophat = Games::Board::Piece->new(id => 'tophat')->move(to => 'go');

=head1 DESCRIPTION

This module provides a base class for representing board games.  

=cut

use strict;
use warnings;

our $VERSION = sprintf "%d.%03d", q$Revision: 1.10 $ =~ /(\d+)/g;

=head1 METHODS

=over

=item C<< new >>

This method constructs a new game board and returns it.  As constructed it has
no spaces or pieces on it.

=cut

sub new {
	my $class = shift;

	my $board = {
	spaces => { }
	};

	bless $board => $class;
}

=item C<< space($id) >>

This method returns the space with the given C<$id>.  If no space with that id
exists, undef is returned.

=cut

sub space {
	my $board = shift;
	my $space = shift;

	return $board->{spaces}{$space};
}

=item C<< add_space(%args) >>

This method adds a space to the board.  It is passed a hash of attributes to
use in creating a Games::Board::Space object.  The object is created by calling
the constructor on the class whose name is returned by the C<spaceclass>
method.  This class must inherit from Games::Board::Space.

=cut 

sub add_space {
	my ($board, %args) = @_;
	my $space;

	$space = $board->spaceclass->new(board => $board, %args);

	return unless UNIVERSAL::isa($space,'Games::Board::Space');

	if ($board->space($space->id)) {
	carp "space '" . $space->id . "' already exists on board";
	} else {
	$board->{spaces}{$space->id} = $space;
	return $space;
	}
}

=item C<< piececlass >>

This method returns the class used for pieces on this board.

=cut

sub piececlass { 'Games::Board::Piece' }

=item C<< spaceclass >>

This method returns the class used for spaces on this board.

=cut

sub spaceclass { 'Games::Board::Space' }

=item C<< add_piece(%args) >>

This method adds a piece to the board.  It is passed a hash of attributes to
use in creating a Games::Board::Piece object.  The object is created by calling
the constructor on the class whose name is returned by the C<piececlass>
method.  This class must inherit from Games::Board::Piece.

=cut 

sub add_piece {
	my $board = shift;
	my %args = @_;
	my $piece;

	$piece = $board->piececlass->new(board => $board, @_);
	$piece ||= shift;

	return unless UNIVERSAL::isa($piece,'Games::Board::Piece');

	return $piece;
}

=back

=head1 TODO

Lots.  First up: write a TODO list.

=head1 SEE ALSO

=over 

=item *

L<Games::Board::Piece>

=item *

L<Games::Board::Space>

=item *

L<Games::Board::Grid>

=back

=head1 AUTHORS

Ricardo SIGNES E<lt>rjbs@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2003-2004 by Ricardo Signes E<lt>rjbs@cpan.orgE<gt>

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut

"Family fun night!";
