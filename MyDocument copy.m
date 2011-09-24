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
#import "MyLayerView.h"
#import "MyCheck.h"

@implementation MyDocument

- (id)initWithType:(NSString *)typeName error:(NSError **)outError
{
	if (outError != NULL)
	{
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	
	NSBundle *mainBundle = [NSBundle mainBundle];
	NSDictionary *infoDictionary = [mainBundle infoDictionary];
	NSString *name = [[infoDictionary objectForKey:@"CFBundleIconFile"] stringByDeletingPathExtension];
	NSString *path = [mainBundle pathForResource:name ofType:@"icns"];
	
	if (!path)
	{
		return NULL;
	}
	
	NSURL *absoluteURL = [NSURL fileURLWithPath:path isDirectory:NO];
	
	CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)absoluteURL, NULL);
	
	if (!imageSource)
	{
		return NULL;
	}
	
	CGImageRef newImage = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
	
	CFRelease(imageSource);
	
	if (!newImage)
	{
		return NULL;
	}
	
	[super init];
	
	CGFloat imageWidth = CGImageGetWidth(newImage);
	CGFloat imageHeight = CGImageGetHeight(newImage);
	
	CALayer *imageLayer = [CALayer layer];
	
	[imageLayer setContentsGravity:kCAGravityBottomLeft];
	[imageLayer setContents:(id)newImage];
	
	CFRelease(newImage);
	
	CAScrollLayer *scrollLayer = [CAScrollLayer layer];
	
	[scrollLayer setBackgroundColor:CGColorGetConstantColor(kCGColorWhite)];
	[scrollLayer addSublayer:imageLayer];
	
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
	
	NSView *theClipView = [[[MyLayerView alloc] initWithFrame:NSMakeRect((CGFloat)0.0, (CGFloat)0.0, imageWidth, imageHeight)] autorelease];
	
	[theClipView registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType, nil]];
	
	[theClipView setLayer:scrollLayer];
	
	[theClipView setWantsLayer:YES];
	
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
	
	CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)absoluteURL, NULL);
	
	if (!imageSource)
	{
		return NULL;
	}
	
	CGFloat imageWidth = (CGFloat)0.0;
	CGFloat imageHeight = (CGFloat)0.0;
	
	CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
	
	if (imageProperties)
	{
		CFNumberRef widthNum  = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
		if (widthNum)
		{
			CFNumberGetValue(widthNum, kCFNumberCGFloatType, &imageWidth);
		}
		
		CFNumberRef heightNum = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
		if (heightNum)
		{
			CFNumberGetValue(heightNum, kCFNumberCGFloatType, &imageHeight);
		}
		
		CFRelease(imageProperties);
	}
	
	if (![MyCheck validateImageSize:(GLint)(imageWidth < imageHeight ? imageHeight : imageWidth)])
	{
		CFRelease(imageSource);
		return NULL;
	}
	
	CGImageRef newImage = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
	
	CFRelease(imageSource);
	
	if (!newImage)
	{
		return NULL;
	}
	
	[super init];
	[self setFileType:typeName];
	[self setFileURL:absoluteURL];
	
	CALayer *imageLayer = [CALayer layer];
	
	[imageLayer setContentsGravity:kCAGravityBottomLeft];
	[imageLayer setContents:(id)newImage];
	
	CFRelease(newImage);
	
	CAScrollLayer *scrollLayer = [CAScrollLayer layer];
	
	[scrollLayer setBackgroundColor:CGColorGetConstantColor(kCGColorWhite)];
	[scrollLayer addSublayer:imageLayer];
	
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
	
	NSView *theClipView = [[[MyLayerView alloc] initWithFrame:NSMakeRect((CGFloat)0.0, (CGFloat)0.0, imageWidth, imageHeight)] autorelease];
	
	[theClipView registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType, nil]];
	
	[theClipView setLayer:scrollLayer];
	
	[theClipView setWantsLayer:YES];
	
	[[theWindow contentView] addSubview:theClipView];
	
	[theWindow makeKeyAndOrderFront:self];
	
	return self;
}

- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
	if (outError != NULL)
	{
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	
	CGImageSourceRef isrc = CGImageSourceCreateWithURL((CFURLRef)[self fileURL], NULL);
	
	if (!isrc)
	{
		return NO;
	}
	
	if ([typeName isEqualToString:@"public.tiff"])
	{
		NSUInteger count = CGImageSourceGetCount(isrc);
		
		CGImageDestinationRef idst = CGImageDestinationCreateWithURL((CFURLRef)absoluteURL, (CFStringRef)typeName, count, NULL);
		
		if (idst)
		{
			CFMutableDictionaryRef properties = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
			CFMutableDictionaryRef dict = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
			CFDictionarySetValue(dict, kCGImagePropertyTIFFCompression, [NSNumber numberWithFloat:NSTIFFCompressionLZW]);
			CFDictionarySetValue(properties, kCGImagePropertyTIFFDictionary, dict);
			
			NSUInteger i;
			for(i=0;i<count;i++)
			{
				CGImageDestinationAddImageFromSource(idst, isrc, i, properties);
			}
			
			BOOL flag = CGImageDestinationFinalize(idst);
			
			CFRelease(isrc);
			CFRelease(idst);
			CFRelease(properties);
			CFRelease(dict);
			
			return flag;
		}
	}
	else if ([typeName isEqualToString:@"public.png"])
	{
		CGImageDestinationRef idst = CGImageDestinationCreateWithURL((CFURLRef)absoluteURL, (CFStringRef)typeName, 1, NULL);
		
		if (idst)
		{
			CGImageDestinationAddImageFromSource(idst, isrc, 0, NULL);
			
			BOOL flag = CGImageDestinationFinalize(idst);
			
			CFRelease(isrc);
			CFRelease(idst);
			
			return flag;
		}
	}
	else if ([typeName isEqualToString:@"com.compuserve.gif"])
	{
		CGImageDestinationRef idst = CGImageDestinationCreateWithURL((CFURLRef)absoluteURL, (CFStringRef)typeName, 1, NULL);
		
		if (idst)
		{
			CGImageDestinationAddImageFromSource(idst, isrc, 0, NULL);
			
			BOOL flag = CGImageDestinationFinalize(idst);
			
			CFRelease(isrc);
			CFRelease(idst);
			
			return flag;
		}
	}
	else if ([typeName isEqualToString:@"com.microsoft.bmp"])
	{
		CGImageDestinationRef idst = CGImageDestinationCreateWithURL((CFURLRef)absoluteURL, (CFStringRef)typeName, 1, NULL);
		
		if (idst)
		{
			CGImageDestinationAddImageFromSource(idst, isrc, 0, NULL);
			
			BOOL flag = CGImageDestinationFinalize(idst);
			
			CFRelease(isrc);
			CFRelease(idst);
			
			return flag;
		}
	}
	else if ([typeName isEqualToString:@"public.jpeg-2000"])
	{
		CGImageDestinationRef idst = CGImageDestinationCreateWithURL((CFURLRef)absoluteURL, (CFStringRef)typeName, 1, NULL);
		
		if (idst)
		{
			CFMutableDictionaryRef properties = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
			CFDictionarySetValue(properties, kCGImageDestinationLossyCompressionQuality, [NSNumber numberWithFloat:(float)1.0]);
			
			CGImageDestinationAddImageFromSource(idst, isrc, 0, properties);
			
			BOOL flag = CGImageDestinationFinalize(idst);
			
			CFRelease(isrc);
			CFRelease(idst);
			CFRelease(properties);
			
			return flag;
		}
	}
	else if ([typeName isEqualToString:@"public.jpeg"])
	{
		CGImageDestinationRef idst = CGImageDestinationCreateWithURL((CFURLRef)absoluteURL, (CFStringRef)typeName, 1, NULL);
		
		if (idst)
		{
			CFMutableDictionaryRef properties = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
			CFMutableDictionaryRef dict = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
			CFDictionarySetValue(dict, kCGImagePropertyJFIFIsProgressive, [NSNumber numberWithBool:YES]);
			CFDictionarySetValue(properties, kCGImagePropertyJFIFDictionary, dict);
			CFDictionarySetValue(properties, kCGImageDestinationLossyCompressionQuality, [NSNumber numberWithFloat:(float)1.0]);
			
			CGImageDestinationAddImageFromSource(idst, isrc, 0, properties);
			
			BOOL flag = CGImageDestinationFinalize(idst);
			
			CFRelease(isrc);
			CFRelease(idst);
			CFRelease(properties);
			CFRelease(dict);
			
			return flag;
		}
	}
	
	CFRelease(isrc);
	
	return NO;
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
