//
//  mentohust_for_macAppDelegate.m
//  mentohust for mac
//
//  Created by GaoZheng on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import <Security/Security.h>
//#import "Common.h"
//#import "BetterAuthorizationSampleLib.h"
#import "mentohust_for_macAppDelegate.h"
#import "ShellUtility.h"

#define NAME_MENTOHUST_CONF "mentohust.conf"
#define NAME_RUIJIE_CLIENT "8021x.exe"
#define NAME_SUCONFIG_NAME "SuConfig.dat"
#define NAME_W32N55 "W32N55.dll"
#define NAME_MENTOHUST "mentohust"

#define PATH_RUIJIE_FILES "/etc/mentohust"
#define PATH_RUIJIE_CONF_FILE "/etc"

//static AuthorizationRef authRef;

@interface mentohust_for_macAppDelegate (Private)
-(void)copyFilesToDirectory;
@end

@implementation mentohust_for_macAppDelegate

@synthesize statusMenu, aboutWindow;
@synthesize statusItem, version;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

//	self.version = [NSString stringWithFormat:@"1.0"];
	self.version = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
	// setup menulet
	[statusMenu setDelegate:self];
	statusItem = [[[NSStatusBar systemStatusBar] 
				   statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusItem setMenu:statusMenu];
	[statusItem setHighlightMode:YES];
	[statusItem setTitle:@"Rj"];
	[statusItem setToolTip:@"Mentohust for Mac"];
	[statusItem setEnabled:YES];
	
	prefsController = [[PrefsController alloc] init];
	shell = [ShellUtility new];
	if ([shell getAuthRef] == NULL) {
		[shell initAuth];
	}
	[self copyFilesToDirectory];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
	[self doDisconnect:nil];
}

- (void)applicationWillClose:(NSNotification *)noti
{
	
}

- (void)copyFilesToDirectory
{
	NSError *error = nil;
	NSArray *array = [[NSFileManager defaultManager] 
					  contentsOfDirectoryAtPath:@PATH_RUIJIE_FILES error:&error];
	//	if ([array containsObject:[NSString stringWithFormat:@"%s", NAME_W32N55]]
	//		&& [array containsObject:[NSString stringWithFormat:@"%s", NAME_SUCONFIG_NAME]]
	//		&& [array containsObject:[NSString stringWithFormat:@"%s", NAME_RUIJIE_CLIENT]]) {
	//		NSLog(@"yes");
	//	}
	
	if (array == NULL) {
		[shell doMakeDir:@PATH_RUIJIE_FILES];
	}
	
	if (![array containsObject:[NSString stringWithFormat:@"%s", NAME_RUIJIE_CLIENT]]) {
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@NAME_RUIJIE_CLIENT ofType:nil];
		[shell doCopyFileFromPath:filePath toPath:[[NSString stringWithFormat:@"%s", PATH_RUIJIE_FILES] 
												   stringByAppendingPathComponent:@NAME_RUIJIE_CLIENT]];
		NSLog(@"File %s copied to %s", NAME_RUIJIE_CLIENT, PATH_RUIJIE_FILES);
	}
	
	if (![array containsObject:[NSString stringWithFormat:@"%s", NAME_SUCONFIG_NAME]]) {
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@NAME_SUCONFIG_NAME ofType:nil];
		[shell doCopyFileFromPath:filePath toPath:[[NSString stringWithFormat:@"%s", PATH_RUIJIE_FILES] 
												   stringByAppendingPathComponent:@NAME_SUCONFIG_NAME]];
		NSLog(@"File %s copied to %s", NAME_SUCONFIG_NAME, PATH_RUIJIE_FILES);
	}
	
	if (![array containsObject:[NSString stringWithFormat:@"%s", NAME_W32N55]]) {
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@NAME_W32N55 ofType:nil];
		[shell doCopyFileFromPath:filePath toPath:[[NSString stringWithFormat:@"%s", PATH_RUIJIE_FILES] 
												   stringByAppendingPathComponent:@NAME_W32N55]];
		NSLog(@"File %s copied to %s", NAME_W32N55, PATH_RUIJIE_FILES);
	}
	
	array = [[NSFileManager defaultManager] 
			 contentsOfDirectoryAtPath:@PATH_RUIJIE_CONF_FILE error:&error];
	if (![array containsObject:[NSString stringWithFormat:@"%s", NAME_MENTOHUST_CONF]]) {
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@NAME_MENTOHUST_CONF ofType:nil];
		[shell doCopyFileFromPath:filePath toPath:[[NSString stringWithFormat:@"%s", PATH_RUIJIE_CONF_FILE]
												   stringByAppendingPathComponent:@NAME_MENTOHUST_CONF]];
		NSLog(@"File %s copied to %s", NAME_MENTOHUST_CONF, PATH_RUIJIE_CONF_FILE);
	}
	
}

- (IBAction)openAbout:(id)sender
{
	[aboutWindow makeKeyAndOrderFront:nil];
	[aboutWindow orderFrontRegardless];
	[aboutWindow center];
}

- (IBAction)openPrefences:(id)sender
{
	[prefsController openPreferences];
}

- (IBAction)exit:(id)sender
{
//	if (prefsController.exitStatus == NSOnState) {
//		[shell destoryAuth];
//	}
	
	[[NSApplication sharedApplication] terminate:self];
}

- (IBAction)doConnect:(id)sender;
{
	NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@NAME_MENTOHUST ofType:nil];
	
	NSArray *argArray = [[NSArray alloc] 
						  initWithObjects:[NSString stringWithFormat:@"-u%@", prefsController.userName],
						 [NSString stringWithFormat:@"-p%@", prefsController.password],
						 @"-d2", @"-w", nil];
	
	[shell doRunScript:scriptPath withArguments:argArray];
	[argArray release];
	
}

- (IBAction)doDisconnect:(id)sender
{
	NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@NAME_MENTOHUST ofType:nil];
	NSArray *argArray = [[NSArray alloc] initWithObjects:@"-k", nil];
	[shell doRunScript:scriptPath withArguments:argArray];
	[argArray release];
}

@end
