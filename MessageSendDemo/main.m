//
//  main.m
//  MessageSendDemo
//
//  Created by 曾文斌 on 2017/7/26.
//  Copyright © 2017年 yww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface MyObject2 : NSObject
- (void) func3;
- (void) func4;
@end

@implementation MyObject2

- (void) func3 {
    NSLog(@"func3");
}
- (void) func4 {
    NSLog(@"func4");
}

@end

void func2(id self, SEL _cmd) {
    NSLog(@"func2");
}

@interface MyObject : NSObject

- (void) func1;

@end

@implementation MyObject

- (void) func1 {
    NSLog(@"func1");
}

// 第一次尝试
+ (BOOL) resolveInstanceMethod:(SEL)sel {
    if(sel == @selector(func2)) {
        class_addMethod(self, @selector(func2), (IMP)func2, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
// 第二次尝试
- (id) forwardingTargetForSelector:(SEL)aSelector {
    if(aSelector == @selector(func3)) {
        return [MyObject2 new];
    }
    return [super forwardingTargetForSelector:aSelector];
}
// 第三次尝试
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if(aSelector == @selector(func4)) {
        return [[MyObject2 new] methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}
-(void)forwardInvocation:(NSInvocation *)anInvocation {
    if(anInvocation.selector == @selector(func4)) {
        [anInvocation invokeWithTarget:[MyObject2 new]];
    }
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [[MyObject new] func1];
        [[MyObject new] performSelector:@selector(func2)];
        [[MyObject new] performSelector:@selector(func3)];
        [[MyObject new] performSelector:@selector(func4)];
    }
    return 0;
}
