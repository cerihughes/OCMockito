//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2016 Jonathan M. Reid. See LICENSE.txt

#import <Foundation/Foundation.h>

@class MKTReturnValueSetter;


NS_ASSUME_NONNULL_BEGIN

/*!
 * @abstract Returns chain of return value handlers.
 */
FOUNDATION_EXPORT MKTReturnValueSetter *MKTReturnValueSetterChain(void);

/*!
 * @abstract Sets the return value setter chain to nil, deallocating all of the nodes.
 */
FOUNDATION_EXPORT void MKTResetReturnValueSetterChain(void);

NS_ASSUME_NONNULL_END
