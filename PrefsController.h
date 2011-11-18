//
//  PrefsController.h
//  mentohust for mac
//
//  Created by GaoZheng on 12/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PrefsController : NSWindowController <NSWindowDelegate> {

	IBOutlet NSTextField *userNameTextField;
	IBOutlet NSSecureTextField *passwordTextField;
	IBOutlet NSButton *disconnectWhenExitButton;
	
	NSMutableDictionary *prefs;
	NSString *userName;
	NSString *password;
//	NSInteger exitStatus;
	
	NSString *testString;
	
}

@property(retain, readwrite) IBOutlet NSTextField *userNameTextField;
@property(retain, readwrite) IBOutlet NSSecureTextField *passwordTextField;
@property(retain, readwrite) IBOutlet NSButton *disconnectWhenExitButton;
@property(copy, readwrite) NSString *userName;
@property(copy, readwrite) NSString *password;
@property(retain, readwrite) NSMutableDictionary *prefs;
//@property(readwrite) NSInteger exitStatus;

//@property(retain, readwrite) NSString *testString;


-(IBAction)okButtonPressed:(id)sender;

-(id)init;
-(void)openPreferences;

@end
