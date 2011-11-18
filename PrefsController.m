//
//  PrefsController.m
//  mentohust for mac
//
//  Created by GaoZheng on 12/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PrefsController.h"

@interface PrefsController (Private)
-(void)setupPrefs;
-(void)closePrefs;
-(NSString *)getPrefsPath;
@end

@implementation PrefsController

@synthesize userNameTextField, passwordTextField, disconnectWhenExitButton;
@synthesize userName, password, prefs;

-(id)init
{
	if (self = [super initWithWindowNibName:@"PrefsWindow"]) {
		NSLog(@"Initializing Prefs window");
//		[self setupPrefs];
	}
	
	userName = [[NSString alloc] init];
	password = [[NSString alloc] init];
	
	return self;
}

-(void)dealloc
{
	[userName release];
	[password release];
	[super dealloc];
}

-(void)setupPrefs
{
	prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPrefsPath]];
//	NSLog(@"%@", prefs);
	self.userName = [prefs valueForKey:@"User Name"];
	self.password = [prefs valueForKey:@"Password"];
//	NSLog(@"loading from userdefaults, username: %@, password: %@", userName, password);
}

-(void)awakeFromNib
{
	[self setupPrefs];
	if (userName != @"") {
		[userNameTextField setStringValue:userName];
	}
	if (password != @"") {
		[passwordTextField setStringValue:password];
	}
}

-(IBAction)okButtonPressed:(id)sender;
{
	NSLog(@"OK pressed");
	userName = [userNameTextField stringValue];
	password = [passwordTextField stringValue];
//	NSLog(@"username: %@, password: %@", userName, password);
	[prefs setValue:userName forKey:@"User Name"];
	[prefs setValue:password forKey:@"Password"];
	
	[self closePrefs];
}

-(void)openPreferences
{
	[[self window] makeKeyAndOrderFront:nil];
	[[self window] orderFrontRegardless];
	[[self window] center];
}

-(void)closePrefs
{
	[[self window] close];
	[prefs writeToFile:[self getPrefsPath] atomically:YES];
}

-(NSString *)getPrefsPath
{
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *prefsPath = [bundle pathForResource:@"Preferences" ofType:@"plist"];
	return prefsPath;
}

@end
