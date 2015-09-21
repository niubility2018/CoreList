//
//  ViewControllerListProtocol.h
//  CoreList
//
//  Created by 成林 on 15/6/5.
//  Copyright (c) 2015年 muxi. All rights reserved.
//
#import "CoreListType.h"

@protocol ViewControllerListProtocol <NSObject>





-(void)showTipsWithTitle:(NSString *)title desc:(NSString *)desc offsetY:(CGFloat)offsetY clickBlock:(void(^)())clickBlock;

-(void)dismissTipsView;

/** 刷新页面数据 */
-(void)refreshData;







@required

/** 协议方法区 */


/** 刷新方式 */
-(ListVCRefreshAddType)listVC_RefreshType;


/** 模型类 */
-(Class)listVC_Model_Class;


/** 视图类 */
-(Class)listVC_View_Cell_Class;


/** 请求参数 */
-(NSDictionary *)listVC_Request_Params;


/** 忽略参数 */
-(NSArray *)listVC_Ignore_Params;


/** 是否移除回到顶部按钮 */
-(BOOL)listVC_Remove_Back2Top_Button;




/** tableViewController */
/** cell的行高：tableViewController专用 */
-(CGFloat)listVC_CellH4IndexPath:(NSIndexPath *)indexPath;






@optional

/** 无本地FMDB缓存的情况下，需要在ViewDidAppear中定期自动触发顶部刷新事件 */
-(NSString *)listVC_Update_Delay_Key;

/** 是否关闭返回顶部功能 */
-(BOOL)removeBack2TopBtn;


/** 数据方法区 */

/** 刷新数据 */
-(void)reloadData;



/** tableView专有方法*/
/** 动态刷新 */
-(void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;



/** collectionView专有方法 */
-(UICollectionViewLayout *)listVC_CollectionViewLayout;

@end