//
//  NSURL+Additions.m
//  Demo4GT
//
//  Created   on 13-6-4.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import "NSURL+Additions.h"

@implementation NSURL (Additions)

+ (BOOL)isWebURL:(NSURL*)URL {
	if(!URL.scheme)
	{
		return NO;
	}
	else {
        return [URL.scheme caseInsensitiveCompare:@"http"] == NSOrderedSame
        || [URL.scheme caseInsensitiveCompare:@"https"] == NSOrderedSame
        || [URL.scheme caseInsensitiveCompare:@"ftp"] == NSOrderedSame
        || [URL.scheme caseInsensitiveCompare:@"ftps"] == NSOrderedSame
        || [URL.scheme caseInsensitiveCompare:@"data"] == NSOrderedSame
        || [URL.scheme caseInsensitiveCompare:@"file"] == NSOrderedSame;
	}
}

@end
