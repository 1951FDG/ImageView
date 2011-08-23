//
//  MyImageView.m
//  ImageView
//
//  Created by administrator on 21-08-11.
//  Copyright 2011 1951FDG. All rights reserved.
//

#import "MyImageView.h"


@implementation MyImageView

- (void)setImage:(NSImage *)newImage
{
	NSWindow *theWindow = [self window];
	
	NSSize imageSize = [[[self cell] image] size];
	
	NSImageRep *imageRep = [[newImage representations] objectAtIndex:0];
	
	CGFloat imageWidth = [imageRep pixelsWide];
	CGFloat imageHeight = [imageRep pixelsHigh];
	
	[newImage setSize:NSMakeSize(imageWidth, imageHeight)];
	
	if (!(imageWidth == imageSize.width && imageHeight == imageSize.height))
	{
		NSSize windowSize = [theWindow frame].size;
		NSSize screenSize = [[theWindow screen] frame].size;
		
		[self setFrame:NSMakeRect((CGFloat)0.0, (CGFloat)0.0, imageWidth, imageHeight)];
		
		if (imageWidth > screenSize.width && imageHeight > screenSize.height)
		{
			if (!(screenSize.width == windowSize.width && screenSize.height == windowSize.height))
			{
				[[self cell] setImage:newImage];
				[theWindow setFrame:NSMakeRect((CGFloat)0.0, (CGFloat)0.0, screenSize.width, screenSize.height) display:YES animate:YES];
				[(NSClipView*)[self superview] setDocumentCursor:[NSCursor openHandCursor]];
			}
			else
			{
				[[self cell] setImage:newImage];
				if (!([imageRep hasAlpha]))
				{
					[self displayIfNeededIgnoringOpacity];
				}
				[(NSClipView*)[self superview] setDocumentCursor:[NSCursor openHandCursor]];
			}
		}
		else if (imageWidth == screenSize.width && imageHeight == screenSize.height)
		{
			if (!(screenSize.width == windowSize.width && screenSize.height == windowSize.height))
			{
				[[self cell] setImage:newImage];
				[theWindow setFrame:NSMakeRect((CGFloat)0.0, (CGFloat)0.0, screenSize.width, screenSize.height) display:YES animate:YES];
				[(NSClipView*)[self superview] setDocumentCursor:[NSCursor arrowCursor]];
			}
			else
			{
				[[self cell] setImage:newImage];
				if (!([imageRep hasAlpha]))
				{
					[self displayIfNeededIgnoringOpacity];
				}
				[(NSClipView*)[self superview] setDocumentCursor:[NSCursor arrowCursor]];
			}
		}
		else if (imageWidth > screenSize.width)
		{
			[[self cell] setImage:newImage];
			[theWindow setFrame:NSMakeRect((CGFloat)0.0, screenSize.height * (CGFloat)0.5 - imageHeight * (CGFloat)0.5, screenSize.width, imageHeight) display:YES animate:NO];
			[(NSClipView*)[self superview] setDocumentCursor:[NSCursor openHandCursor]];
		}
		else if (imageHeight > screenSize.height)
		{
			[[self cell] setImage:newImage];
			[theWindow setFrame:NSMakeRect(screenSize.width * (CGFloat)0.5 - imageWidth * (CGFloat)0.5, (CGFloat)0.0, imageWidth, screenSize.height) display:YES animate:NO];
			[(NSClipView*)[self superview] setDocumentCursor:[NSCursor openHandCursor]];
		}
		else
		{
			[[self cell] setImage:newImage];
			[theWindow setFrame:NSMakeRect(screenSize.width * (CGFloat)0.5 - imageWidth * (CGFloat)0.5,screenSize.height * (CGFloat)0.5 - imageHeight * (CGFloat)0.5, imageWidth, imageHeight) display:YES animate:NO];
			[(NSClipView*)[self superview] setDocumentCursor:[NSCursor arrowCursor]];
		}
	}
	else
	{
		[[self cell] setImage:newImage];
		if (!([imageRep hasAlpha]))
		{
			[self displayIfNeededIgnoringOpacity];
		}
	}
}

- (void)becomeKeyWindow
{

}

- (void)resignKeyWindow
{

}

- (void)imageAlignCenter:(id)sender
{
	NSPoint newOrigin;
	newOrigin.x = [self frame].size.width * (CGFloat)0.5 - [(NSClipView*)[self superview] frame].size.width * (CGFloat)0.5;
	newOrigin.y = [self frame].size.height * (CGFloat)0.5 - [(NSClipView*)[self superview] frame].size.height * (CGFloat)0.5;
	
	[(NSClipView*)[self superview] scrollToPoint:newOrigin];
}

