//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2017 Jonathan M. Reid. See LICENSE.txt
//  Contribution by Ceri Hughes

#import <XCTest/XCTest.h>

#import "MockTestCase.h"
#import "ObservableObject.h"
#import "OCMockito.h"

#import <OCHamcrest/OCHamcrest.h>


@interface DisableMockingTestsHelper : NSObject <ObjectObserver>
@property (nonatomic, strong, readonly) ObservableObject *observableObject1;
@property (nonatomic, strong, readonly) ObservableObject *observableObject2;
@end

@implementation DisableMockingTestsHelper

- (instancetype)initWithObservableObject1:(ObservableObject *)observableObject1
                        observableObject2:(ObservableObject *)observableObject2
{
    self = [super init];
    if (self) {
        _observableObject1 = observableObject1;
        _observableObject2 = observableObject2;
        [_observableObject1 addObserver:self];
    }
    return self;
}

- (void)dealloc
{
    [_observableObject1 removeObserver:self];
    [_observableObject2 removeObserver:self];
}

@end


@interface DisableMockingTests : XCTestCase
@end

@implementation DisableMockingTests
{
    NSMutableArray *trackedMocks;
}

- (void)setUp
{
    [super setUp];
    trackedMocks = [NSMutableArray array];
}

- (void)tearDown
{
    stopAllMocks();
    trackedMocks = nil;
    [super tearDown];
}

- (void)testStoppingMocks_Object1ThenObject2_ShouldNotCrash
{
    ObservableObject *mockObservableObject1 = mock([ObservableObject class]);
    ObservableObject *mockObservableObject2 = mock([ObservableObject class]);

    [trackedMocks addObject:mockObservableObject1];
    [trackedMocks addObject:mockObservableObject2];
    
    [[DisableMockingTestsHelper alloc] initWithObservableObject1:mockObservableObject1
                                               observableObject2:mockObservableObject2];
}

- (void)testStoppingMocks_Object2ThenObject1_ShouldNotCrash
{
    ObservableObject *mockObservableObject1 = mock([ObservableObject class]);
    ObservableObject *mockObservableObject2 = mock([ObservableObject class]);

    [trackedMocks addObject:mockObservableObject2];
    [trackedMocks addObject:mockObservableObject1];
    
    [[DisableMockingTestsHelper alloc] initWithObservableObject1:mockObservableObject1
                                               observableObject2:mockObservableObject2];
}

@end
