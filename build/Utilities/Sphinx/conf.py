# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

import sys
import os
import re
import glob

sys.path.insert(0, r'R:/CMake/Utilities/Sphinx')

source_suffix = '.rst'
master_doc = 'index'

project = 'CMake'
copyright = '2000-2022 Kitware, Inc. and Contributors'
version = '3.23.20220405' # feature version
release = '3.23.20220405-g2f7b1dd' # full version string
pygments_style = 'colors.CMakeTemplateStyle'

language = 'en'
primary_domain = 'cmake'
highlight_language = 'none'

exclude_patterns = [
    'dev', # ignore developer-only documentation
    ]

extensions = ['cmake']
templates_path = ['R:/CMake/Utilities/Sphinx/templates']

nitpicky = True
smartquotes = False

cmake_manuals = sorted(glob.glob(r'R:/CMake/Help/manual/*.rst'))
cmake_manual_description = re.compile('^\.\. cmake-manual-description:(.*)$')
man_pages = []
for fpath in cmake_manuals:
    try:
        name, sec, rst = os.path.basename(fpath).split('.')
        desc = None
        f = open(fpath, 'r')
        for l in f:
            m = cmake_manual_description.match(l)
            if m:
                desc = m.group(1).strip()
                break
        f.close()
        if desc:
            man_pages.append(('manual/%s.%s' % (name, sec),
                              name, desc, [], int(sec)))
        else:
            sys.stderr.write("ERROR: No cmake-manual-description in '%s'\n" % fpath)
    except Exception as e:
        sys.stderr.write("ERROR: %s\n" % str(e))
man_show_urls = False
man_make_section_directory = False

html_show_sourcelink = True
html_static_path = ['R:/CMake/Utilities/Sphinx/static']
html_style = 'cmake.css'
html_theme = 'default'
html_theme_options = {
    'footerbgcolor':    '#00182d',
    'footertextcolor':  '#ffffff',
    'sidebarbgcolor':   '#e4ece8',
    'sidebarbtncolor':  '#00a94f',
    'sidebartextcolor': '#333333',
    'sidebarlinkcolor': '#00a94f',
    'relbarbgcolor':    '#00529b',
    'relbartextcolor':  '#ffffff',
    'relbarlinkcolor':  '#ffffff',
    'bgcolor':          '#ffffff',
    'textcolor':        '#444444',
    'headbgcolor':      '#f2f2f2',
    'headtextcolor':    '#003564',
    'headlinkcolor':    '#3d8ff2',
    'linkcolor':        '#2b63a8',
    'visitedlinkcolor': '#2b63a8',
    'codebgcolor':      '#eeeeee',
    'codetextcolor':    '#333333',
}
html_title = 'CMake %s Documentation' % release
html_short_title = '%s Documentation' % release
html_favicon = 'R:/CMake/Utilities/Sphinx/static/cmake-favicon.ico'
# Not supported yet by sphinx:
# https://bitbucket.org/birkenfeld/sphinx/issue/1448/make-qthelp-more-configurable
# qthelp_namespace = "org.cmake"
# qthelp_qch_name = "CMake.qch"
