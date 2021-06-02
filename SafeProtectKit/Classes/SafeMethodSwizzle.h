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
    
    BOOL didAddMethod = class_addMethod(metacls,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        /* swizzing super class method, added if not exist */
        class_replaceMethod(metacls,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        /* swizzleMethod maybe belong to super */
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return YES;
}

static inline BOOL SafeSwizzleInstanceMethod(Class cls, SEL origSelector, SEL newSelector){
    if (!cls) return NO;
    /* if current class not exist selector, then get super*/
    Method originalMethod = class_getInstanceMethod(cls, origSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, newSelector);
    
    BOOL didAddMethod = class_addMethod(cls,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    /* add selector if not exist, implement append with method */
    if (didAddMethod) {
        /* replace class instance method, added if selector not exist */
        /* for class cluster , it always add new selector here */
        class_replaceMethod(cls,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        /* swizzleMethod maybe belong to super */
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return YES;
}
