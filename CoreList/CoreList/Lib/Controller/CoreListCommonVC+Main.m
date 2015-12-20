//
//  CoreListCommonVC+Main.m
//  CoreList
//
//  Created by 冯成林 on 15/12/6.
//  Copyright © 2015年 muxi. All rights reserved.
//

#import "CoreListCommonVC+Main.h"
#import "MJRefresh.h"
#import "CoreListCommonVC+ScrollView.h"
#import "CoreListCommonVC+BackBtn.h"
#import "CoreListCommonVC+Data.h"


@implementation CoreListCommonVC (Main)

/** 刷新页面数据 */
-(void)refreshData{
    
    if(!self.scrollView.mj_header.isRefreshing){
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissCustomView_EmptyView_ErrorView];
            [self refreshData_Real];
        });
        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.scrollView.mj_header endRefreshing];
            [self dismissCustomView_EmptyView_ErrorView];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self refreshData_Real];
        });
    }
}


-(void)refreshData_Real{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.scrollView.mj_header.isRefreshing) return;
        
        [self dismissBack2TopBtn];
        
        if(!self.shyNavBarOff) [self navBarShow];
        [self.scrollView.mj_footer removeFromSuperview];
        self.scrollView.mj_footer=nil;
        [self.scrollView.mj_header beginRefreshing];
    });
}



/** 默认值填充 */
-(ListVCRefreshAddType)listVC_RefreshType{return ListVCRefreshAddTypeBoth;}
-(BOOL)listVC_NeedBackBtn{return YES;}
-(UIView *)listVC_StatusView_Empty{return nil;}
-(UIView *)listVC_StatusView_Error{return nil;}




@end
