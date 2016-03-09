//
//  HWNoteViewController.m
//  笔记
//
//  Created by lister on 16/2/16.
//  Copyright (c) 2016年 hongwing.com. All rights reserved.
//

#import "HWNoteViewController.h"
#import "HWNote.h"

@interface HWNoteViewController ()
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation HWNoteViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.contentTextView becomeFirstResponder];
}

/*
 * 保存笔记
*/
- (void)saveNote
{
    if ([self.delegate respondsToSelector:@selector(NoteViewController:didFulfilNote:)])
    {
        HWNote *note = [[HWNote alloc] initWithNote:self.contentTextView.text];
        NSLog(@"%@",note.noteContent);
        [self.delegate NoteViewController:self didFulfilNote:note];
        
        // 返回
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)observTextisFull
{
    self.navigationItem.rightBarButtonItem.enabled = (self.contentTextView.text.length > 0);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Note";
    self.contentTextView.text = self.noteContent;
    
    // 1.获取通知中心
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(observTextisFull)
                   name:UITextViewTextDidChangeNotification
                 object:self.contentTextView];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNote)];
    saveButtonItem.enabled = false;
    self.navigationItem.rightBarButtonItem = saveButtonItem;
}


@end
