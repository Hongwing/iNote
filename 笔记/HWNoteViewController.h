//
//  HWNoteViewController.h
//  笔记
//
//  Created by lister on 16/2/16.
//  Copyright (c) 2016年 hongwing.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWNote;
@class HWNoteViewController;

@protocol HWNoteViewControllerDelegate <NSObject>

- (void)NoteViewController:(HWNoteViewController *)noteVc didFulfilNote:(HWNote *)note;

@end

@interface HWNoteViewController : UIViewController
@property (nonatomic,copy) NSString *noteContent;
/** 代理 */
@property (nonatomic,weak) id<HWNoteViewControllerDelegate> delegate;

@end
