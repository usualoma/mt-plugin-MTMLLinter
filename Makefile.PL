use ExtUtils::MakeMaker;
use YAML;

my $config  = YAML::LoadFile((glob('./plugins/*/config.yaml'))[0]);
my $version = $config->{version};

use Getopt::Long 'GetOptions';
GetOptions('version=s' => \$version);

WriteMakefile(
    NAME     => $config->{name},
    VERSION  => $version,
    SKIP     => [qw(distdir)],
    DISTNAME => $config->{name},
);

sub MY::top_targets {
    << 'Makefile';
npm-install:
	npm ci

npm-build:
	npm run build

build-js: npm-install npm-build

build: build-js cp-mtml-parser

cp-mtml-parser:
	mkdir -p mt-static/plugins/MTMLLinter/dist/
	rm -fr mt-static/plugins/MTMLLinter/dist/mtml-parser
	cp -R node_modules/mtml-parser/web mt-static/plugins/MTMLLinter/dist/mtml-parser

create_distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"

distdir : create_distdir build
	$(NOECHO) $(NOOP)

manifest : build

Makefile
}
