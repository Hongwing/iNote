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
#import "HWCollectionViewCell.h"

@interface HWMainViewController ()<HWNoteViewControllerDelegate,HWNoteEditViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
/** 新建笔记 */
@property (strong, nonatomic) IBOutlet UIButton *writeNoteButton;
/** 提示label */
@property (strong, nonatomic) IBOutlet UILabel *emptyLabel;
/** 添加新笔记 */
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addNewNote;
/** 显示格式 */
@property (strong,nonatomic) UIBarButtonItem *elementBarButtonItem;
/** 笔记库 */
@property (strong,nonatomic) NSMutableArray *noteList;
/** tableview */
@property (strong, nonatomic) IBOutlet UITableView *noteTableView;
/** collectionView */
@property (strong,nonatomic) UICollectionView *noteCollectionView;
/** 长按手势 */
@property (strong,nonatomic) UILongPressGestureRecognizer *deleteCollectionCellGesture;
/** 长按删除按钮 */
@property (strong,nonatomic) UIButton *delBtn;

@end
@implementation HWMainViewController
{
    /** 待删除indexpath */
    NSIndexPath *_deleteIndexpath;
    /** 删除信号 */
    NSInteger _signalDelete;
}
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
    [self.noteCollectionView reloadData];
    // [self.noteTableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)NoteEditViewController:(HWNoteEditViewController *)editVc didEditNote:(HWNote *)note
{
    NSLog(@"%@",note.noteContent);
    [[HWNoteTool allNotes] replaceObjectAtIndex:[self.noteTableView indexPathForSelectedRow].row withObject:note];
    [HWNoteTool updateNotesInfo];
    [self.noteCollectionView reloadData];
    [self.noteTableView reloadData];
}

#pragma mark - tableView代理方法
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

    NSInteger rowNo = indexPath.row;
    // cell.layer.masksToBounds = YES;
    // cell.layer.cornerRadius = 14.0;
    cell.backgroundColor = [UIColor colorWithRed:(arc4random() % 100 + 1) * 0.01
                                           green:(arc4random() % 100 + 1) * 0.01
                                            blue:(arc4random() % 100 + 1) * 0.01
                                           alpha:0.5];
    // 填充内容
    HWNote *nt = (HWNote *)[[HWNoteTool allNotes] objectAtIndex:rowNo];
    UILabel *noteLabel = (UILabel *)([cell viewWithTag:1]);
    noteLabel.text = nt.noteContent;
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [HWNoteTool deleteNoteAtIndex:indexPath.row];
        [HWNoteTool updateNotesInfo];
        [self.noteTableView reloadData];
        [self.noteCollectionView reloadData];
    }
}

/*
 * 修改删除文字
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - collectionView 代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [HWNoteTool allNotes].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 设置标识符
    static NSString *cellID = @"note";
    HWCollectionViewCell *cell = (HWCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    NSInteger rowNo = indexPath.row;
    HWNote *nt = (HWNote *)[[HWNoteTool allNotes] objectAtIndex:rowNo];
    // 填充cell
    UILabel *noteLabel = (UILabel *)([cell viewWithTag:1]);
    [noteLabel setNumberOfLines:3];
    noteLabel.text = nt.noteContent;
    // cell.backgroundColor = [UIColor cyanColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"chosing !");
    [self performSegueWithIdentifier:@"main2edit" sender:nil];
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
         
        if (self.noteTableView.hidden == true)
        {
            NSIndexPath *rowpath = [[self.noteCollectionView indexPathsForSelectedItems] objectAtIndex:0];
            NSInteger rowNoCollectionView = rowpath.row;
            HWNote *tempNote = [[HWNoteTool allNotes] objectAtIndex:rowNoCollectionView];
            editVc.textContent = tempNote.noteContent;
        }
        
        if (self.noteCollectionView.hidden == true)
        {
            NSInteger rowNoTabelView = [self.noteTableView indexPathForSelectedRow].row;
            HWNote *tempNote = [[HWNoteTool allNotes] objectAtIndex:rowNoTabelView];
            editVc.textContent = tempNote.noteContent;
        }
    
        // 设置代理
        editVc.delegate = self;
    }
    
}

/*
 * 显示模式刷新
 */