- (void)imageAlignTop:(id)sender
{
	NSPoint newOrigin;
	newOrigin.x = [self frame].size.width * (CGFloat)0.5 - [(NSClipView*)[self superview] frame].size.width * (CGFloat)0.5;
	newOrigin.y = [self frame].size.height - [(NSClipView*)[self superview] frame].size.height;
	
	[(NSClipView*)[self superview] scrollToPoint:newOrigin];
}

- (void)imageAlignTopLeft:(id)sender
{
	NSPoint newOrigin;
	newOrigin.x = (CGFloat)0.0;
	newOrigin.y = [self frame].size.height - [(NSClipView*)[self superview] frame].size.height;
	
	[(NSClipView*)[self superview] scrollToPoint:newOrigin];
}

- (void)imageAlignTopRight:(id)sender
{
	NSPoint newOrigin;
	newOrigin.x = [self frame].size.width - [(NSClipView*)[self superview] frame].size.width;
	newOrigin.y = [self frame].size.height - [(NSClipView*)[self superview] frame].size.height;
	
	[(NSClipView*)[self superview] scrollToPoint:newOrigin];
}

- (void)imageAlignLeft:(id)sender
{
	NSPoint newOrigin;
	newOrigin.x = (CGFloat)0.0;
	newOrigin.y = [self frame].size.height * (CGFloat)0.5 - [(NSClipView*)[self superview] frame].size.height * (CGFloat)0.5;
	
	[(NSClipView*)[self superview] scrollToPoint:newOrigin];
}

- (void)imageAlignBottom:(id)sender
{
	NSPoint newOrigin;
	newOrigin.x = [self frame].size.width * (CGFloat)0.5 - [(NSClipView*)[self superview] frame].size.width * (CGFloat)0.5;
	newOrigin.y = (CGFloat)0.0;
	
	[(NSClipView*)[self superview] scrollToPoint:newOrigin];
}

- (void)imageAlignBottomLeft:(id)sender
{
	NSPoint newOrigin;
	newOrigin.x = (CGFloat)0.0;
	newOrigin.y = (CGFloat)0.0;
	
	[(NSClipView*)[self superview] scrollToPoint:newOrigin];
}

- (void)imageAlignBottomRight:(id)sender
{
	NSPoint newOrigin;
	newOrigin.x = [self frame].size.width - [(NSClipView*)[self superview] frame].size.width;
	newOrigin.y = (CGFloat)0.0;
	
	[(NSClipView*)[self superview] scrollToPoint:newOrigin];
}

- (void)imageAlignRight:(id)sender
{
	NSPoint newOrigin;
	newOrigin.x = [self frame].size.width - [(NSClipView*)[self superview] frame].size.width;
	newOrigin.y = [self frame].size.height * (CGFloat)0.5 - [(NSClipView*)[self superview] frame].size.height * (CGFloat)0.5;
	
	[(NSClipView*)[self superview] scrollToPoint:newOrigin];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	NSWindow *theWindow = [self window];
	
	NSSize imageSize = [[self image] size];
	
	NSSize screenSize = [[theWindow screen] frame].size;
	
	SEL action = [menuItem action];
	
	if (action == @selector(imageAlignCenter:))
	{
		return (imageSize.width > screenSize.width || imageSize.height > screenSize.height);
	}
	else if (action == @selector(imageAlignTop:))
	{
		return (imageSize.height > screenSize.height);
	}
	else if (action == @selector(imageAlignTopLeft:))
	{
		return (imageSize.width > screenSize.width && imageSize.height > screenSize.height);
	}
	else if (action == @selector(imageAlignTopRight:))
	{
		return (imageSize.width > screenSize.width && imageSize.height > screenSize.height);
	}
	else if (action == @selector(imageAlignLeft:))
	{
		return (imageSize.width > screenSize.width);
	}
	else if (action == @selector(imageAlignBottom:))
	{
		return (imageSize.height > screenSize.height);
	}
	else if (action == @selector(imageAlignBottomLeft:))
	{
		return (imageSize.width > screenSize.width && imageSize.height > screenSize.height);
	}
	else if (action == @selector(imageAlignBottomRight:))
	{
		return (imageSize.width > screenSize.width && imageSize.height > screenSize.height);
	}
	else if (action == @selector(imageAlignRight:))
	{
		return (imageSize.width > screenSize.width);
	}
	else
	{
		return [super validateMenuItem:menuItem];
	}
}

