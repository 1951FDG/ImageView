//
//  MyDocument.m
//  ImageView
//
//  Created by administrator on 21-08-11.
//  Copyright 1951FDG 2011 . All rights reserved.
//

#import "MyDocument.h"
#import "MyWindow.h"
#import "MyWindowController.h"
#import "MyClipView.h"

@implementation MyDocument

- (id)initWithType:(NSString *)typeName error:(NSError **)outError
{
	if (outError != NULL)
	{
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	
	NSBundle *mainBundle = [NSBundle mainBundle];
	NSString *name = [[mainBundle objectForInfoDictionaryKey:@"CFBundleIconFile"] stringByDeletingPathExtension];
	NSString *path = [mainBundle pathForResource:name ofType:@"icns"];
	
	if (!path)
	{
		return NULL;
	}
	
	NSImage *newImage = [[[NSImage alloc] initWithContentsOfFile:path] autorelease];
	
	if (!newImage)
	{
		return NULL;
	}
	
	[super init];
	
	NSImageRep *imageRep = [[newImage representations] objectAtIndex:0];
	
	CGFloat imageWidth = [imageRep pixelsWide];
	CGFloat imageHeight = [imageRep pixelsHigh];
	
	[newImage setSize:NSMakeSize(imageWidth, imageHeight)];
	
	NSRect screenFrame = [[NSScreen mainScreen] frame];
	
	CGFloat screenWidth = screenFrame.size.width;
	CGFloat screenHeight = screenFrame.size.height;
	
	NSRect theRect;
	
	theRect.origin.x = screenWidth * (CGFloat)0.5 - imageWidth * (CGFloat)0.5;
	theRect.origin.y = screenHeight * (CGFloat)0.5 - imageHeight * (CGFloat)0.5;
	theRect.size.width = imageWidth;
	theRect.size.height = imageHeight;
	
	NSWindow *theWindow = [[[MyWindow alloc] initWithContentRect:theRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO] autorelease];
	
	NSWindowController *theWindowController = [[[MyWindowController alloc] initWithWindow:theWindow] autorelease];
	
	[self addWindowController:theWindowController];
	
	NSView *theClipView = [[[MyClipView alloc] initWithFrame:NSMakeRect((CGFloat)0.0, (CGFloat)0.0, imageWidth, imageHeight)] autorelease];
	
	[(MyClipView*)theClipView setBackgroundColor:[NSColor colorWithPatternImage:newImage]];
	
	[theClipView registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType, nil]];
	
	[[theWindow contentView] addSubview:theClipView];
	
	[theWindow makeKeyAndOrderFront:self];
	
	return self;
}

