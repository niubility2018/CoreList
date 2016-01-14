//
//  CoreListCommonVC+Refresh.m
//  CoreList
//
//  Created by 冯成林 on 15/12/6.
//  Copyright © 2015年 muxi. All rights reserved.
//

#import "CoreListCommonVC+Refresh.h"
#import "MJRefresh.h"
#import "CoreListCommonVCProtocol.h"
#import "CoreModel.h"
#import "CoreListCommonVC+Data.h"
#import "NSArray+CoreListExtend.h"
#import "CoreStatus.h"

static NSString const *NoMoreDataMsg = @"没有更多数据了";

@implementation CoreListCommonVC (Refresh)

///** 自动触发顶部刷新 */
//-(void)triggerHeaderRefreshing{
//    
//    [self.scrollView.mj_footer endRefreshingWithNoMoreData];
//    
//    [self.scrollView.mj_footer removeFromSuperview];
//    
//    self.scrollView.mj_footer = nil;
//    
//    if(self.scrollView.mj_header == nil) {[self headerRefreshAdd];}
//    
//    [self refreshData];
//}


/** 结束底部刷新 */
-(void)endFooterRefresWithMsg:(NSString *)msg{
    
    [self.scrollView.mj_footer endRefreshingWithNoMoreData];
    
    [(MJRefreshAutoStateFooter *)self.scrollView.mj_footer setTitle:msg forState:MJRefreshStateNoMoreData];
    
    [self removeFooterRefreshControl];
}


/** 顶部刷新 */
-(void)headerRefreshAction{
    
    if(self.scrollView.isDragging) return;
    
    if(![CoreStatus isNETWORKEnable]) {[self.scrollView.mj_header endRefreshing]; return;};
    
//    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self.emptyView removeFromSuperview];
        [self.errorView removeFromSuperview];
  
        [self removeFooterRefreshControl];
        
        if([self listVC_RefreshType] == ListVCRefreshAddTypeNeither) return;
        
        //标明刷新类型
        self.refreshType = ListVCRefreshActionTypeHeader;
        
        //页码复位
        self.page = [[self listVC_Model_Class] CoreModel_StartPage];
        
        //底部刷新控件复位
        [self.scrollView.mj_footer endRefreshing];
        
        //找模型要获取
        [self fetchDataFromModel];
        
        self.isRefreshData=YES;
//    });
}





/** 底部刷新 */
-(void)footerRefreshAction{
    
    if(MJRefreshStateNoMoreData == self.scrollView.mj_footer.state) return;
    
    //标明刷新类型
    self.refreshType = ListVCRefreshActionTypeFooter;
    
    //页码增加
    self.page ++;
    
    //找模型要获取
    [self fetchDataFromModel];
}

/** 刷新成功：顶部 */
-(void)refreshSuccess4Header:(NSArray *)models{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.scrollView.mj_header endRefreshing];
        [self reloadData];
    });
    
    //存入数据
    self.dataList = models;
    

    self.isRefreshData=NO;
    
    if(![self.scrollView isKindOfClass:[UITableView class]]) return;
    if(!self.hasData) return;
    if(models.count==0) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [(UITableView *)self.scrollView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewRowAnimationTop animated:YES];
    });
}


/** 刷新成功：底部 */
-(void)refreshSuccess4Footer:(NSArray *)models sourceType:(CoreModelDataSourceType)sourceType{
    
    NSUInteger count = models.count;
    
    NSUInteger pageSize = self.modelPageSize;
    
    NSArray *indexPaths = [NSArray indexPathsWithStartIndex:self.dataList.count count:count];
    
    //存入数据
    if(self.dataList == nil){//第一次没有数据
        
        //对nil无法发消息
        self.dataList = models;
        
    }else{
        
        self.dataList = [self.dataList appendArray:models];
    }
    
    if(models != nil && indexPaths != nil && self.dataList != nil){
        
        //刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //这里有个崩溃，先这样解决
            if(self.dataList.count <= self.modelPageSize){
                [self reloadData];return ;
            }
            /** 动态刷新 */
            [self reloadData];
            
        });
    }
    
    UIEdgeInsets insets = self.originalScrollInsets;
    
    if(count < pageSize){//新的一页数据不足pagesize
        
        if(CoreModelDataSourceHostType_Sqlite_Nil == sourceType){
            
            //页码需要回退
            self.page -- ;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endFooterRefresWithMsg:NoMoreDataMsg];
        });
        
        if(!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.originalScrollInsets)){insets.bottom=0;}
        
    }else if (count >= pageSize){//有数据，满载
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView.mj_footer endRefreshing];
        });
    }
    
    if(!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.originalScrollInsets)){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.scrollView.contentInset = insets;
        });
    }
}



/** 根据顶部刷新数据情况安装底部刷新控件 */
-(void)footerRefreshAdd:(NSArray *)models{
    
    [self footerRefreshAdd];
    
    NSUInteger count = models.count;
    
    if(count<=5){//不安装
        [self endFooterRefresWithMsg:NoMoreDataMsg];
        
    }else if (count >5 && count < self.modelPageSize){//安装，并将状态置为无数据
        
        [self endFooterRefresWithMsg:NoMoreDataMsg];
        
    }else if (count >= self.modelPageSize){//正常安装
        
        //        [self footerRefreshAdd];
    }
    
    self.hasFooter = YES;
}


/** 安装刷新控件：顶部刷新控件 */
-(void)headerRefreshAdd{
    
    //添加顶部刷新控件
    if(self.scrollView.mj_header == nil) {
        self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
        self.scrollView.mj_header.automaticallyChangeAlpha = YES;
    }
}


/** 安装刷新控件：顶部刷新控件 */
-(void)footerRefreshAdd{
    
    //添加底部刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(self.scrollView.mj_footer == nil) {
            
            MJRefreshFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
        
            self.scrollView.mj_footer = footer;
        }
    });
    
}



-(void)removeHeaderRefreshControl{
   
    [self.scrollView.mj_header endRefreshing];

    [self.scrollView.mj_header removeFromSuperview];
    self.scrollView.mj_header = nil;
}

-(void)removeFooterRefreshControl{
    
    [self.scrollView.mj_footer endRefreshing];
    [self.scrollView.mj_footer removeFromSuperview];
    self.scrollView.mj_footer = nil;
}

@end
