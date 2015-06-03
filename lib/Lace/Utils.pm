package Lace::Utils;

use Scalar::Util ();
use Moo::Role;

=head2 get_attribute

Given the name of an attribute at the top of a selection, return it.  If the
select has more than one match, return each value into an array:

    my $zoom = HTML::Zoom->from_html(<<HTML);
      <body>
        <p data-zoom="Poets">
          <div>aaa</div>
          <div data-zoom="Users1">bbb</div>
        </p>
        <div data-zoom="Users2">ccc</div>
        <div data-zoom="Users3">ddd</div>
      </body>
    HTML

    $zoom->select('*[data-zoom]')
      ->get_attribute('data-zoom', \my @data)
      ->run;

    ## @data = ('Poets','Users1', 'Users2', 'Users3');

Similar in spirit to L</collect> but for attributes instead of content.

=cut

sub get_attribute {
  my ($self, $attr, $return_array) = @_;
  return sub {
    push @$return_array, $_[0]->{attrs}->{$attr};
    return $_[0];
  };
}

=head2 fill

Mega fill tool

=cut

my $next_item_from_array = sub {
  my @items = @_;
  return sub { shift @items };      
};

my $next_item_from_proto = sub {
  my $proto = shift;
  if (
    ref $proto eq 'ARRAY' ||
    ref $proto eq 'HASH' ||
    Scalar::Util::blessed($proto)
  ) {
    return $next_item_from_array->($proto, @_);
  } elsif(ref $proto eq 'CODE' ) {
    return $proto;
  } else {
    die "Don't know what to do with $proto, it's a ". ref($proto);
  }
};

my $normalize_targets = sub {
  my $targets = shift;
  my $targets_type = ref $targets;
  return $targets_type eq 'ARRAY' ? $targets
    : $targets_type eq 'HASH' ? [ map { +{$_=>$targets->{$_}} } keys %$targets ]
      : die "targets data structure ". ref($targets). " not understood";
};

my $replace_from_hash_or_object = sub {
  my ($datum, $value) = @_;
  return ref($datum) eq 'HASH' ?
    $datum->{$value} : $datum->$value; 
};

sub fill {
  my ($zoom, $targets, @rest) = @_;
  $zoom->repeat_content(sub {
    my $itr = $next_item_from_proto->(@rest);
    $targets = $normalize_targets->($targets);
    HTML::Zoom::CodeStream->new({
      code => sub {
        my $cnt = 0;
        if(my $datum = $itr->($zoom, $cnt)) {
          $cnt++;
          return sub {
            for my $idx(0..$#{$targets}) {
              my $target = $targets->[$idx];
              my ($match, $replace) = do {
                my $type = ref $target;
                $type ? ($type eq 'HASH' ? do { 
                    my ($match, $value) = %$target;
                    ref $value eq 'CODE' ?
                      ($match, $value->($datum, $idx, $_))
                      : ($match, $replace_from_hash_or_object->($datum, $value));
                  } : die "What?")
                  : do {
                      ref($datum) eq 'ARRAY' ?
                      ($target, $datum->[$idx]) :
                      ( '.'.$target, $replace_from_hash_or_object->($datum, $target));
                    };
              };
              $_ = $_->select($match)
                ->replace_content($replace);                
            } $_;
          };
        } else {
          return;
        }
      },
    });
  });
}

1;
