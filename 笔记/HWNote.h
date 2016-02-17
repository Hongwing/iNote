//
//  HWNote.h
//  笔记
//
//  Created by lister on 16/2/16.
//  Copyright (c) 2016年 hongwing.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWNote : NSObject<NSCoding>
/** 笔记内容 */
@property (nonatomic,copy) NSString *noteContent;

- (instancetype)initWithNote:(NSString *)Content;

+ (instancetype)note:(NSString *)Content;

@end
