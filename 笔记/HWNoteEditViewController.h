//
//  HWNoteEditViewController.h
//  笔记
//
//  Created by lister on 16/2/16.
//  Copyright (c) 2016年 hongwing.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWNote,HWNoteEditViewController;

@protocol HWNoteEditViewControllerDelegate <NSObject>

- (void)NoteEditViewController:(HWNoteEditViewController *)editVc didEditNote:(HWNote *)note;

@end

@interface HWNoteEditViewController : UIViewController

/** 内容 */
@property (nonatomic,copy) NSString *textContent;
/** 代理 */
@property (nonatomic,weak) id<HWNoteEditViewControllerDelegate> delegate;

@end