/*
- (void)displayWays
{
    if (_choseFlag == 0)
    {
        [self.navigationItem.leftBarButtonItem setTitle:@"列表显示"];
        [self.noteCollectionView setHidden:YES];
    }else
    {
        [self.navigationItem.leftBarButtonItem setTitle:@"方格显示"];
        [self.noteTableView setHidden:YES];
    }
}
 */

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.delBtn.hidden = YES;
    // 设置选择标志默认时tableView
    // 设置显示模式
    // [self elementDisplayWay];
    // 1.如果数据库不存在笔记，显示“空空如也”
    if ([HWNoteTool allNotes].count == 0)
    {
        self.navigationItem.leftBarButtonItem = nil;
        [self.writeNoteButton setHidden:NO];
        [self.emptyLabel setHidden:NO];
        [self.noteTableView setHidden:YES];
        [self.noteCollectionView setHidden:YES];
        self.navigationItem.rightBarButtonItem = nil;
        NSLog(@"空 ");
    }else
    {
        self.navigationItem.leftBarButtonItem = self.elementBarButtonItem;
        [self.writeNoteButton setHidden:YES];
        [self.emptyLabel setHidden:YES];
        [self.noteTableView setHidden:NO];
        self.navigationItem.rightBarButtonItem = self.addNewNote;
        NSLog(@"有");
    }
    
    [self elementDisplayWay];
    [self elementDisplayWay];

    
}

/**
 *  选择所有日记显示方式 -tableview -collectionView
 *  navigationBar 添加选择显示（UICollectionView and UITableView）
 */

- (void)elementDisplayWay
{
    self.delBtn.hidden = YES;
    if (self.emptyLabel.hidden == YES)
    {
        if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"方格显示"])
        {
            // UICollectionView显示
            // 1.修改title 为 T --tableView显示
            [self.navigationItem.leftBarButtonItem setTitle:@"列表显示"];
            // 2.隐藏tableview
            [self.noteTableView setHidden:YES];
            // 3.显示collectionView
            NSLog(@"显示C");
            [self.noteCollectionView setHidden:NO];
            // self.navigationItem.rightBarButtonItem = nil;
            
        }else
        {
            // UITableView
            // 1.修改Title 为C --CollectionView
            [self.navigationItem.leftBarButtonItem setTitle:@"方格显示"];
            // 2.隐藏collectionView
            [self.noteCollectionView setHidden:YES];
            NSLog(@"隐藏C");
            // 3.显示tableView
            [self.noteTableView setHidden:NO];
            // self.navigationItem.rightBarButtonItem = self.addNewNote;
        }

    }
    
    
    /*
    if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"方格显示"])
    {
        // UICollectionView显示
        _choseFlag = 1;
        // 1.修改title 为 T --tableView显示
        [self.navigationItem.leftBarButtonItem setTitle:@"列表显示"];
        // 2.隐藏tableview
        [self.noteTableView setHidden:YES];
        // 3.显示collectionView
        NSLog(@"显示C");
        [self.noteCollectionView setHidden:NO];
        
    }else
    {
        // UITableView
        _choseFlag = 0;
        // 1.修改Title 为C --CollectionView
        [self.navigationItem.leftBarButtonItem setTitle:@"方格显示"];
        // 2.隐藏collectionView
        [self.noteCollectionView setHidden:YES];
        NSLog(@"隐藏C");
        // 3.显示tableView
        [self.noteTableView setHidden:NO];
    }
     */
}

/** 删除collectionCell */
- (void)deleteCell:(id)sender
{
    // NSIndexPath *path = [self.noteCollectionView indexPathForItemAtPoint:[self.deleteCollectionCellGesture locationInView:self.noteCollectionView]];
    NSLog(@"deletacell");
    [HWNoteTool deleteNoteAtIndex:_deleteIndexpath.row];
    [self.noteCollectionView reloadData];
    [self.noteTableView reloadData];
    self.delBtn.hidden = YES;
}

