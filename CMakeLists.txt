cmake_minimum_required( VERSION 3.16.3 )

project( jsd-foreign-libraries-configuration )

# Copy file
function( JSD_COPY_FILE source destination)
	add_custom_command(OUTPUT "${destination}"
		COMMAND "${CMAKE_COMMAND}"
			-E remove "${destination}"
		COMMAND "${CMAKE_COMMAND}"
			-E copy "${source}" "${destination}"
		DEPENDS "${source}")
endfunction()


option( BUILD_SHARED_LIBS "Build using shared libraries" ON )
option( BUILD_STATIC_LIBS "Build using shared libraries" OFF )

message( STATUS "[JSD] Configuring 0000-FreeGLUT..." )

add_subdirectory( 0000-FreeGLUT )

message( STATUS "[JSD] Configuring 0000-FreeGLUT... done" )
message( STATUS "[JSD] Configuring 0001-zlib..." )

add_subdirectory( 0001-zlib )

JSD_COPY_FILE( ${CMAKE_CURRENT_BINARY_DIR}/0001-zlib/zconf.h ${CMAKE_CURRENT_SOURCE_DIR}/0001-zlib/zconf.h )
add_custom_target( zlib-copy DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/0001-zlib/zconf.h )
add_dependencies( zlib-copy zlib )
file( COPY ${CMAKE_CURRENT_BINARY_DIR}/0001-zlib/zconf.h DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/0001-zlib )

# CACHE INTERNAL "[JSD] " FORCE
set( ZLIB_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/0001-zlib CACHE INTERNAL "[JSD] ZLIB_INCLUDE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}/0001-zlib" FORCE)
set( ZLIB_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0001-zlib/libz.so CACHE INTERNAL "[JSD] ZLIB_LIBRARY = ${CMAKE_CURRENT_BINARY_DIR}/0001-zlib/libz.so" FORCE )

find_package( ZLIB REQUIRED )

message( STATUS "[JSD] Configuring 0001-zlib... done" )
message( STATUS "[JSD] Configuring 0002-png..." )

add_subdirectory( 0002-png )

JSD_COPY_FILE( ${CMAKE_CURRENT_BINARY_DIR}/0002-png/pnglibconf.h ${CMAKE_CURRENT_SOURCE_DIR}/0002-png/pnglibconf.h )
add_custom_target( png-copy DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/0002-png/pnglibconf.h )
add_dependencies( png-copy png )

add_dependencies( png zlib zlib-copy )
add_dependencies( png-fix-itxt zlib )

set( PNG_PNG_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/0002-png CACHE INTERNAL "[JSD] PNG_PNG_INCLUDE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}/0002-png" FORCE )
set( PNG_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0002-png/libpng.so CACHE INTERNAL "[JSD] PNG_LIBRARY = ${CMAKE_CURRENT_BINARY_DIR}/0002-png/libpng.so" FORCE )

find_package( PNG REQUIRED )

message( STATUS "[JSD] Configuring 0002-png... done" )
message( STATUS "[JSD] Configuring 0012-bzip2..." )

add_subdirectory( 0012-bzip2 )

# file( COPY ${CMAKE_CURRENT_BINARY_DIR}/0012-bzip2/bz_version.h DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/0012-bzip2 )

set( BZIP2_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/0012-bzip2 CACHE INTERNAL "[JSD] BZIP2_INCLUDE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}/0012-bzip2" FORCE )
set( BZIP2_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0012-bzip2/libbz2.so CACHE INTERNAL "[JSD] BZIP2_LIBRARY = ${CMAKE_CURRENT_BINARY_DIR}/0012-bzip2/libbz2.so" FORCE)
set( BZIP2_LIBRARIES ${BZIP2_LIBRARY} CACHE INTERNAL "[JSD] BZIP2_LIBRARIES = ${BZIP2_LIBRARY}" FORCE)

message( STATUS "[JSD] Configuring 0012-bzip2... done" )
message( STATUS "[JSD] Configuring 0013-harfbuzz..." )

add_subdirectory( 0013-hardbuzz )

set( HARFBUZZ_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/0013-hardbuzz CACHE INTERNAL "[JSD] HARFBUZZ_INCLUDE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}/0013-hardbuzz" FORCE )
set( HARFBUZZ_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0013-hardbuzz/libharfbuzz.so CACHE INTERNAL "[JSD] HARFBUZZ_LIBRARY = ${CMAKE_CURRENT_BINARY_DIR}/0013-hardbuzz/libharfbuzz.so" FORCE )

message( STATUS "[JSD] Configuring 0013-harfbuzz... done" )
message( STATUS "[JSD] Configuring 0003-freetype2..." )

option( FT_REQUIRE_BZIP2 TRUE )

add_subdirectory( 0003-freetype2 )
add_dependencies( freetype zlib png zlib-copy png-copy harfbuzz )

set( FREETYPE_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/0003-freetype2/include CACHE INTERNAL "[JSD] FREETYPE_INCLUDE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}/0003-freetype2/include" FORCE )

if ( CMAKE_BUILD_TYPE STREQUAL "Debug" )
    set( FREETYPE_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0003-freetype2/libfreetyped.so CACHE INTERNAL "[JSD] FREETYPE_LIBRARY = ${CMAKE_CURRENT_BINARY_DIR}/0003-freetype2/libfreetyped.so" FORCE )
