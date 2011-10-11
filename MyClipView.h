//
//  MyClipView.h
//  ImageView
//
//  Created by administrator on 21-08-11.
//  Copyright 2011 1951FDG. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MyClipView : NSView
{
	//NSColor *backgroundColor;
	NSImage *contents;
}

//- (void)setBackgroundColor:(NSColor *)color;
- (NSImage *)contents;
- (void)setContents:(NSImage *)image;

@end
