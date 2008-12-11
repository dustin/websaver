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
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1];

    	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"net.spy.WebSaver"];
        [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
            @"http://bleu.west.spy.net/~dustin/", @"url", nil]];

        url = [defaults valueForKey: @"url"];
        webview = [[WebView alloc] initWithFrame:frame frameName:@"main" groupName:@"main"];
        [self addSubview:webview];
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
    return;
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

@end