- (void)mouseDown:(NSEvent *)theEvent
{
	NSWindow *theWindow = [theEvent window];
	
	NSSize imageSize = [[[self cell] image] size];
	
	NSSize screenSize = [[theWindow screen] frame].size;
	
	if (imageSize.width > screenSize.width || imageSize.height > screenSize.height)
	{
		[(NSClipView*)[self superview] setDocumentCursor:[NSCursor closedHandCursor]];
	}
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	NSWindow *theWindow = [theEvent window];
	
	NSSize imageSize = [[[self cell] image] size];
	
	NSSize screenSize = [[theWindow screen] frame].size;
	
	if (imageSize.width > screenSize.width || imageSize.height > screenSize.height)
	{
		NSRect boundsRect = [(NSClipView*)[self superview] bounds];
		
		//[self scrollPoint:NSMakePoint(boundsRect.origin.x - [theEvent deltaX], boundsRect.origin.y + [theEvent deltaY])];
		[self scrollPoint: NSMakePoint(boundsRect.origin.x + [theEvent deltaX], boundsRect.origin.y - [theEvent deltaY])];
	}
	else
	{
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

- (void)mouseUp:(NSEvent *)theEvent
{	
	NSWindow *theWindow = [theEvent window];
	
	NSSize imageSize = [[[self cell] image] size];
	
	NSSize screenSize = [[theWindow screen] frame].size;
	
	if (imageSize.width > screenSize.width || imageSize.height > screenSize.height)
	{
		[(NSClipView*)[self superview] setDocumentCursor:[NSCursor openHandCursor]];
	}
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
	 theDocument = [[NSDocumentController sharedDocumentController] documentForWindow:[self window]];
	 
	 [theDocument setFileType:[[NSWorkspace sharedWorkspace] typeOfFile:[absoluteURL path] error:NULL]];
	 [theDocument setFileURL:absoluteURL];
	 [super concludeDragOperation:sender];
	 }
	 */
	NSDocument *theDocument = [[NSDocumentController sharedDocumentController] documentForWindow:[self window]];
	
	if (!([[theDocument fileURL] isEqual:absoluteURL]))
	{
		[theDocument setFileType:[[NSWorkspace sharedWorkspace] typeOfFile:[absoluteURL path] error:NULL]];
		[theDocument setFileURL:absoluteURL];
		[super concludeDragOperation:sender];
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
	NSRect frameRect = [self frame];
	
	NSRect boundsRect = [(NSClipView*)[self superview] bounds];
	
	if (frameRect.size.height > boundsRect.size.height)
	{
		//[self scrollPoint: NSMakePoint(boundsRect.origin.x, boundsRect.origin.y + boundsRect.size.height)];
		
		CGFloat newY = boundsRect.origin.y + boundsRect.size.height;
		CGFloat maxY = frameRect.size.height - boundsRect.size.height;
		
		if (newY > maxY)
		{
			newY = maxY;
		}
		
		[(NSClipView*)[self superview] scrollToPoint:NSMakePoint(boundsRect.origin.x, newY)];
	}
}

- (void)moveDown:(id)sender
{
	NSRect frameRect = [self frame];
	
	NSRect boundsRect = [(NSClipView*)[self superview] bounds];
	
	if (frameRect.size.height > boundsRect.size.height)
	{
		//[self scrollPoint: NSMakePoint(boundsRect.origin.x, boundsRect.origin.y - boundsRect.size.height)];
		
		CGFloat newY = boundsRect.origin.y - boundsRect.size.height;
		CGFloat minY = (CGFloat)0.0;
		
		if (newY < minY)
		{
			newY = minY;
		}
		
		[(NSClipView*)[self superview] scrollToPoint:NSMakePoint(boundsRect.origin.x, newY)];
	}
}

- (void)moveLeft:(id)sender
{
	NSRect frameRect = [self frame];
	
	NSRect boundsRect = [(NSClipView*)[self superview] bounds];
	
	if (frameRect.size.width > boundsRect.size.width)
	{
		//[self scrollPoint: NSMakePoint(boundsRect.origin.x - boundsRect.size.width, boundsRect.origin.y)];
		
		CGFloat newX = boundsRect.origin.x - boundsRect.size.width;
		CGFloat minX = (CGFloat)0.0;
		
		if (newX < minX)
		{
			newX = minX;
		}
		
		[(NSClipView*)[self superview] scrollToPoint:NSMakePoint(newX, boundsRect.origin.y)];
	}
}

- (void)moveRight:(id)sender
{
	NSRect frameRect = [self frame];
	
	NSRect boundsRect = [(NSClipView*)[self superview] bounds];
	
	if (frameRect.size.width > boundsRect.size.width)
	{
		//[self scrollPoint: NSMakePoint(boundsRect.origin.x + boundsRect.size.width, boundsRect.origin.y)];
		
		CGFloat newX = boundsRect.origin.x + boundsRect.size.width;
		CGFloat maxX = frameRect.size.width - boundsRect.size.width;
		
		if (newX > maxX)
		{
			newX = maxX;
		}
		
		[(NSClipView*)[self superview] scrollToPoint:NSMakePoint(newX, boundsRect.origin.y)];
	}
}

@end
