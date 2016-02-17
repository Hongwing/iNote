
//
//  HWNoteTool.m
//  笔记
//
//  Created by lister on 16/2/16.
//  Copyright (c) 2016年 hongwing.com. All rights reserved.
//

#import "HWNoteTool.h"
#import "HWNote.h"
#define kNotesDataPath [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingString:@"notes.data"]

@implementation HWNoteTool
/** 日记列表 */
static NSMutableArray *_notesList;

+ (NSMutableArray *)allNotes
{
    _notesList = [NSKeyedUnarchiver unarchiveObjectWithFile:kNotesDataPath];
    if (!_notesList)
    {
        _notesList = [NSMutableArray array];
    }
    return _notesList;
}

+ (void)addANewNote:(HWNote *)note
{
    [_notesList addObject:note];
    [self updateNotesInfo];
}

+ (void)deleteNoteAtIndex:(NSInteger)index
{
    [_notesList removeObjectAtIndex:index];
    [self updateNotesInfo];
}

+ (void)updateNotesInfo
{
    // 存储数据
    [NSKeyedArchiver archiveRootObject:_notesList toFile:kNotesDataPath];
}

@end
