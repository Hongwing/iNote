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
            HWNote *note = [HWNote note:self.noteContentTextView.text];
            [self.delegate NoteEditViewController:self didEditNote:note];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Note";
    self.noteContentTextView.editable = false;
    self.noteContentTextView.text = self.textContent;
    
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:nil target:self action:@selector(editNote)];
    self.navigationItem.rightBarButtonItem = editBarButtonItem;
    
}


@end
