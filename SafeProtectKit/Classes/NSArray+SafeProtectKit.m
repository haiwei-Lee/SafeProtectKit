//
//  NSArray+SafeProtectKit.m
//  Pods-SafeProtectKit_Tests
//
//  Created by biyao on 2021/6/1.
//

#import "NSArray+SafeProtectKit.h"
#import "SafeMethodSwizzle.h"

@implementation NSArray (SafeProtectKit)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SafeSwizzleClassMethod([NSArray class], @selector(arrayWithObject:), @selector(__NSArray_arrayWithObject:));
    });
}

+ (instancetype)__NSArray_arrayWithObject:(id)anObject{
    if (anObject) {
        return [self __NSArray_arrayWithObject:anObject];
    }
    return nil;
}

@end
