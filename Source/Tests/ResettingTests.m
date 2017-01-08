//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2017 Jonathan M. Reid. See LICENSE.txt

#import "OCMockito.h"

#import <objc/runtime.h>
#import <OCHamcrest/OCHamcrest.h>
#import <XCTest/XCTest.h>


static NSPointerArray *_trackedObjects;

@interface NSObject (MKTTrackAllocations)
@end

@implementation NSObject (MKTTrackAllocations)

+ (id)mkt_swizzledAlloc __attribute__((ns_returns_retained))
{
    id result = [self allocWithZone:nil];

    if (![result isKindOfClass:[NSString class]] && [NSStringFromClass([result class]) hasPrefix:@"MKT"]) {
        [_trackedObjects addPointer:(__bridge void *)(result)];
    }

    return result;
}

@end

@interface ResettingTests : XCTestCase
@end

@implementation ResettingTests
{
    Method originalAlloc;
    Method ourAlloc;
}

- (void)setUp
{
    [super setUp];

    _trackedObjects = [NSPointerArray weakObjectsPointerArray];

    originalAlloc = class_getClassMethod([NSObject class], @selector(alloc));
    ourAlloc = class_getClassMethod([NSObject class], @selector(mkt_swizzledAlloc));
    method_exchangeImplementations(originalAlloc, ourAlloc);
}

- (void)tearDown
{
    method_exchangeImplementations(ourAlloc, originalAlloc);

    @autoreleasepool {
        _trackedObjects.count = 0;
        _trackedObjects = nil;
    }

    [super tearDown];
}

- (void)testResetting
{
    @autoreleasepool {
        NSString *aMock = mock([NSString class]);

        [given([aMock stringByAppendingString:@"FOO"]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
            NSArray *arguments = [invocation mkt_arguments];
            assertThatUnsignedInteger(arguments.count, is(equalToUnsignedInteger(1)));
            return @"BAR";
        }];

        [aMock stringByAppendingString:@"FOO"];
        stopMocking(aMock);
    }

    assertThatUnsignedInteger([self countOfAllocatedInstances], isNot(equalToUnsignedInteger(0u)));

    @autoreleasepool {
        stopAllMocks();
    }

    assertThatUnsignedInteger([self countOfAllocatedInstances], is(equalToUnsignedInteger(0u)));
}

- (NSUInteger)countOfAllocatedInstances
{
    @autoreleasepool {
        NSPointerArray *snapshot = [_trackedObjects copy];
        [snapshot compact];
        return snapshot.count;
    }
}

@end
