//
//  CoreListCommonVC+BackBtn.m
//  CoreList
//
//  Created by 冯成林 on 15/12/6.
//  Copyright © 2015年 muxi. All rights reserved.
//

#import "CoreListCommonVC+BackBtn.h"
#import "CoreListCommonVC+ScrollView.h"

@implementation CoreListCommonVC (BackBtn)


-(void)backBtnPrepare{

    if(![self listVCNeedBackBtn]) return;

    [self scrollViewPrepare];
}


/** 展示返回顶部按钮 */
-(void)showBack2TopBtn{
    
    [self animWithParam:1];
}


/** 隐藏返回顶部按钮 */
-(void)dismissBack2TopBtn{
    
    [self animWithParam:0];
}


/** 动画参数化 */
-(void)animWithParam:(CGFloat)alpha{
    
    if(self.back2TopView.alpha == alpha) return;
    
    [UIView animateWithDuration:.25f animations:^{
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        self.back2TopView.alpha = alpha;
    }];
}





/** 返回顶部 */
-(void)back2Top{
    
    if (self.dataList.count == 0) return;
    if (!self.hasData) return;
    
    if([self.scrollView isKindOfClass:[UITableView class]]){//tableView
        
        UITableView *tableView = (UITableView *)self.scrollView;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }else{
        
        UICollectionView *collectionView = (UICollectionView *)self.scrollView;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animWithParam:0];
    });
}
@end
