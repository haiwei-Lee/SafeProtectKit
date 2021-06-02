//
//  NSArray+SafeProtectKit.m
//  Pods-SafeProtectKit_Tests
//
//  Created by biyao on 2021/6/1.
//

#import "NSArray+SafeProtectKit.h"
#import "SafeMethodSwizzle.h"
#import "SafeDefines.h"

@implementation NSArray (SafeProtectKit)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SafeSwizzleClassMethod([NSArray class], @selector(arrayWithObject:), @selector(__NSArray_arrayWithObject:));
        SafeSwizzleClassMethod([NSArray class], @selector(arrayWithObjects:count:), @selector(__NSArray_arrayWithObjects:count:));
        SafeSwizzleClassMethod(objc_getClass("__NSPlaceholderArray"), @selector(initWithObjects:count:), @selector(__NSArray_initWithObjects:count:));
        
        {
            Class cls = NSClassFromString(@"__NSArray0");
            if (@available(iOS 10.0, *)) {
                SafeSwizzleInstanceMethod(cls, @selector(objectAtIndex:), @selector(__NSArray0_objectAtIndex:));
            }
            SafeSwizzleInstanceMethod(cls, @selector(subarrayWithRange:), @selector(__NSArray0_subarrayWithRange:));
        }
        
        {
            Class cls = NSClassFromString(@"__NSArrayI");
            if (@available(iOS 10.0, *)) {
                SafeSwizzleInstanceMethod(cls, @selector(objectAtIndex:), @selector(__NSArrayI_objectAtIndex:));
            }
            SafeSwizzleInstanceMethod(cls, @selector(objectAtIndexedSubscript:), @selector(__NSArrayI_objectAtIndexedSubscript:));
            SafeSwizzleInstanceMethod(cls, @selector(subarrayWithRange:), @selector(__NSArrayI_subarrayWithRange:));
        }
        
        {
            Class cls = NSClassFromString(@"__NSSingleObjectArrayI");
            if (@available(iOS 10.0, *)) {
                SafeSwizzleInstanceMethod(cls, @selector(objectAtIndex:), @selector(__NSSingleObjectArrayI_objectAtIndex:));
            }
            SafeSwizzleInstanceMethod(cls, @selector(subarrayWithRange:), @selector(__NSSingleObjectArrayI_subarrayWithRange:));
        }
    });
}

+ (instancetype)__NSArray_arrayWithObject:(id)anObject{
    if (anObject) {
        return [self __NSArray_arrayWithObject:anObject];
    }else{
        NSLog(@"%@",[NSString stringWithFormat:@"[%@ %@] invalid args anObject: %@",self.class,NSStringFromSelector(@selector(arrayWithObject:)),anObject]);
    }
    return nil;
}

+ (instancetype)__NSArray_arrayWithObjects:(const id _Nonnull [_Nonnull])objects count:(NSUInteger)cnt{
    NSInteger index = 0;
    id objs[cnt];
    
    for (NSInteger i = 0; i < cnt; i++) {
        if (objects[i]) {
            objs[index++] = objects[i];
        }else{
            NSLog(@"%@",[NSString stringWithFormat:@"[%@ %@] invalid args object: %@ index: %@",self.class,NSStringFromSelector(@selector(arrayWithObjects:count:)),objects[i],@(i)]);
        }
    }
    return [self __NSArray_arrayWithObjects:objects count:cnt];
}

- (instancetype)__NSArray_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    NSInteger newObjsIndex = 0;
    id newObjects[cnt];
    
    for (int i = 0; i < cnt; i++) {
        if (objects[i] != nil) {
            newObjects[newObjsIndex] = objects[i];
            newObjsIndex++;
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"[%@ %@] invalid args object: %@ index: %@",self.class,NSStringFromSelector(@selector(initWithObjects:count:)),objects[i],@(i)]);
        }
    }
    
    return [self __NSArray_initWithObjects:newObjects count:newObjsIndex];
}

#pragma mark - __NSArray0

- (id)__NSArray0_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self __NSArray0_objectAtIndex:index];
    } else {
        NSLog(@"%@",[NSString stringWithFormat:@"[%@ %@] index %@ beyond bounds [0..%@]",self.class,NSStringFromSelector(@selector(objectAtIndex:)),@(index),@(self.count)]);
    }
    
    return nil;
}

- (NSArray *)__NSArray0_subarrayWithRange:(NSRange)range {
    if (SafeMaxRange(range) <= self.count){
        return [self __NSArray0_subarrayWithRange:range];
    } else if (range.location < self.count){
        return [self __NSArray0_subarrayWithRange:NSMakeRange(range.location, self.count-range.location)];
    } else {
        NSLog(@"%@",[NSString stringWithFormat:@"[%@ %@] range %@ beyond bounds [0..%@]",self.class,NSStringFromSelector(@selector(subarrayWithRange:)),NSStringFromRange(range),@(self.count)]);
    }
    
    return nil;
}

#pragma mark - __NSArrayI

- (id)__NSArrayI_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self __NSArrayI_objectAtIndex:index];
    } else {
        NSLog(@"%@",[NSString stringWithFormat:@"[%@ %@] index %@ beyond bounds [0..%@]",self.class,NSStringFromSelector(@selector(objectAtIndex:)),@(index),@(self.count)]);
    }
    
    return nil;
}

- (id)__NSArrayI_objectAtIndexedSubscript:(NSInteger)index {
    if (index < self.count) {
        return [self __NSArrayI_objectAtIndexedSubscript:index];
    } else {
        NSLog(@"%@",[NSString stringWithFormat:@"[%@ %@] index %@ beyond bounds [0..%@]",self.class,NSStringFromSelector(@selector(objectAtIndex:)),@(index),@(self.count)]);
    }
    
    return nil;
}

- (NSArray *)__NSArrayI_subarrayWithRange:(NSRange)range {
    if (SafeMaxRange(range) <= self.count){
        return [self __NSArrayI_subarrayWithRange:range];
    } else if (range.location < self.count){
        return [self __NSArrayI_subarrayWithRange:NSMakeRange(range.location, self.count-range.location)];
    } else {
        NSLog(@"%@",[NSString stringWithFormat:@"[%@ %@] range %@ beyond bounds [0..%@]",self.class,NSStringFromSelector(@selector(subarrayWithRange:)),NSStringFromRange(range),@(self.count)]);
    }
    
    return nil;
}

#pragma mark - __NSSingleObjectArrayI

- (id)__NSSingleObjectArrayI_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self __NSSingleObjectArrayI_objectAtIndex:index];
    } else {
        NSLog(@"%@",[NSString stringWithFormat:@"[%@ %@] index %@ beyond bounds [0..%@]",self.class,NSStringFromSelector(@selector(objectAtIndex:)),@(index),@(self.count)]);
    }
    
    return nil;
}

- (NSArray *)__NSSingleObjectArrayI_subarrayWithRange:(NSRange)range {
    if (SafeMaxRange(range) <= self.count){
        return [self __NSSingleObjectArrayI_subarrayWithRange:range];
    } else if (range.location < self.count){
        return [self __NSSingleObjectArrayI_subarrayWithRange:NSMakeRange(range.location, self.count-range.location)];
    } else {
        NSLog(@"%@",[NSString stringWithFormat:@"[%@ %@] range %@ beyond bounds [0..%@]",self.class,NSStringFromSelector(@selector(subarrayWithRange:)),NSStringFromRange(range),@(self.count)]);
    }
    
    return nil;
}


@end
