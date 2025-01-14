VERIFY_HEADER_SETS
------------------

.. versionadded:: 3.24

Used to verify that all headers in a target's header sets can be included on
their own.

When this property is set to true, and the target is an object library, static
library, shared library, or executable with exports enabled, and the target
has one or more header sets, an object library target named
``<target_name>_verify_header_sets`` is created. This verification target has
one source file per header in the header sets. Each source file only includes
its associated header file. The verification target links against the original
target to get all of its usage requirements. The verification target has its
:prop_tgt:`EXCLUDE_FROM_ALL` and :prop_tgt:`DISABLE_PRECOMPILE_HEADERS`
properties set to true, and its :prop_tgt:`AUTOMOC`, :prop_tgt:`AUTORCC`,
:prop_tgt:`AUTOUIC`, and :prop_tgt:`UNITY_BUILD` properties set to false.

If the header's :prop_sf:`LANGUAGE` property is set, the value of that property
is used to determine the language with which to compile the header file.
Otherwise, if the target has any C++ sources, the header is compiled as C++.
Otherwise, if the target has any C sources, the header is compiled as C.
Otherwise, the header file is not compiled.
