/*
 *  HelperTool.c
 *  mentohust for mac
 *
 *  Created by GaoZheng on 12/30/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

//#include "BetterAuthorizationSampleLib.h"

#include "Common.h"
#include <CoreServices/CoreServices.h>
#include "BetterAuthorizationSampleLib.h"
#include <unistd.h>

//#if __cplusplus
//extern "C" {
//#endif
//	void CFLog(CFStringRef format, ...);
//	void CFLogv(CFStringRef format, va_list args);
//#if __cplusplus
//}
//#endif

static OSStatus DoMyFirstCommand(
								 AuthorizationRef			auth,
								 const void *                userData,
								 CFDictionaryRef				request,
								 CFMutableDictionaryRef      response,
								 aslclient                   asl,
								 aslmsg                      aslMsg
)
{
//	FILE *fp;
//	int result;
//	if ((fp = fopen("/etc/zzz.txt", "wb")) == NULL) {
//		printf("Error");
//	}
//	asl_log(asl, aslMsg, ASL_LEVEL_DEBUG, "DoMyFirstCommand");
//	
//	return noErr;

	OSStatus					retval = noErr;
    int                         err;
	uid_t						euid;
	uid_t						ruid;
	CFNumberRef					values[2];
	long long					tmp;
	
	// Pre-conditions
	
	assert(auth != NULL);
    // userData may be NULL
	assert(request != NULL);
	assert(response != NULL);
    // asl may be NULL
    // aslMsg may be NULL
	
    // Get the UIDs.
	euid = geteuid();
	ruid = getuid();
	
	err = asl_log(asl, aslMsg, ASL_LEVEL_DEBUG, "euid=%ld, ruid=%ld", (long) euid, (long) ruid);
    assert(err == 0);
	
    // Add them to the response.
    
	tmp = euid;
	values[0] = CFNumberCreate(NULL, kCFNumberLongLongType, &tmp);
	tmp = ruid;
	values[1] = CFNumberCreate(NULL, kCFNumberLongLongType, &tmp);
	
	if ( (values[0] == NULL) || (values[1] == NULL) ) {
		retval = coreFoundationUnknownErr;
    } else {
        CFDictionaryAddValue(response, CFSTR(kSampleGetUIDsResponseRUID), values[0]);
        CFDictionaryAddValue(response, CFSTR(kSampleGetUIDsResponseEUID), values[1]);
	}
	
	if (values[0] != NULL) {
		CFRelease(values[0]);
	}
	if (values[1] != NULL) {
		CFRelease(values[1]);
	}
	
	return retval;
	
}

static const BASCommandProc kMyCommandProcs[] = {
    DoMyFirstCommand,
    NULL
};


int main(int argc, char **argv)
{
    return BASHelperToolMain(kMyCommandSet, kMyCommandProcs);
}