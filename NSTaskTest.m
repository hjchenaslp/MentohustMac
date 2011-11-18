//
//  NSTaskTest.m
//  mentohust for mac
//
//  Created by GaoZheng on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSTaskTest.h"
#import <Security/Security.h>


@implementation NSTaskTest

//- (void) doTest
static void doTest()
{
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:@"/sbin/ifconfig"];
	
	NSArray *arguments = [NSArray arrayWithObjects:nil];
	[task setArguments:arguments];
	
	NSPipe *pipe = [NSPipe pipe];
	[task setStandardOutput:pipe];
	
	NSFileHandle *file;
	file = [pipe fileHandleForReading];
	
	[task launch];
	
	NSData *data = [file readDataToEndOfFile];
	
	NSString *theString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSLog(@"\nifconfig reads: %@", theString);
}

- (void) boundleTest
{
	NSBundle *bundle = [NSBundle mainBundle];
	NSURL *url = [bundle URLForResource:@"mentohust" withExtension:nil];
	NSLog(@"\nBundle path: %@", [url absoluteString]);
}

- (void) fileOpTest
{
	AuthorizationRef authRef;
	
	OSStatus authStatus;
	authStatus = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, 
									 kAuthorizationFlagDefaults, &authRef);
	if (authStatus == errAuthorizationSuccess) {
		NSLog(@"AuthorizationCreateSuccess");
	}
	
	AuthorizationItem authItem;
	authItem.name = "com.mentohust.rootRight";
	authItem.value = NULL;
	authItem.valueLength = 0;
	authItem.flags = 0;
	
	AuthorizationRights authRights;
	authRights.count = 1;
	authRights.items = &authItem;
	
	AuthorizationFlags authFlags;
	authFlags = kAuthorizationFlagDefaults | kAuthorizationFlagExtendRights |
	kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize;
	
	authStatus = AuthorizationCopyRights(authRef, &authRights, 
										 kAuthorizationEmptyEnvironment, authFlags, NULL);
	
	if (authStatus == errAuthorizationSuccess) {
		NSLog(@"AuthorizationCopyRightsSuccess");
	}
	
	
	
	
	NSFileManager *manager = [[NSFileManager alloc] init];
	[manager setDelegate:self];
	NSBundle *bundle = [NSBundle mainBundle];
//	NSURL *fromUrl = [bundle URLForResource:@"README" withExtension:nil];
//	NSURL *toUrl = [[NSURL alloc] initFileURLWithPath:@"/etc/TEST.txt"];
	NSString *fromPath = [bundle pathForResource:@"mentohust" ofType:nil];
	NSString *toPath = [[NSString alloc] initWithString:@"/etc/TEST.txt"];
	
	NSLog(@"%@", fromPath);
	NSLog(@"%@", toPath);
	
	char *toolPath = (char *)[fromPath cStringUsingEncoding:NSUTF8StringEncoding];
	
//	NSError *error = nil;
//	if (![manager copyItemAtURL:fromUrl toURL:toUrl error:&error]){
//		NSLog(@"%@", error);
//	}
	
	char *args[] = {NULL};
	
	authStatus = AuthorizationExecuteWithPrivileges(authRef, 
										toolPath
									   , kAuthorizationFlagDefaults, args, NULL);
	NSLog(@"%d", authStatus);
	
	AuthorizationFree(authRef, kAuthorizationFlagDestroyRights);
}



@end




















