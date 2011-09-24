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

- (IBAction)openDonatePage:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=DADW84SEUMTQE&lc=%@&item_name=%@&currency_code=%@&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted", @"US", [[NSProcessInfo processInfo] processName], @"USD"]]];
}

- (IBAction)openFeedbackPage:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://bitbucket.org/1951FDG/imageview/issues/new"]];
}

- (IBAction)openHomePage:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://bitbucket.org/1951FDG/imageview/wiki"]];
}

@end
