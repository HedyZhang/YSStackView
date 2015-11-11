//
//  YSStackView.h
//  YSStackView
//
//  Created by yanshu on 15/11/10.
//  Copyright © 2015年 焱厽. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YSStackViewDelegate <NSObject>


- (void)addImageClicked;

@end


@interface YSStackView : UICollectionView

@property (nonatomic, strong) UIImage *addImage; //the add image

@property (nonatomic, strong) UIImage *deleteTipImage;

@property (nonatomic, assign) CGFloat limit;

/**
 *  showDeleteTip
 */
@property(nonatomic, assign) BOOL showDeleteTip;

/**
 *  isAllowedDeleteMember
 */
@property(nonatomic, assign) BOOL isAllowedDeleteMember;


/**
 *  call back
 */
@property(weak, nonatomic) id<YSStackViewDelegate> stackViewDelegate;


- (void)addMember:(__kindof UIImage *)member;

- (NSArray *)getAllMember;

@end
