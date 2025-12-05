project('xcb-util-xrm', 'c',
  version: '1.3',
  default_options: ['c_std=c99', 'warning_level=3'])

cc = meson.get_compiler('c')

add_project_arguments('-D_GNU_SOURCE', language: 'c')

# Dependencies
dep_xcb = dependency('xcb')
dep_xcb_aux = dependency('xcb-aux')
dep_x11 = dependency('x11', required: false) # Only for tests
dep_m = cc.find_library('m', required: false)

inc = include_directories('include')

# Library sources
srcs = files(
  'src/database.c',
  'src/resource.c',
  'src/entry.c',
  'src/match.c',
  'src/util.c',
)

# Shared library
lib = library('xcb-xrm',
  srcs,
  dependencies: [dep_xcb, dep_xcb_aux, dep_m],
  include_directories: inc,
  version: '0.0.0',
  soversion: '0',
  install: true,
)

# Headers
install_headers('include/xcb_xrm.h', subdir: 'xcb')

# Pkg-config
pkg = import('pkgconfig')
pkg.generate(lib,
  name: 'XCB xrm',
  description: 'XCB utility functions for the X resource manager',
  version: meson.project_version(),
  filebase: 'xcb-xrm',
  requires: ['xcb', 'xcb-aux'],
)

configure_file(input: 'xcb_xrm_intro.in',
  output: 'xcb_xrm_intro',
  copy: true)

# Tests
if get_option('buildtype') != 'release'
  
  # tests_parser
  test_parser = executable('tests_parser',
    ['tests/tests_utils.c', 'tests/tests_parser.c'],
    include_directories: inc,
    link_with: lib,
  )
  test('parser', test_parser)

  # tests_match
  if dep_x11.found()
    test_match = executable('tests_match',
      ['tests/tests_utils.c', 'tests/tests_match.c'],
      include_directories: inc,
      dependencies: dep_x11,
      link_with: lib,
    )
    test('match', test_match)
  endif

  # tests_database
  test_database = executable('tests_database',
    ['tests/tests_utils.c', 'tests/tests_database.c'],
    include_directories: inc,
    dependencies: [dep_xcb, dep_xcb_aux],
    link_with: lib,
  )

  xvfb_run = find_program('xvfb-run', required: false)
  xvfb_bin = find_program('Xvfb', required: false)
  
  if xvfb_run.found()
    test('database', xvfb_run,
      args: ['--auto-servernum', test_database],
      env: ['srcdir=' + meson.current_source_dir()]
    )
  elif xvfb_bin.found()
    runner = find_program('tests/headless_runner.sh')
    test('database', runner,
      args: [test_database],
      env: ['srcdir=' + meson.current_source_dir()]
    )
  else
    # If neither is found, we can't run this test reliably in headless env.
    # We try running it directly, hoping user has an X server.
    test('database', test_database,
      env: ['srcdir=' + meson.current_source_dir()]
    )
  endif

endif
