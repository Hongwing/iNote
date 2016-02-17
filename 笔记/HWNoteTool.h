//
//  HWNoteTool.h
//  笔记
//
//  Created by lister on 16/2/16.
//  Copyright (c) 2016年 hongwing.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HWNote;

@interface HWNoteTool : NSObject

/** 所有笔记 */
+ (NSMutableArray *)allNotes;
/** 添加笔记 */
+ (void)addANewNote:(HWNote *)note;
/** 删除笔记 */
+ (void)deleteNoteAtIndex:(NSInteger)index;
/** 更新 */
+ (void)updateNotesInfo;
@end
