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
        url = @"http://www.spy.net/";
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
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
