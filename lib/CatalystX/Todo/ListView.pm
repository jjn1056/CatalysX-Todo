package CatalystX::Todo::ListView;

use Moo;
use HTML::Zoom;

  use Scalar::Util ();
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
  
  my $fill = sub {
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
  };

has response => (is=>'ro', required=>1);
has template => (is=>'ro', required=>1);

has zoomer => (
  is=>'rw',
  lazy=>1,
  required=>1,
  builder=>'_build_zoomer');

  sub _build_zoomer {
    my $self = shift;
    return HTML::Zoom->from_file(
      $self->template);
  }
    
sub apply_list {
  my ($self, $resultset) = @_;
  my $hz = $self->zoomer->select('.data-row')->$fill(
    [qw/priority description current_status/],
    $resultset->all);

  $self->zoomer($hz);
}

sub send_response {
  my ($self) = @_;
  $self->response->content_type('text/html');
  $self->response->body(
    $self->zoomer->to_fh);
}

1;
