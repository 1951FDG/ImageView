//
//  MyCheck.m
//  ImageView
//
//  Created by administrator on 21-08-11.
//  Copyright 2011 1951FDG. All rights reserved.
//

#import "MyCheck.h"


@implementation MyCheck

+ (BOOL)validateImageSize:(GLint)maxImageSize
{
	CGDirectDisplayID display = CGMainDisplayID();
	CGOpenGLDisplayMask myDisplayMask = CGDisplayIDToOpenGLDisplayMask(display);
	CGLPixelFormatAttribute attribs[] = {kCGLPFADisplayMask, myDisplayMask, 0};
	CGLPixelFormatObj pixelFormat = NULL;
	GLint numPixelFormats = 0;
	CGLContextObj myCGLContext = 0;
	CGLContextObj curr_ctx = CGLGetCurrentContext();
	CGLChoosePixelFormat(attribs, &pixelFormat, &numPixelFormats);
	
	if (pixelFormat)
	{
		CGLCreateContext(pixelFormat, NULL, &myCGLContext);
		CGLDestroyPixelFormat(pixelFormat);
		CGLSetCurrentContext(myCGLContext);
		
		if (myCGLContext)
		{
			GLint myMaxTextureSize1;
			GLint myMaxTextureSize2;
			
			glGetIntegerv(GL_MAX_TEXTURE_SIZE, &myMaxTextureSize1);
			glGetIntegerv(GL_MAX_RECTANGLE_TEXTURE_SIZE_ARB, &myMaxTextureSize2);
			
			GLint maxTextureSize = myMaxTextureSize1 < myMaxTextureSize2 ? myMaxTextureSize1 : myMaxTextureSize2;
			
			CGLDestroyContext(myCGLContext);
			CGLSetCurrentContext(curr_ctx);
			
			return (maxImageSize > maxTextureSize ? NO : YES);
		}
	}
	
	CGLDestroyContext(myCGLContext);
	CGLSetCurrentContext(curr_ctx);
	
	return YES;
}

@end
