//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2017 Jonathan M. Reid. See LICENSE.txt

#import <Foundation/Foundation.h>

@class MKTArgumentGetter;


NS_ASSUME_NONNULL_BEGIN

/*!
 * @abstract Returns chain of argument getters.
 */
FOUNDATION_EXPORT MKTArgumentGetter *MKTArgumentGetterChain(void);

/*!
 * @abstract Sets the argument getter chain to nil, deallocating all of the nodes.
 */
FOUNDATION_EXPORT void MKTResetArgumentGetterChain(void);

NS_ASSUME_NONNULL_END
