use 5.006;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Devel::REPL::Plugin::LoadScript',
    license             => 'Artistic_2_0',
    dist_author         => q{Pablo Rodríguez González <pablo.rodriguez.gonzalez at bigwebserachenginemailservice>},
    dist_version_from   => 'lib/Devel/REPL/Plugin/LoadScript.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'Devel::REPL' => 0,
        'Path::Tiny' => 0,
    },
    add_to_cleanup     => [ 'Devel-REPL-Plugin-LoadScript-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
