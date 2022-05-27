cmake_minimum_required( VERSION 3.16.3 )

project( jsd-foreign-libraries-configuration )


option( BUILD_SHARED_LIBS "Build using shared libraries" ON )

add_subdirectory( 0000-FreeGLUT )
add_subdirectory( 0001-zlib )
add_subdirectory( 0002-png )
add_subdirectory( 0012-bzip2 )
add_subdirectory( 0013-hardbuzz )
add_subdirectory( 0003-freetype2 )
add_subdirectory( 0004-glew-cmake )
add_subdirectory( 0005-SDL )
add_subdirectory( 0006-openal-soft )

set( OPENAL_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/0006-openal-soft/include  )
set( OPENAL_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0006-openal-soft/libopenal.so )

add_subdirectory( 0007-freealut )
add_subdirectory( 0008-ogg )

set( OGG_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/0008-ogg/include )
set( OGG_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0008-ogg/libogg.so )

add_subdirectory( 0009-vorbis )

set( VORBIS_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/0009-vorbis/include )
set( VORBIS_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/0009-vorbis/include )
set( VORBIS_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0009-vorbis/lib/libvorbis.so )
set( VORBISENC_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0009-vorbis/lib/libvorbisenc.so )
set( VORBISFILE_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0009-vorbis/lib/libvorbisfile.so )

add_subdirectory( 0010-flac )

set( FLAC_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/0010-flac/include )
set( FLAC_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0010-flac/src/libFLAC/FLAC.so )

add_subdirectory( 0011-SFML )

