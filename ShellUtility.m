//
//  ShellUtility.m
//  mentohust for mac
//
//  Created by GaoZheng on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShellUtility.h"
#import <Security/Security.h>

#define MKDIR_PATH "/bin/mkdir"
#define CP_PATH "/bin/cp"

static AuthorizationRef authRef = NULL;

@implementation ShellUtility


-(AuthorizationRef)getAuthRef
{
	if (authRef != NULL) {
		return authRef;
	}else {
		return NULL;
	}

}

//static void initAuth()
-(void) initAuth
{
	OSStatus authStatus;
	authStatus = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, 
									 kAuthorizationFlagDefaults, &authRef);
	if (authStatus == errAuthorizationSuccess) {
		NSLog(@"AuthorizationCreateSuccess");
	}
	
	AuthorizationItem authItem;
	authItem.name = "cn.edu.scu.mentohustformac.rootRight";
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
}

//static void destroyAuth()
-(void)destoryAuth
{
	AuthorizationFree(authRef, kAuthorizationFlagDestroyRights);
}

//static void releaseauth()
-(void)releaseAuth
{
	AuthorizationFree(authRef, kAuthorizationFlagDefaults);
	authRef = NULL;
}

//static OSStatus doMakeDir()
-(OSStatus)doMakeDir:(NSString *)dir
{
	char arg1[1024];
	[dir getCString:arg1 maxLength:1024 encoding:NSUTF8StringEncoding];
	NSLog(@"%s", arg1);
	char *args[] = {arg1, NULL};
	OSStatus reval;
	
	reval = AuthorizationExecuteWithPrivileges(authRef, MKDIR_PATH, 
											   kAuthorizationFlagDefaults, args, NULL);
	return reval;
}

-(OSStatus)doCopyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
//	char arg1[1024],arg2[1024];
//	[fromPath getCString:arg1 maxLength:1024 encoding:NSUTF8StringEncoding];
//	[toPath getCString:arg2 maxLength:1024 encoding:NSUTF8StringEncoding];

	const char *arg1 = [fromPath cStringUsingEncoding:NSUTF8StringEncoding];
	const char *arg2 = [toPath cStringUsingEncoding:NSUTF8StringEncoding];
	char *args[3];
//	char *args[] = {arg1, arg2, NULL};
	args[0] = arg1;
	args[1] = arg2;
	args[2] = NULL;
	
	return AuthorizationExecuteWithPrivileges(authRef, CP_PATH, 
											  kAuthorizationFlagDefaults, args, NULL);
}

-(OSStatus)doRunScript:(NSString *)scriptPath withArguments:(NSArray *)arguments
{
	const char *toolPath = [scriptPath cStringUsingEncoding:NSUTF8StringEncoding];
	int length;
	if (arguments == nil) {
		length = 0;
	}else {
		length = [arguments count] + 1;
	}
	char *args[length];
		
	NSEnumerator *enumerator = [arguments objectEnumerator];
	NSString * temp;
	int i = 0, j = length;
	while ((temp = [enumerator nextObject]) && j-- != 0) {
		NSLog(@"argument %d: %@", i, temp);
		args[i++] = [(NSString *)temp cStringUsingEncoding:NSUTF8StringEncoding];
	}
	args[i] = NULL;

	return AuthorizationExecuteWithPrivileges(authRef, toolPath, 
											  kAuthorizationFlagDefaults, args, NULL);
}

@end
