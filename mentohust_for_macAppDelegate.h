//
//  mentohust_for_macAppDelegate.h
//  mentohust for mac
//
//  Created by GaoZheng on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PrefsController.h"
#import "ShellUtility.h"

@interface mentohust_for_macAppDelegate : NSObject 
<NSApplicationDelegate, NSMenuDelegate> {
	
	NSString *version;
    IBOutlet NSWindow *aboutWindow;
	IBOutlet NSMenu *statusMenu;
	
	NSStatusItem *statusItem;
	
	NSInteger exitStatus;
	
	PrefsController *prefsController;
	ShellUtility *shell;
	
}

@property(retain, readwrite) IBOutlet NSWindow *aboutWindow;
@property(retain, readwrite) IBOutlet NSMenu *statusMenu;
@property(retain, readwrite) NSStatusItem *statusItem;
@property(retain, readwrite) NSString *version;

- (IBAction)openPrefences:(id)sender;
- (IBAction)openAbout:(id)sender;
- (IBAction)exit:(id)sender;
- (IBAction)doConnect:(id)sender;
- (IBAction)doDisconnect:(id)sender;

@end
