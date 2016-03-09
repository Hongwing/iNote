//
//  HWNote.m
//  笔记
//
//  Created by lister on 16/2/16.
//  Copyright (c) 2016年 hongwing.com. All rights reserved.
//

#import "HWNote.h"

@implementation HWNote

- (instancetype)initWithNote:(NSString *)Content
{
    if (self = [super init])
    {
        self.noteContent = Content;
        // self.noteDate = date;
    }
    return self;
}

+ (instancetype)note:(NSString *)Content
{
    return [[HWNote alloc] initWithNote:Content];
}

/*
 * coding 协议方法
 */
// 归档对象
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.noteContent forKey:@"content"];
    // [aCoder encodeObject:self.noteDate forKey:@"createDate"];
}

// 恢复对象
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.noteContent = [aDecoder decodeObjectForKey:@"content"];
        // self.noteDate = [aDecoder decodeObjectForKey:@"createDate"];
    }
    return self;
}

@end
