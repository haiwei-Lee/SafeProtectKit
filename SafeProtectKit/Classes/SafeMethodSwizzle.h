//
//  SafeMethodSwizzle.h
//  Pods
//
//  Created by biyao on 2021/6/1.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

static inline BOOL SafeSwizzleClassMethod(Class cls, SEL origSelector, SEL newSelector){
    if (!cls) return NO;
    Method originalMethod = class_getClassMethod(cls, origSelector);
    Method swizzledMethod = class_getClassMethod(cls, newSelector);
    
    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    
//    BOOL
    
    if (class_addMethod(metacls,
                        origSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /* swizzing super class method, added if not exist */
        class_replaceMethod(metacls,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(metacls,
                            newSelector,
                            class_replaceMethod(metacls,
                                                origSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
    
    return YES;
}
