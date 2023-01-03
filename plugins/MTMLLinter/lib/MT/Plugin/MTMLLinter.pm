package MT::Plugin::MTMLLinter;

use strict;
use warnings;
use utf8;

use File::Basename qw(basename dirname);

sub component {
    __PACKAGE__ =~ m/::([^:]+)\z/;
}

sub plugin {
    MT->component( component() );
}

sub insert_after {
    my ( $tmpl, $id, $tokens ) = @_;

    my $before = $id ? $tmpl->getElementById($id) : undef;
    if ( $id && !$before ) {
        $before = $tmpl->getElementsByName($id)->[0];
    }

    if ( !ref $tokens ) {
        $tokens = plugin()->load_tmpl($tokens)->tokens;
    }

    foreach my $t (@$tokens) {
        $tmpl->insertAfter( $t, $before );
        $before = $t;
    }
}

sub template_param_edit_template {
    my ( $cb, $app, $param, $tmpl ) = @_;

    my $static_path = do {
        my $plugin      = plugin();
        my $static      = $app->static_path;
        my $plugin_name = basename( $plugin->{full_path} );
        my $dir         = basename( dirname( $plugin->{full_path} ) );
        "$static$dir/$plugin_name";
    };
    my $version = plugin()->version;
    insert_after( $tmpl, 'jq_js_include', 'edit_template.tmpl' );
    insert_after(
        $tmpl,
        'jq_js_include',
        [   $tmpl->createElement(
                'var',
                {   name  => 'plugin_mtml_linter_static_path',
                    value => $static_path,
                }
            ),
            $tmpl->createElement(
                'var',
                {   name  => 'plugin_mtml_linter_version',
                    value => $version,
                }
            ),
        ]
    );
}

1;
