//
//  MyClipView.m
//  ImageView
//
//  Created by administrator on 21-08-11.
//  Copyright 2011 1951FDG. All rights reserved.
//

#import "MyClipView.h"


@implementation MyClipView

- (BOOL)isOpaque
{
	return YES;
}

- (void)dealloc
{
	//[backgroundColor release];
	[contents release];
	[super dealloc];
}

//- (void)setBackgroundColor:(NSColor *)color
//{
//	[backgroundColor release];
//	backgroundColor = [color retain];
//	[self setNeedsDisplay:YES];
//}

- (NSImage *)contents
{
	return contents;
}

- (void)setContents:(NSImage *)image
{
	[contents release];
	contents = [image retain];
	[self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect
{
	//[[NSGraphicsContext currentContext] setPatternPhase:NSMakePoint((CGFloat)0.0 - rect.origin.x, [self bounds].size.height - rect.origin.y)];
	//[backgroundColor set];
	//NSRectFill(rect);
	[contents drawInRect:rect fromRect:rect operation:NSCompositeCopy fraction:(CGFloat)1.0];
}

- (void)setImage:(NSImage *)newImage
{
	NSWindow *theWindow = [self window];
	
	NSImageRep *imageRep = [[newImage representations] objectAtIndex:0];
	
	CGFloat imageWidth = [imageRep pixelsWide];
	CGFloat imageHeight = [imageRep pixelsHigh];
	
	[newImage setSize:NSMakeSize(imageWidth, imageHeight)];
	
	NSRect boundsRect = [self bounds];
	
	if (!(imageWidth == boundsRect.size.width && imageHeight == boundsRect.size.height))
	{
		NSSize screenSize = [[theWindow screen] frame].size;
		
		[self setBoundsOrigin:NSMakePoint((CGFloat)0.0, (CGFloat)0.0)]; //
		
		[self setFrameSize:NSMakeSize(imageWidth, imageHeight)];
		
		//[self setBackgroundColor:[NSColor colorWithPatternImage:newImage]];
		[self setContents:newImage];
		
		if (imageWidth >= screenSize.width && imageHeight >= screenSize.height)
		{
			if (!(screenSize.width == [theWindow frame].size.width && screenSize.height == [theWindow frame].size.height))
			{
				[theWindow setFrame:NSMakeRect((CGFloat)0.0, (CGFloat)0.0, screenSize.width, screenSize.height) display:NO animate:NO];
			}
		}
		else if (imageWidth > screenSize.width)
		{
			[theWindow setFrame:NSMakeRect((CGFloat)0.0, screenSize.height * (CGFloat)0.5 - imageHeight * (CGFloat)0.5, screenSize.width, imageHeight) display:NO animate:NO];
		}
		else if (imageHeight > screenSize.height)
		{
			[theWindow setFrame:NSMakeRect(screenSize.width * (CGFloat)0.5 - imageWidth * (CGFloat)0.5, (CGFloat)0.0, imageWidth, screenSize.height) display:NO animate:NO];
		}
		else
		{
			[theWindow setFrame:NSMakeRect(screenSize.width * (CGFloat)0.5 - imageWidth * (CGFloat)0.5,screenSize.height * (CGFloat)0.5 - imageHeight * (CGFloat)0.5, imageWidth, imageHeight) display:NO animate:NO];
		}
	}
	else
	{
		//[self setBackgroundColor:[NSColor colorWithPatternImage:newImage]];
		[self setContents:newImage];
	}
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	if ([[[[[NSDocumentController sharedDocumentController] documentForWindow:[self window]] class] readableTypes] containsObject:[[NSWorkspace sharedWorkspace] typeOfFile:[[NSURL URLFromPasteboard:[sender draggingPasteboard]] path] error:NULL]]  && [sender draggingSourceOperationMask] & NSDragOperationCopy)
	{
		return NSDragOperationCopy;
	}
	return NSDragOperationNone;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
	return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
	NSURL *absoluteURL = [NSURL URLFromPasteboard:[sender draggingPasteboard]];
	/*
	 NSDocument *theDocument = [[NSDocumentController sharedDocumentController] documentForURL:absoluteURL];
	 
	 if (theDocument)
	 {
	 [[[[theDocument windowControllers] objectAtIndex:0] window] makeKeyAndOrderFront:self];
	 }
	 else
	 {
	 NSImage *newImage = [[[NSImage alloc] initWithContentsOfURL:absoluteURL] autorelease];
	 
	 if (newImage)
	 {
	 theDocument = [[NSDocumentController sharedDocumentController] documentForWindow:[self window]];
	 
	 [theDocument setFileType:[[NSWorkspace sharedWorkspace] typeOfFile:[absoluteURL path] error:NULL]];
	 [theDocument setFileURL:absoluteURL];
	 [self setImage:newImage];
	 }
	 }
	 */
	NSDocument *theDocument = [[NSDocumentController sharedDocumentController] documentForWindow:[self window]];
	
	if (!([[theDocument fileURL] isEqual:absoluteURL]))
	{
		NSImage *newImage = [[[NSImage alloc] initWithContentsOfURL:absoluteURL] autorelease];
		
		if (newImage)
		{
			[theDocument setFileType:[[NSWorkspace sharedWorkspace] typeOfFile:[absoluteURL path] error:NULL]];
			[theDocument setFileURL:absoluteURL];
			[self setImage:newImage];
		}
	}
}

- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (BOOL)becomeFirstResponder
{
	return YES;
}

- (void)imageAlignCenter:(id)sender
{
	NSRect boundsRect = [self bounds];
	NSPoint newOrigin;
	newOrigin.x = boundsRect.size.width * (CGFloat)0.5 - [[self superview] frame].size.width * (CGFloat)0.5;
	newOrigin.y = boundsRect.size.height * (CGFloat)0.5 - [[self superview] frame].size.height * (CGFloat)0.5;
	if ((boundsRect.origin.x == newOrigin.x) && (boundsRect.origin.y == newOrigin.y))
	{
		NSBeep();
	}
	else
	{
		[self setBoundsOrigin:newOrigin];
	}
}

- (void)imageAlignTop:(id)sender
{
	NSRect boundsRect = [self bounds];
	NSPoint newOrigin;
	newOrigin.x = boundsRect.size.width * (CGFloat)0.5 - [[self superview] frame].size.width * (CGFloat)0.5;
	newOrigin.y = boundsRect.size.height - [[self superview] frame].size.height;
	if ((boundsRect.origin.x == newOrigin.x) && (boundsRect.origin.y == newOrigin.y))
	{
		NSBeep();
	}
	else
	{
		[self setBoundsOrigin:newOrigin];
	}
}

- (void)imageAlignTopLeft:(id)sender
{
	NSRect boundsRect = [self bounds];
	NSPoint newOrigin;
	newOrigin.x = (CGFloat)0.0;
	newOrigin.y = boundsRect.size.height - [[self superview] frame].size.height;
	if ((boundsRect.origin.x == newOrigin.x) && (boundsRect.origin.y == newOrigin.y))
	{
		NSBeep();
	}
	else
	{
		[self setBoundsOrigin:newOrigin];
	}
}

- (void)imageAlignTopRight:(id)sender
{
	NSRect boundsRect = [self bounds];
	NSPoint newOrigin;
	newOrigin.x = boundsRect.size.width - [[self superview] frame].size.width;
	newOrigin.y = boundsRect.size.height - [[self superview] frame].size.height;
	if ((boundsRect.origin.x == newOrigin.x) && (boundsRect.origin.y == newOrigin.y))
	{
		NSBeep();
	}
	else
	{
		[self setBoundsOrigin:newOrigin];
	}
}

- (void)imageAlignLeft:(id)sender
{
	NSRect boundsRect = [self bounds];
	NSPoint newOrigin;
	newOrigin.x = (CGFloat)0.0;
	newOrigin.y = boundsRect.size.height * (CGFloat)0.5 - [[self superview] frame].size.height * (CGFloat)0.5;
	if ((boundsRect.origin.x == newOrigin.x) && (boundsRect.origin.y == newOrigin.y))
	{
		NSBeep();
	}
	else
	{
		[self setBoundsOrigin:newOrigin];
	}
}

- (void)imageAlignBottom:(id)sender
{
	NSRect boundsRect = [self bounds];
	NSPoint newOrigin;
	newOrigin.x = boundsRect.size.width * (CGFloat)0.5 - [[self superview] frame].size.width * (CGFloat)0.5;
	newOrigin.y = (CGFloat)0.0;
	if ((boundsRect.origin.x == newOrigin.x) && (boundsRect.origin.y == newOrigin.y))
	{
		NSBeep();
	}
	else
	{
		[self setBoundsOrigin:newOrigin];
	}
}
- (void)imageAlignBottomLeft:(id)sender
{
	NSRect boundsRect = [self bounds];
	NSPoint newOrigin;
	newOrigin.x = (CGFloat)0.0;
	newOrigin.y = (CGFloat)0.0;
	if ((boundsRect.origin.x == newOrigin.x) && (boundsRect.origin.y == newOrigin.y))
	{
		NSBeep();
	}
	else
	{
		[self setBoundsOrigin:newOrigin];
	}
}

- (void)imageAlignBottomRight:(id)sender
{
	NSRect boundsRect = [self bounds];
	NSPoint newOrigin;
	newOrigin.x = boundsRect.size.width - [[self superview] frame].size.width;
	newOrigin.y = (CGFloat)0.0;
	if ((boundsRect.origin.x == newOrigin.x) && (boundsRect.origin.y == newOrigin.y))
	{
		NSBeep();
	}
	else
	{
		[self setBoundsOrigin:newOrigin];
	}
}

- (void)imageAlignRight:(id)sender
{
	NSRect boundsRect = [self bounds];
	NSPoint newOrigin;
	newOrigin.x = boundsRect.size.width - [[self superview] frame].size.width;
	newOrigin.y = boundsRect.size.height * (CGFloat)0.5 - [[self superview] frame].size.height * (CGFloat)0.5;
	if ((boundsRect.origin.x == newOrigin.x) && (boundsRect.origin.y == newOrigin.y))
	{
		NSBeep();
	}
	else
	{
		[self setBoundsOrigin:newOrigin];
	}
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	NSRect frameRect = [[self superview] frame];
	
	NSRect boundsRect = [self bounds];
	
	SEL action = [menuItem action];
	
	if (action == @selector(imageAlignCenter:))
	{
		return (boundsRect.size.width > frameRect.size.width || boundsRect.size.height > frameRect.size.height);
	}
	else if (action == @selector(imageAlignTop:))
	{
		return (boundsRect.size.height > frameRect.size.height);
	}
	else if (action == @selector(imageAlignTopLeft:))
	{
		return (boundsRect.size.width > frameRect.size.width && boundsRect.size.height > frameRect.size.height);
	}
	else if (action == @selector(imageAlignTopRight:))
	{
		return (boundsRect.size.width > frameRect.size.width && boundsRect.size.height > frameRect.size.height);
	}
	else if (action == @selector(imageAlignLeft:))
	{
		return (boundsRect.size.width > frameRect.size.width);
	}
	else if (action == @selector(imageAlignBottom:))
	{
		return (boundsRect.size.height > frameRect.size.height);
	}
	else if (action == @selector(imageAlignBottomLeft:))
	{
		return (boundsRect.size.width > frameRect.size.width && boundsRect.size.height > frameRect.size.height);
	}
	else if (action == @selector(imageAlignBottomRight:))
	{
		return (boundsRect.size.width > frameRect.size.width && boundsRect.size.height > frameRect.size.height);
	}
	else if (action == @selector(imageAlignRight:))
	{
		return (boundsRect.size.width > frameRect.size.width);
	}
	else
	{
		return [self respondsToSelector:action];
	}
}

- (void)resetCursorRects
{
	NSRect frameRect = [[self superview] frame];
	
	NSRect boundsRect = [self bounds];
	
	if (boundsRect.size.width > frameRect.size.width || boundsRect.size.height > frameRect.size.height)
	{
		NSEventType type = [[[self window] currentEvent] type];
		
		if (type == NSLeftMouseDown || type == NSLeftMouseDragged)
		{
			[[NSCursor closedHandCursor] set];
		}
		else
		{
			[self addCursorRect:[self bounds] cursor:[NSCursor openHandCursor]];
		}
	}
	else
	{
		[self addCursorRect:[self bounds] cursor:[NSCursor arrowCursor]];
	}
}

- (void)mouseDown:(NSEvent *)theEvent
{
	NSRect frameRect = [[self superview] frame];
	
	NSRect boundsRect = [self bounds];
	
	if (boundsRect.size.width > frameRect.size.width || boundsRect.size.height > frameRect.size.height)
	{
		[[theEvent window] disableCursorRects];
		[self resetCursorRects];
	}
}

- (void)mouseUp:(NSEvent *)theEvent
{
	NSRect frameRect = [[self superview] frame];
	
	NSRect boundsRect = [self bounds];
	
	if (boundsRect.size.width > frameRect.size.width || boundsRect.size.height > frameRect.size.height)
	{
		[[theEvent window] enableCursorRects];
		[self resetCursorRects];
	}
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	NSRect frameRect = [[self superview] frame];
	
	NSRect boundsRect = [self bounds];
	
	if (boundsRect.size.width > frameRect.size.width || boundsRect.size.height > frameRect.size.height)
	{
		//NSPoint newOrigin = NSMakePoint(boundsRect.origin.x - [theEvent deltaX], boundsRect.origin.y + [theEvent deltaY]);
		NSPoint newOrigin = NSMakePoint(boundsRect.origin.x + [theEvent deltaX], boundsRect.origin.y - [theEvent deltaY]);
		
		NSRect aRect = NSMakeRect((CGFloat)0.0, (CGFloat)0.0, boundsRect.size.width - frameRect.size.width, boundsRect.size.height - frameRect.size.height);
		
		if (newOrigin.y < aRect.origin.y)
		{
			newOrigin.y = aRect.origin.y;
		}
		
		if (newOrigin.x < aRect.origin.x)
		{
			newOrigin.x = aRect.origin.x;
		}
		
		if (newOrigin.y > aRect.size.height)
		{
			newOrigin.y = aRect.size.height;
		}
		
		if (newOrigin.x > aRect.size.width)
		{
			newOrigin.x = aRect.size.width;
		}
		
		if (!((boundsRect.origin.x == newOrigin.x) && (boundsRect.origin.y == newOrigin.y)))
		{
			[self setBoundsOrigin:newOrigin];
		}
	}
	else
	{
		NSWindow *theWindow = [theEvent window];
		
		NSRect windowFrame = [theWindow frame];
		NSRect screenFrame = [[theWindow screen] frame];
		
		windowFrame.origin.x = windowFrame.origin.x + [theEvent deltaX];
		windowFrame.origin.y = windowFrame.origin.y - [theEvent deltaY];
		
		CGFloat screenWidth = screenFrame.size.width - windowFrame.size.width;
		CGFloat screenHeight = screenFrame.size.height - windowFrame.size.height;
		
		BOOL left = (windowFrame.origin.x) < ((CGFloat)0.0);
		BOOL top = (windowFrame.origin.y) > (screenHeight);
		BOOL right = (windowFrame.origin.x) > (screenWidth);
		BOOL bottom = (windowFrame.origin.y) < ((CGFloat)0.0);
		
		if (left || top || right || bottom)
		{
			if (bottom && left)
			{
				windowFrame.origin.x = (CGFloat)0.0;
				windowFrame.origin.y = (CGFloat)0.0;
			}
			else if (bottom && right)
			{
				windowFrame.origin.x = screenWidth;
				windowFrame.origin.y = (CGFloat)0.0;
			}
			else if (top && right)
			{
				windowFrame.origin.x = screenWidth;
				windowFrame.origin.y = screenHeight;
			}
			else if (top && left)
			{
				windowFrame.origin.x = (CGFloat)0.0;
				windowFrame.origin.y = screenHeight;
			}
			else if (left)
			{
				windowFrame.origin.x = (CGFloat)0.0;
			}
			else if (top)
			{
				windowFrame.origin.y = screenHeight;
			}
			else if (right)
			{
				windowFrame.origin.x = screenWidth;
			}
			else if (bottom)
			{
				windowFrame.origin.y = (CGFloat)0.0;
			}
		}
		
		[theWindow setFrame:windowFrame display:NO animate:NO];
	}
}

- (void)keyDown:(NSEvent *)theEvent
{
	if ([theEvent modifierFlags] & NSNumericPadKeyMask)
	{
		[self interpretKeyEvents:[NSArray arrayWithObject:theEvent]]; 
	}
	else
	{
		[super keyDown:theEvent];
	} 
}

- (void)moveUp:(id)sender
{
	NSRect frameRect = [[self superview] frame];
	
	NSRect boundsRect = [self bounds];
	
	if (boundsRect.size.height > frameRect.size.height)
	{
		CGFloat newY = boundsRect.origin.y + frameRect.size.height;
		CGFloat maxY = boundsRect.size.height - frameRect.size.height;
		
		if (newY > maxY)
		{
			newY = maxY;
		}
		
		if (newY == boundsRect.origin.y)
		{
			NSBeep();
		}
		else
		{
			[self setBoundsOrigin:NSMakePoint(boundsRect.origin.x, newY)];
		}
	}
	else
	{
		NSBeep();
	}	
}

- (void)moveDown:(id)sender
{
	NSRect frameRect = [[self superview] frame];
	
	NSRect boundsRect = [self bounds];
	
	if (boundsRect.size.height > frameRect.size.height)
	{
		CGFloat newY = boundsRect.origin.y - frameRect.size.height;
		CGFloat minY = (CGFloat)0.0;
		
		if (newY < minY)
		{
			newY = minY;
		}
		
		if (newY == boundsRect.origin.y)
		{
			NSBeep();
		}
		else
		{
			[self setBoundsOrigin:NSMakePoint(boundsRect.origin.x, newY)];
		}
	}
	else
	{
		NSBeep();
	}	
}

- (void)moveLeft:(id)sender
{
	NSRect frameRect = [[self superview] frame];
	
	NSRect boundsRect = [self bounds];
	
	if (boundsRect.size.width > frameRect.size.width)
	{
		CGFloat newX = boundsRect.origin.x - frameRect.size.width;
		CGFloat minX = (CGFloat)0.0;
		
		if (newX < minX)
		{
			newX = minX;
		}
		
		if (newX == boundsRect.origin.x)
		{
			NSBeep();
		}
		else
		{
			[self setBoundsOrigin:NSMakePoint(newX, boundsRect.origin.y)];
		}
	}
	else
	{
		NSBeep();
	}	
}

- (void)moveRight:(id)sender
{
	NSRect frameRect = [[self superview] frame];
	
	NSRect boundsRect = [self bounds];
	
	if (boundsRect.size.width > frameRect.size.width)
	{
		CGFloat newX = boundsRect.origin.x + frameRect.size.width;
		CGFloat maxX = boundsRect.size.width - frameRect.size.width;
		
		if (newX > maxX)
		{
			newX = maxX;
		}
		
		if (newX == boundsRect.origin.x)
		{
			NSBeep();
		}
		else
		{
			[self setBoundsOrigin:NSMakePoint(newX, boundsRect.origin.y)];
		}
	}
	else
	{
		NSBeep();
	}
}

@end