- (id)initWithContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
	if (outError != NULL)
	{
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	
	NSImage* newImage = [[[NSImage alloc] initWithContentsOfURL:absoluteURL] autorelease];
	
	if (!newImage)
	{
		return NULL;
	}
	
	[super init];
	[self setFileType:typeName];
	[self setFileURL:absoluteURL];
	
	NSImageRep *imageRep = [[newImage representations] objectAtIndex:0];
	
	CGFloat imageWidth = [imageRep pixelsWide];
	CGFloat imageHeight = [imageRep pixelsHigh];
	
	[newImage setSize:NSMakeSize(imageWidth, imageHeight)];
	
	NSRect screenFrame = [[NSScreen mainScreen] frame];
	
	CGFloat screenWidth = screenFrame.size.width;
	CGFloat screenHeight = screenFrame.size.height;
	
	NSRect theRect;
	
	if (imageWidth >= screenWidth && imageHeight >= screenHeight)
	{
		theRect.origin.x = (CGFloat)0.0;
		theRect.origin.y = (CGFloat)0.0;
		theRect.size.width = screenWidth;
		theRect.size.height = screenHeight;		
	}
	else if (imageWidth > screenWidth)	
	{
		theRect.origin.x = (CGFloat)0.0;
		theRect.origin.y = screenHeight * (CGFloat)0.5 - imageHeight * (CGFloat)0.5;;
		theRect.size.width = screenWidth;
		theRect.size.height = imageHeight;		
	}
	else if (imageHeight > screenHeight)
	{
		theRect.origin.x = screenWidth * (CGFloat)0.5 - imageWidth * (CGFloat)0.5;
		theRect.origin.y = (CGFloat)0.0;
		theRect.size.width = imageWidth;
		theRect.size.height = screenHeight;		
	}
	else
	{					
		theRect.origin.x = screenWidth * (CGFloat)0.5 - imageWidth * (CGFloat)0.5;
		theRect.origin.y = screenHeight * (CGFloat)0.5 - imageHeight * (CGFloat)0.5;;
		theRect.size.width = imageWidth;
		theRect.size.height = imageHeight;		
	}
	
	NSWindow *theWindow = [[[MyWindow alloc] initWithContentRect:theRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO] autorelease];
	
	NSWindowController *theWindowController = [[[MyWindowController alloc] initWithWindow:theWindow] autorelease];
	
	[self addWindowController:theWindowController];
	
	NSView *theClipView = [[[MyClipView alloc] initWithFrame:NSMakeRect((CGFloat)0.0, (CGFloat)0.0, imageWidth, imageHeight)] autorelease];
	
	[(MyClipView*)theClipView setBackgroundColor:[NSColor colorWithPatternImage:newImage]];
	
	[theClipView registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType, nil]];
	
	[[theWindow contentView] addSubview:theClipView];
	
	[theWindow makeKeyAndOrderFront:self];
	
	return self;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	if (outError != NULL)
	{
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	
	NSImage* newImage = [[[NSImage alloc] initWithContentsOfURL:[self fileURL]] autorelease];
	
	if (!newImage)
	{
		return NULL;
	}
	
	if ([typeName isEqualToString:@"public.tiff"])
	{
		return [NSBitmapImageRep representationOfImageRepsInArray:[newImage representations] usingType:NSTIFFFileType properties:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:NSTIFFCompressionLZW] forKey:NSImageCompressionMethod]];
	}
	else if ([typeName isEqualToString:@"public.png"])
	{
		return [[[newImage representations] objectAtIndex:0] representationUsingType:NSPNGFileType properties:NULL];
	}
	else if ([typeName isEqualToString:@"com.compuserve.gif"])
	{
		return [[[newImage representations] objectAtIndex:0] representationUsingType:NSGIFFileType properties:NULL];
	}
	else if ([typeName isEqualToString:@"com.microsoft.bmp"])
	{
		return [[[newImage representations] objectAtIndex:0] representationUsingType:NSBMPFileType properties:NULL];
	}
	else if ([typeName isEqualToString:@"public.jpeg-2000"])
	{
		return [[[newImage representations] objectAtIndex:0] representationUsingType:NSJPEG2000FileType properties:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:(float)1.0] forKey:NSImageCompressionFactor]];
	}
	else if ([typeName isEqualToString:@"public.jpeg"])
	{
		return [[[newImage representations] objectAtIndex:0] representationUsingType:NSJPEGFileType properties:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:(float)1.0], NSImageCompressionFactor, [NSNumber numberWithBool:YES], NSImageProgressive, NULL]];
	}
	
	return NULL;
}

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel
{
	//[savePanel setShowsHiddenFiles:YES];
	[savePanel setTreatsFilePackagesAsDirectories:YES];
	return YES;
}

- (IBAction)trashDocument:(id)sender
{
	NSString *path = [[self fileURL] path];
	
	if (path)
	{
		NSInteger tag;
		[[NSWorkspace sharedWorkspace] performFileOperation:NSWorkspaceRecycleOperation source:[path stringByDeletingLastPathComponent] destination:@"" files:[NSArray arrayWithObject:[path lastPathComponent]] tag:&tag];
	}
}

- (IBAction)revealDocument:(id)sender
{
	NSString *path = [[self fileURL] path];
	
	if (path)
	{
		[[NSWorkspace sharedWorkspace] selectFile:path inFileViewerRootedAtPath:nil];
	}
}

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem
{
	SEL action = [anItem action];
	
	if (action == @selector(saveDocument:))
	{
		return ([self fileURL]) ? YES : NO;
	}
	else if (action == @selector(saveDocumentAs:))
	{
		return ([self fileURL]) ? YES : NO;
	}
	else if (action == @selector(revertDocumentToSaved:))
	{
		return ([self isDocumentEdited] && [self fileURL]) ? YES : NO;
	}
	else if (action == @selector(trashDocument:))
	{
		return ([self fileURL]) ? YES : NO;
	}
	else if (action == @selector(revealDocument:))
	{
		return ([self fileURL]) ? YES : NO;
	}
	else if (action == @selector(runPageLayout:))
	{
		return ([self fileURL]) ? YES : NO;
	}
	else if (action == @selector(printDocument:))
	{
		return ([self fileURL]) ? YES : NO;
	}
	else
	{
		return [super validateUserInterfaceItem:anItem];
	}
}

+ (NSArray *)writableTypes
{
	return [NSArray arrayWithObjects:@"public.tiff", @"public.png", @"com.compuserve.gif", @"com.microsoft.bmp", @"public.jpeg-2000", @"public.jpeg", nil];
}

+ (BOOL)isNativeType:(NSString *)type
{
	return [[self writableTypes] containsObject:type];
}

@end
