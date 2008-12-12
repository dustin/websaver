//
//  WebSaverView.m
//  WebSaver
//
//  Created by Dustin Sallings on 2008/12/11.
//  Copyright (c) 2008, Dustin Sallings <dustin@spy.net>. All rights reserved.
//

#import "WebSaverView.h"

@implementation WebSaverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    NSLog(@"initting with %dx%d at %d,%d (preview: %d)",
        (int)frame.size.width, (int)frame.size.height,
        (int)frame.origin.x, (int)frame.origin.y, isPreview);
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
    	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"net.spy.WebSaver"];
        [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
            @"http://bleu.west.spy.net/~dustin/", @"url",
            [NSNumber numberWithInt: 0], @"refresh",
            nil]];

        url = [defaults valueForKey: @"url"];
        refresh = [defaults integerForKey: @"refresh"];
        webview = [[WebView alloc] initWithFrame:[self bounds] frameName:@"main" groupName:@"main"];
        [self addSubview:webview];

        NSLog(@"Setting animation interval to %d", refresh);
        if(refresh > 0) {
            [self setAnimationTimeInterval: refresh];
        } else {
            // Arbitrarily large magic number.
            [self setAnimationTimeInterval: (2 << 24)];
        }
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
    [[webview mainFrame] loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:url]]];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    [webview reload:self];
}

- (BOOL)hasConfigureSheet
{
    return YES;
}

// Display the configuration sheet for the user to choose their settings
- (NSWindow*)configureSheet
{
	// if we haven't loaded our configure sheet, load the nib named MyScreenSaver.nib
	if (!configSheet) {
		[NSBundle loadNibNamed:@"WebSaver" owner:self];
    }

    [urlField setStringValue:url];
    [refreshSlider setIntValue:refresh];
    [self changedRefresh: refreshSlider];

	return configSheet;
}

// Called when the user clicked the SAVE button
- (IBAction) closeSheetSave:(id) sender
{
    // get the defaults
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"net.spy.WebSaver"];
	
	// write the defaults
    url = [urlField stringValue];
	[defaults setValue:url forKey:@"url"];
    [defaults setInteger:[refreshSlider intValue] forKey:@"refresh"];
	
	// synchronize
    [defaults synchronize];

	// end the sheet
    [NSApp endSheet:configSheet];
}

// Called when th user clicked the CANCEL button
- (IBAction) closeSheetCancel:(id) sender
{
	// nothing to configure
    [NSApp endSheet:configSheet];
}

- (IBAction) changedRefresh:(id) sender
{
    refresh = [refreshSlider intValue];
    if(refresh == 0) {
        [refreshLabel setStringValue: @"Never"];
    } else {
        [refreshLabel setStringValue: [NSString stringWithFormat:@"%d s", refresh]];
    }
}

@end
