//
//  HWCollectionViewCell.m
//  笔记
//
//  Created by lister on 16/2/19.
//  Copyright (c) 2016年 hongwing.com. All rights reserved.
//

#import "HWCollectionViewCell.h"

@interface HWCollectionViewCell()<UIGestureRecognizerDelegate>
/** cell 背景 */
@property (strong, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILongPressGestureRecognizer *LongDeleteGesture;


@end

@implementation HWCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        NSArray *itemArrays = [[NSBundle mainBundle] loadNibNamed:@"HWCollectionViewCell" owner:self options:nil];
        
        if (itemArrays.count < 1)
        {
            return nil;
        }
        
        if (![[itemArrays lastObject] isKindOfClass:[HWCollectionViewCell class]])
        {
            return nil;
        }
        
        self = [itemArrays lastObject];
        self.backImageView.layer.cornerRadius = 14.0;
        self.backImageView.layer.masksToBounds = YES;
        self.backImageView.backgroundColor = [self getRandomColor];
        
    }
    return self;
}

- (UIColor *)getRandomColor
{
    UIColor *color = [UIColor colorWithRed:(arc4random() % 90 + 1 + 10) * 0.01
                                     green:(arc4random() % 90 + 1 + 10) * 0.01
                                      blue:(arc4random() % 90 + 1 + 10) * 0.01
                                     alpha:1];
    return color;
}

- (void)awakeFromNib
{
    // Initialization code
}

@end
