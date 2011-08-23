//
//  MyWindowController.m
//  ImageView
//
//  Created by administrator on 21-08-11.
//  Copyright 2011 1951FDG. All rights reserved.
//

#import "MyWindowController.h"


@implementation MyWindowController

- (void)synchronizeWindowTitleWithDocumentName
{
	NSDocument *theDocument = [self document];
	
	if (theDocument)
	{
		NSString *displayName = [theDocument displayName];
		NSString *path = [[theDocument fileURL] path];
		
		if (path)
		{
			NSWindow *theWindow = [self window];
			
			[theWindow setTitle:path];
			[NSApp changeWindowsItem:theWindow title:[path lastPathComponent] filename:NO];
		}
		else if (displayName)
		{
			NSWindow *theWindow = [self window];
			
			[theWindow setTitle:displayName];
			[NSApp changeWindowsItem:theWindow title:displayName filename:NO];
		}
	}
}

@end
