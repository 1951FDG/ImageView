//
//  MyWindow.m
//  ImageView
//
//  Created by administrator on 21-08-11.
//  Copyright 2011 1951FDG. All rights reserved.
//

#import "MyWindow.h"


@implementation MyWindow

- (BOOL)isOpaque
{
	return NO;
}

- (BOOL)canBecomeKeyWindow
{
	return YES;
}

- (BOOL)canBecomeMainWindow
{
	return YES;
}

- (void)close:(id)sender
{
	[self close];
}

@end
