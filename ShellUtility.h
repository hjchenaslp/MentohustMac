//
//  ShellUtility.h
//  mentohust for mac
//
//  Created by GaoZheng on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Security/Security.h>

@interface ShellUtility : NSObject {
//	AuthorizationRef authRef;
}

-(AuthorizationRef)getAuthRef;
-(void)initAuth;
-(void)destoryAuth;
-(void)releaseAuth;

-(OSStatus)doMakeDir:(NSString *)dir;
-(OSStatus)doCopyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;
-(OSStatus)doRunScript:(NSString *)scriptPath withArguments:(NSArray *)arguments;

@end