elseif( CMAKE_BUILD_TYPE STREQUAL "Release" )
	set( FREETYPE_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0003-freetype2/libfreetype.so CACHE INTERNAL "[JSD] FREETYPE_LIBRARY = ${CMAKE_CURRENT_BINARY_DIR}/0003-freetype2/libfreetype.so" FORCE )
else()
    message( SEND_ERROR "[JSD] not configured SDL2 build type" )
endif()

message( STATUS "[JSD] Configuring 0003-freetype2... done" )
message( STATUS "[JSD] Configuring 0004-glew-cmake..." )

add_subdirectory( 0004-glew-cmake )

message( STATUS "[JSD] Configuring 0004-glew-cmake... done" )
message( STATUS "[JSD] Configuring 0005-SDL..." )

add_subdirectory( 0005-SDL )

set( SDL2_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/0005-SDL/include CACHE INTERNAL "[JSD] SDL2_INCLUDE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}/0005-SDL/include" FORCE)

if ( CMAKE_BUILD_TYPE STREQUAL "Debug" )
    set( SDL2_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0005-SDL/libSDL2-2.0d.so CACHE INTERNAL "[JSD] SDL2_LIBRARY = ${CMAKE_CURRENT_BINARY_DIR}/0005-SDL/libSDL2-2.0d.so" FORCE )
elseif( CMAKE_BUILD_TYPE STREQUAL "Release" )
	set( SDL2_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0005-SDL/libSDL2-2.0.so CACHE INTERNAL "[JSD] SDL2_LIBRARY = ${CMAKE_CURRENT_BINARY_DIR}/0005-SDL/libSDL2-2.0.so" FORCE )
else()
    message( SEND_ERROR "[JSD] not configured SDL2 build type" )
endif()

message( STATUS "[JSD] Configuring 0005-SDL... done" )
message( STATUS "[JSD] Configuring 0006-openal-soft..." )

add_subdirectory( 0006-openal-soft )
add_dependencies( OpenAL SDL2 )

set( OPENAL_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/0006-openal-soft/include CACHE INTERNAL "[JSD] OPENAL_INCLUDE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}/0006-openal-soft/include" FORCE )
set( OPENAL_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0006-openal-soft/libopenal.so CACHE INTERNAL "[JSD] OPENAL_LIBRARY = ${CMAKE_CURRENT_BINARY_DIR}/0006-openal-soft/libopenal.so" FORCE )

message( STATUS "[JSD] Configuring 0006-openal-soft... done" )
message( STATUS "[JSD] Configuring 0007-freealut..." )

add_subdirectory( 0007-freealut )
add_dependencies( alut OpenAL )

message( STATUS "[JSD] Configuring 0007-freealut... done" )
message( STATUS "[JSD] Configuring 0008-ogg..." )

add_subdirectory( 0008-ogg )

set( OGG_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/0008-ogg/include CACHE INTERNAL "[JSD] OGG_INCLUDE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}/0008-ogg/include" FORCE )
set( OGG_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0008-ogg/libogg.so CACHE INTERNAL "[JSD] OGG_LIBRARY = ${CMAKE_CURRENT_BINARY_DIR}/0008-ogg/libogg.so" FORCE )

message( STATUS "[JSD] Configuring 0008-ogg... done" )
message( STATUS "[JSD] Configuring 0009-vorbis..." )

add_subdirectory( 0009-vorbis )
add_dependencies( vorbis ogg )

set( VORBIS_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/0009-vorbis/include CACHE INTERNAL "[JSD] VORBIS_INCLUDE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}/0009-vorbis/include" FORCE )
set( VORBIS_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0009-vorbis/lib/libvorbis.so CACHE INTERNAL "[JSD] OGG_LIBRARY = ${VORBIS_LIBRARY}/0009-vorbis/lib/libvorbis.so" FORCE )
set( VORBISENC_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0009-vorbis/lib/libvorbisenc.so CACHE INTERNAL "[JSD] VORBISENC_LIBRARY = ${VORBIS_LIBRARY}/0009-vorbis/lib/libvorbisenc.so" FORCE )
set( VORBISFILE_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0009-vorbis/lib/libvorbisfile.so CACHE INTERNAL "[JSD] VORBISFILE_LIBRARY = ${VORBIS_LIBRARY}/0009-vorbis/libvorbisfile/libvorbis.so" FORCE )

message( STATUS "[JSD] Configuring 0009-vorbis... done" )
message( STATUS "[JSD] Configuring 0010-flac..." )

add_subdirectory( 0010-flac )
add_dependencies( FLAC ogg )

set( FLAC_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/0010-flac/include CACHE INTERNAL "[JSD] FLAC_INCLUDE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}/0010-flac/include" FORCE )
set( FLAC_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/0010-flac/src/libFLAC/FLAC.so CACHE INTERNAL "[JSD] FLAC_LIBRARY = ${CMAKE_CURRENT_BINARY_DIR}/0010-flac/src/libFLAC/FLAC.so" FORCE )

message( STATUS "[JSD] Configuring 0010-flac... done" )
message( STATUS "[JSD] Configuring 0011-SFML..." )

add_subdirectory( 0011-SFML )
add_dependencies( sfml-graphics freetype )
add_dependencies( sfml-audio OpenAL ogg vorbis FLAC )

message( STATUS "[JSD] Configuring 0011-SFML... done" )
message( STATUS "[JSD] All configurations have been completed." )
