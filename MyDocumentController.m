//
//  MyDocumentController.m
//  ImageView
//
//  Created by administrator on 21-08-11.
//  Copyright 2011 1951FDG. All rights reserved.
//

#import "MyDocumentController.h"


@implementation MyDocumentController

- (id)openUntitledDocumentAndDisplay:(BOOL)displayDocument error:(NSError **)outError
{
	NSString *type = [self defaultType];
	
	NSDocument *result = [self makeUntitledDocumentOfType:type error:outError];
	
	if (result != nil)
	{
		[self addDocument:result];
	}
	
	return result;
}	

- (NSInteger)runModalOpenPanel:(NSOpenPanel *)openPanel forTypes:(NSArray *)types
{
	//[openPanel setShowsHiddenFiles:YES];
	[openPanel setTreatsFilePackagesAsDirectories:YES];
	return [openPanel runModalForTypes:types];
}

- (id)openDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)displayDocument error:(NSError **)outError
{
	NSDocument *result = [self documentForURL:absoluteURL];
	
	if (result == nil)
	{
		NSString *typeName = [self typeForContentsOfURL:absoluteURL error:outError];
		
		result = [self makeDocumentWithContentsOfURL:absoluteURL ofType:typeName error:outError];
		
		if (result != nil)
		{
			[self addDocument:result];
		}
	}
	else if (displayDocument)
	{
		[[[[result windowControllers] objectAtIndex:0] window] makeKeyAndOrderFront:self];
	}
	
	return result;
}

- (NSString *)defaultType
{
	return @"public.tiff";
}

- (NSArray *)documentClassNames
{
	return [NSArray arrayWithObject:@"MyDocument"];
}

- (Class)documentClassForType:(NSString *)typeName
{
	return [[NSBundle mainBundle] classNamed:@"MyDocument"];
}

- (NSString *)displayNameForType:(NSString *)typeName
{
	if ([typeName isEqualToString:@"public.tiff"])
	{
		return @"TIFF";
	}
	else if ([typeName isEqualToString:@"public.png"])
	{
		return @"PNG";
	}
	else if ([typeName isEqualToString:@"com.compuserve.gif"])
	{
		return @"GIF";
	}
	else if ([typeName isEqualToString:@"com.microsoft.bmp"])
	{
		return @"BMP";
	}
	else if ([typeName isEqualToString:@"public.jpeg-2000"])
	{
		return @"JPEG-2000";
	}
	else if ([typeName isEqualToString:@"public.jpeg"])
	{
		return @"JPEG";
	}
	else
	{
		return [super displayNameForType:typeName];
	}
}

@end
