//
//  SafeDefines.h
//  Pods
//
//  Created by biyao on 2021/6/2.
//

NS_INLINE NSUInteger SafeMaxRange(NSRange range) {
    if (range.location >= NSNotFound || range.length >= NSNotFound) {
        return NSNotFound;
    }
    
    if ((range.location + range.length) < range.location) {
        return NSNotFound;
    }
    
    return (range.location + range.length);
}
