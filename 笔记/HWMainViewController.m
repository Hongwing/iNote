//
//  HWMainViewController.m
//  笔记
//
//  Created by lister on 16/2/16.
//  Copyright (c) 2016年 hongwing.com. All rights reserved.
//

#import "HWMainViewController.h"
#import "HWNote.h"
#import "HWNoteTool.h"
#import "HWNoteViewController.h"
#import "HWNoteEditViewController.h"

@interface HWMainViewController ()<HWNoteViewControllerDelegate,HWNoteEditViewControllerDelegate>
/** 新建笔记 */
@property (strong, nonatomic) IBOutlet UIButton *writeNoteButton;
/** 提示label */
@property (strong, nonatomic) IBOutlet UILabel *emptyLabel;
/** 添加新笔记 */
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addNewNote;
/** 笔记库 */
@property (strong,nonatomic) NSMutableArray *noteList;
/** tableview */
@property (strong, nonatomic) IBOutlet UITableView *noteTableView;

@end
@implementation HWMainViewController
/** 懒加载 */
- (NSMutableArray *)noteList
{
    if (!_noteList)
    {
        _noteList = [NSMutableArray array];
    }
    return _noteList;
}

/*
 * 笔记代理
 */
- (void)NoteViewController:(HWNoteViewController *)noteVc didFulfilNote:(HWNote *)note
{    
    // HWNote *nt = note;
    // [self.noteList addObject:nt];
    [HWNoteTool addANewNote:note];
    [HWNoteTool updateNotesInfo];
    [self.noteTableView reloadData];
}

- (void)NoteEditViewController:(HWNoteEditViewController *)editVc didEditNote:(HWNote *)note
{
    NSLog(@"%@",note.noteContent);
    [[HWNoteTool allNotes] replaceObjectAtIndex:[self.noteTableView indexPathForSelectedRow].row withObject:note];
    [HWNoteTool updateNotesInfo];
    [self.noteTableView reloadData];
}

#pragma mark - 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[HWNoteTool allNotes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 标识符
    static NSString *cellID = @"notecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    // if (cell == nil)
    {
        // cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        NSInteger rowNo = indexPath.row;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 14.0;
        HWNote *nt = (HWNote *)[[HWNoteTool allNotes] objectAtIndex:rowNo];
        UILabel *noteLabel = (UILabel *)([cell viewWithTag:1]);
        noteLabel.text = nt.noteContent;
        // cell.textLabel.text = nt.noteContent;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [HWNoteTool deleteNoteAtIndex:indexPath.row];
        [HWNoteTool updateNotesInfo];
        [self.noteTableView reloadData];
    }
}

/*
 * 修改删除文字
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


/** 重写 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    UIViewController *destVc = (HWNoteViewController *)segue.destinationViewController;
    if ([destVc isKindOfClass:[HWNoteViewController class]])
    {
        HWNoteViewController *noteVc = (HWNoteViewController *)destVc;
        // 设置代理
        noteVc.delegate = self;
    }else
    {
        // 需要先刺激一下
        // [self.navigationController pushViewController:[[HWNoteEditViewController alloc] init] animated:YES];
        HWNoteEditViewController *editVc = (HWNoteEditViewController *)destVc;
        NSInteger rowNo = [self.noteTableView indexPathForSelectedRow].row;
        HWNote *tempNote = [[HWNoteTool allNotes] objectAtIndex:rowNo];
        editVc.textContent = tempNote.noteContent;
        // 设置代理
        editVc.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 1.如果数据库不存在笔记，显示“空空如也”
    if ([HWNoteTool allNotes].count == 0)
    {
        [self.writeNoteButton setHidden:NO];
        [self.emptyLabel setHidden:NO];
        [self.noteTableView setHidden:YES];
        self.navigationItem.rightBarButtonItem = nil;
    }else
    {
        [self.writeNoteButton setHidden:YES];
        [self.emptyLabel setHidden:YES];
        [self.noteTableView setHidden:NO];
        self.navigationItem.rightBarButtonItem = self.addNewNote;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.noteTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.noteTableView.delegate = self;
    self.noteTableView.dataSource = self;
    
    [self.writeNoteButton setBackgroundColor:[UIColor cyanColor]];
    [self.emptyLabel setBackgroundColor:[UIColor grayColor]];
}



@end
