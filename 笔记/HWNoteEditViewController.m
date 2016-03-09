//
//  HWNoteEditViewController.m
//  笔记
//
//  Created by lister on 16/2/16.
//  Copyright (c) 2016年 hongwing.com. All rights reserved.
//

#import "HWNoteEditViewController.h"
#import "HWNote.h"

@interface HWNoteEditViewController ()
/** 显示日记 */
@property (strong, nonatomic) IBOutlet UITextView *noteContentTextView;

@end

@implementation HWNoteEditViewController
{
    CGFloat _fontSize;
}

#warning 添加笔记的日记存储
- (void)editNote
{
    if (self.noteContentTextView.editable == false)
    {
        self.noteContentTextView.editable = true;
        [self.noteContentTextView becomeFirstResponder];
       
        self.navigationItem.rightBarButtonItem.title = @"Save";
        // UIBarButtonItem *saveBarButttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(editNote)];
        // self.navigationItem.rightBarButtonItem = saveBarButttonItem;
        
    }else
    {
        if ([self.delegate respondsToSelector:@selector(NoteEditViewController:didEditNote:)])
        {
            HWNote *note = [HWNote note:self.noteContentTextView.text ];
            [self.delegate NoteEditViewController:self didEditNote:note];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/** 检测文本是否为空 */
- (void)observTextisFull
{
    // [self.navigationItem.rightBarButtonItems objectAtIndex:0].enabled = (self.noteContentTextView.text > 0);
    self.navigationItem.rightBarButtonItem.enabled = (self.noteContentTextView.text.length > 0);
    // UIBarButtonItem *fontBtn = [self.navigationItem.rightBarButtonItems objectAtIndex:1];
    // fontBtn.enabled = self.navigationItem.rightBarButtonItem.enabled;
    
    // NSLog(@"%@",self.navigationItem.rightBarButtonItems);
}

- (void)changeFont:(id)sender
{
    // CGFloat fontSize = [UIFont systemFontSize];
    UIBarButtonItem *btnItem = (UIBarButtonItem *)sender;
    self.noteContentTextView.editable = true;
    [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
    if (btnItem.title == @"字+")
    {
        self.noteContentTextView.font = [UIFont systemFontOfSize:_fontSize+=1.0];
    }else
    {
        self.noteContentTextView.font = [UIFont systemFontOfSize:_fontSize-=1.0];
    }
    // self.noteContentTextView.font = [UIFont systemFontOfSize:_fontSize+=1.0];
    
    self.noteContentTextView.editable = false;
    NSLog(@"%F",_fontSize);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Note";
    self.noteContentTextView.editable = false;
    self.noteContentTextView.text = self.textContent;
    _fontSize = [UIFont systemFontSize];
    
    // 1.获取通知中心
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(observTextisFull)
                   name:UITextViewTextDidChangeNotification
                 object:self.noteContentTextView];
    
    
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(editNote)];
    
    UIBarButtonItem *fontBarButtonItemUp = [[UIBarButtonItem alloc] initWithTitle:@"字+"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                           action:@selector(changeFont:)];
    
    UIBarButtonItem *fontBarButtonItemDown = [[UIBarButtonItem alloc] initWithTitle:@"字-"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                             action:@selector(changeFont:)];
    
    // self.navigationItem.rightBarButtonItem = editBarButtonItem;
    self.navigationItem.rightBarButtonItems = @[editBarButtonItem,fontBarButtonItemDown,fontBarButtonItemUp];
    
}


@end
