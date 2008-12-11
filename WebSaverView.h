//
//  WebSaverView.h
//  WebSaver
//
//  Created by Dustin Sallings on 2008/12/11.
//  Copyright (c) 2008, Dustin Sallings <dustin@spy.net>. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import <WebKit/WebKit.h>

@interface WebSaverView : ScreenSaverView 
{
    IBOutlet id configSheet;
    IBOutlet NSTextField *urlField;

    NSString *url;
    WebView *webview;
}

- (IBAction) closeSheetSave:(id) sender;
- (IBAction) closeSheetCancel:(id) sender;

@end
