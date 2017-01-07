//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2017 Jonathan M. Reid. See LICENSE.txt

#import "MKTUnspecifiedArgumentPlaceholder.h"

@implementation MKTUnspecifiedArgumentPlaceholder

static MKTUnspecifiedArgumentPlaceholder *instance = nil;

+ (instancetype)sharedPlaceholder
{
    if (!instance)
        instance = [[self alloc] init];
    return instance;
}

+ (void)resetSharedPlaceholder
{
    instance = nil;
}

@end


