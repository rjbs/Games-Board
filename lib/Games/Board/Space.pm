use strict;
use warnings;

package Games::Board::Space;

use Carp;

=head1 NAME

Games::Board::Space -- a parent class for spaces on game board

=head1 VERSION

 $Id$

=cut

our $VERSION = '1.011';

=head1 SYNOPSIS

  use Games::Board;

  my $board = Games::Board->new;

  $board->add_space(Games::Board::Space->new(
  	id   => 'go',
	dir  => { next => 'mediterranean', prev => 'boardwalk' },
	cost => undef
  ));

  my $tophat = Games::Board::Piece->new(id => 'tophat')->move(to => 'go');

=head1 DESCRIPTION

This module provides a base class for representing the spaces on a game board.

=cut

=head1 METHODS

=over

=item C<< new >>

This method constructs a new space and returns it.

=cut

sub new {
  my $class = shift;
  my %args  = @_;

  return unless $args{id};
  croak "no board supplied in space creation"
    unless eval { $args{board}->isa('Games::Board') };

  my $space = {
	id    => $args{id},
	board => $args{board},
  };

  $space->{dir} = $args{dir}
	if $args{dir} and (ref $args{dir} eq 'HASH');

  bless $space => $class;
}

=item C<< id >>

This method returns the id of the space.

=cut

sub id {
  my $space = shift;

  return $space->{id};
}

=item C<< board >>

This method returns board on which this space sits.

=cut

sub board {
  my $space = shift;
  $space->{board};
}

=item C<< dir_id($dir) >>

This method returns the id of the space found in the given direction from this
space.

=cut

sub dir_id {
  my ($space, $dir) = @_;
  
  return $space->{dir}{$dir} if (ref $space->{dir} eq 'HASH');
}

=item CC<< dir($dir) >>

This method returns the space found in the given direction from this space.

=cut

sub dir {
  my ($space, $dir) = @_;
  $space->board->space($space->dir_id($dir));
}

=item C<< contains($piece) >>

This method returns a true value if the space contains the passed piece.

=cut

sub contains {
  my ($self, $piece) = @_;
  return 1 if grep { $_ eq $piece->id } @{$self->{contents}};
}

=item C<< receive($piece) >>

This method will place the given piece onto this space.

=cut

sub receive {
  my ($self, $piece) = @_;

  return unless eval { $piece->isa('Games::Board::Piece') };
  return if $self->contains($piece);

  $piece->{current_space} = $self->id;
  push @{$self->{contents}}, $piece->id;
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
