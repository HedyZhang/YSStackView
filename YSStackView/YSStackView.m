//
//  YSStackView.m
//  YSStackView
//
//  Created by yanshu on 15/11/10.
//  Copyright © 2015年 焱厽. All rights reserved.
//

#import "YSStackView.h"
static NSString *const MemberCollectionViewCellIdentifier = @"MemberCollectionViewCell";

@interface MemberCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIButton *tipButton;
@property (nonatomic, strong) UIImageView *memberImageView;
@end

@implementation MemberCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
  
        self.memberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 20)];
        [self addSubview:_memberImageView];
        
        self.tipButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        CGPoint tipButtonCenter = CGPointMake(_memberImageView.frame.origin.x + _memberImageView.frame.size.width, _memberImageView.frame.origin.y);
        _tipButton.center = tipButtonCenter;
        [self addSubview:_tipButton];
      
        
    }
    return self;
}

- (void)setTipButtonBackgroudImage:(UIImage *)backgroudImage
{
    [self.tipButton setBackgroundImage:backgroudImage forState:UIControlStateNormal];
}

@end

#pragma mark -------------StackView------------
#define kInterItemSpace 0
#define kTagBase 1000
@interface YSStackView ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    CGSize _itemSize;
  
}
@property(strong, nonatomic) NSMutableArray *datas;
@end


@implementation YSStackView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat itemWidth = frame.size.height > 80 ? 80 : frame.size.height;
    _itemSize = CGSizeMake(itemWidth, itemWidth );
    self = [super initWithFrame:frame collectionViewLayout:[self flowLayout]];
    if (self)
    {
        self.backgroundColor       = [UIColor whiteColor];
        self.isAllowedDeleteMember = YES;
        self.dataSource            = self;
        self.delegate              = self;
        [self registerClass:[MemberCollectionViewCell class] forCellWithReuseIdentifier:MemberCollectionViewCellIdentifier];
        
        self.datas                 = [NSMutableArray arrayWithCapacity:0];
        
       
    }
    return self;
}

- (void)setAddImage:(UIImage *)addImage
{
    _addImage = addImage;
    [self.datas addObject:addImage];
    [self reloadData];
}

- (UICollectionViewFlowLayout *)flowLayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = _itemSize;
    flowLayout.minimumInteritemSpacing = kInterItemSpace;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return flowLayout;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_limit)
    {
      return  _datas.count > _limit ? _limit : _datas.count;
    }
    return _datas.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MemberCollectionViewCellIdentifier forIndexPath:indexPath];
     UIImage *image = [self.datas objectAtIndex:indexPath.row];
    cell.memberImageView.image = image;
    cell.memberImageView.tag = indexPath.row + kTagBase;
    cell.tipButton.tag = indexPath.row + kTagBase;
    [cell.tipButton addTarget:self action:@selector(deleteMember:) forControlEvents:UIControlEventTouchUpInside];
    [cell.tipButton setBackgroundImage:self.deleteTipImage forState:UIControlStateNormal];
    if (_isAllowedDeleteMember)
    {
        if ((cell.tipButton.tag - kTagBase)  == _datas.count - 1 )
        {
            cell.tipButton.hidden = YES;
        }
        else
        {
            cell.tipButton.hidden = NO;
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MemberCollectionViewCell *cell = (MemberCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (_limit)
    {
        if (((cell.memberImageView.tag - kTagBase) == self.datas.count - 1) && ((_datas.count - 1) <= _limit))
        {
            if (_stackViewDelegate && [_stackViewDelegate respondsToSelector:@selector(addImageClicked)]) {
                [_stackViewDelegate addImageClicked];
            }
        }
    }
    else
    {
        if (((cell.memberImageView.tag - kTagBase) == self.datas.count - 1))
        {
            if (_stackViewDelegate && [_stackViewDelegate respondsToSelector:@selector(addImageClicked)]) {
                [_stackViewDelegate addImageClicked];
            }
        }
    }
}
- (void)deleteMember:(UIButton *)sender
{
    [self.datas removeObjectAtIndex:sender.tag - kTagBase];
    [self reloadData];
}


- (void)addMember:(__kindof UIImage *)member
{
    [self.datas insertObject:member atIndex:[_datas count] - 1];
    [self reloadData];
}

- (NSArray *)getAllMember
{
    NSRange availableRange = NSMakeRange(0, _datas.count - 1);
    NSArray *availableSources = [NSArray arrayWithArray:[_datas subarrayWithRange:availableRange]];
    return availableSources;
}
@end
