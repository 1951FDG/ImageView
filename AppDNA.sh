#!/bin/bash

# AppDNA Script
# Copyright 2006 Chuck Houpt. No rights reserved.
# Copyright 2011 1951FDG. No rights reserved.

set -eux

# Only bundle the source for Release builds.
if [ "$CONFIGURATION" != 'Release' ] ; then exit ; fi

INSIDE_SOURCE="$TARGET_BUILD_DIR"/"$CONTENTS_FOLDER_PATH"/Source
PROJECT_NAME=`basename "$PROJECT_FILE_PATH"`

# Check if the project has already been modified for embedding.
if ! grep 'path = ../Resources;' "$PROJECT_FILE_PATH"/project.pbxproj
then

	rm -rf "$INSIDE_SOURCE"
	mkdir -p "$INSIDE_SOURCE"

	# Copy the source tree, minus resources, into Contents/Source.
	rsync -rl --cvs-exclude \
	--exclude 'build/' --exclude '.git/' --exclude '.hg/' \
	--exclude '*.mode1v3' --exclude '*.mode2v3' \
	--exclude '*.pbxuser' --exclude '*.perspective' --exclude '*.perspectivev3' \
	--exclude 'Credits.*' --exclude '*.DS_Store' \
	--exclude '*.scriptSuite' --exclude '*.scriptTerminology' --exclude '*.sdef' \
	--exclude '*.gif' --exclude '*.icns' --exclude '*.jpg' --exclude '*.pdf' --exclude '*.png' --exclude '*.tiff' \
	$@ \
	"$SRCROOT"/ "$INSIDE_SOURCE"

	# No, so modify the project to find resources in the Package's Resources directory.
	# Change the location of Info.plist, since it isn't like other resources.
	sed \
	-e '/name = Resources;/a\
	path = ../Resources;\
	' \
	-e 's/path = Info.plist; sourceTree = "<group>";/path = Info.plist; sourceTree = SOURCE_ROOT;/' \
	"$PROJECT_FILE_PATH"/project.pbxproj > "$INSIDE_SOURCE"/"$PROJECT_NAME"/project.pbxproj

else

	# Project embedded, so syncrhonize the build result to the enclosing application.
	rsync -rl "$TARGET_BUILD_DIR"/"$WRAPPER_NAME"/ "$SRCROOT"/../../

	# Finally, we need to 'touch' the .app file in order to force a refresh.
	/usr/bin/touch "$SRCROOT"/../../
fi
