//
//  MyObject.m
//  ImageView
//
//  Created by administrator on 21-08-11.
//  Copyright 2011 1951FDG. All rights reserved.
//

#import "MyObject.h"


@implementation MyObject

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
	return YES;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
	return NO;
}

- (IBAction)showSource:(id)sender
{
	NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
	NSString *source = [NSString stringWithFormat:@"%@/Contents/Source", [thisBundle bundlePath]];
	NSString *project = [NSString stringWithFormat:@"%@/ImageView.xcodeproj", source];
	[[NSWorkspace sharedWorkspace] openFile:source];
	[[NSWorkspace sharedWorkspace] openFile:project];
	[NSApp terminate:self];
}

@end