/*
- (void)backToUnDelete:(UIGestureRecognizer *)gr
{
    switch (gr.state)
    {
        case UIGestureRecognizerStateBegan:
            self.delBtn.hidden = YES;
            break;
    }
}
*/

- (void)activateDeletionMode:(UILongPressGestureRecognizer *)gr
{
    // static NSIndexPath *sourceIndexpath = nil;
    
    switch (gr.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            if (_signalDelete == 0)
            {
                NSIndexPath *path = [self.noteCollectionView indexPathForItemAtPoint:[gr locationInView:self.noteCollectionView]];
                HWCollectionViewCell *cell = (HWCollectionViewCell *)[self.noteCollectionView cellForItemAtIndexPath:path];
                _deleteIndexpath = path;
                self.delBtn.hidden = NO;
                // [cell addGestureRecognizer:[[UIGestureRecognizer alloc] initWithTarget:self action:@selector(backToUnDelete:)]];
                [cell addSubview:self.delBtn];
                
                // 抖动动画
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     [self.delBtn bringSubviewToFront:self.noteCollectionView];
                                     NSLog(@"over");
                                 }];
                _signalDelete = 1;

            }else
            {
                self.delBtn.hidden = YES;
                _signalDelete = 0;
            }
            /*
            NSIndexPath *path = [self.noteCollectionView indexPathForItemAtPoint:[gr locationInView:self.noteCollectionView]];
            HWCollectionViewCell *cell = (HWCollectionViewCell *)[self.noteCollectionView cellForItemAtIndexPath:path];
            _deleteIndexpath = path;
            self.delBtn.hidden = NO;
            [cell addGestureRecognizer:[[UIGestureRecognizer alloc] initWithTarget:self action:@selector(backToUnDelete:)]];
            [cell addSubview:self.delBtn];
            
            // 抖动动画
            [UIView animateWithDuration:0.5
                             animations:^{
                [self.delBtn bringSubviewToFront:self.noteCollectionView];
                                 NSLog(@"over");
            }];
            */
        }
        break;
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
    
    // navigationBar 添加选择显示（UICollectionView and UITableView）
    self.elementBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"方格显示" style:UIBarButtonItemStylePlain target:self action:@selector(elementDisplayWay)];

    self.navigationItem.leftBarButtonItem = self.elementBarButtonItem;
    
    // 1.初始化UICollectionView
    // self.noteCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds];
    // 2.设置布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(120, 160);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);// 设置留白
    flowLayout.minimumLineSpacing = 5;// 行 与 行 间距
    flowLayout.minimumInteritemSpacing = 6;// cell 与 cell 间距
    
     
    // collectionView frame
    CGRect cvFrame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height);
    self.noteCollectionView = [[UICollectionView alloc] initWithFrame:cvFrame collectionViewLayout:flowLayout];
    // [self.noteCollectionView setCollectionViewLayout:flowLayout];// 为collectionView设置布局对象
    // 3.设置代理
    self.noteCollectionView.delegate = self;
    self.noteCollectionView.dataSource = self;
    [self.view addSubview:self.noteCollectionView];

    [self.noteCollectionView setHidden:YES];
    [self.noteCollectionView registerClass:[HWCollectionViewCell class] forCellWithReuseIdentifier:@"note"];// 注册cell
    [self.noteCollectionView setBackgroundColor:[UIColor clearColor]];
    
    /*
     * 实现手势长按删除
     */
    self.deleteCollectionCellGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(activateDeletionMode:)];
    self.deleteCollectionCellGesture.delegate = self;
    
    // 1.添加手势
    [self.noteCollectionView addGestureRecognizer:self.deleteCollectionCellGesture];
    // 2.创建删除按钮
    self.delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.delBtn.backgroundColor = [UIColor redColor];
    self.delBtn.frame = CGRectMake(0,0, 20, 20);
    self.delBtn.layer.cornerRadius = 12.0;
    self.delBtn.layer.masksToBounds = YES;
    [self.delBtn setTitle:@"D" forState:UIControlStateNormal];
    [self.delBtn addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    //2.删除状态
    _signalDelete = 0;
    
    
}



@end
