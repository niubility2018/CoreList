//
//  BaseCollectionViewCell.m
//  CoreList
//
//  Created by 成林 on 15/6/7.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreListCollectionViewCell.h"
#import "NSObject+CoreModelCommon.h"

NSString * _CollectionViewCellRid;

@implementation CoreListCollectionViewCell

/** 为指定的collectionView从Nib注册cell */
+(void)registerNibForCollectionView:(UICollectionView *)collectionView;{

    [collectionView registerNib:[UINib nibWithNibName:[self CollectionViewCellRid] bundle:nil] forCellWithReuseIdentifier:[self CollectionViewCellRid]];
}



/** 取出利用cell */
+(instancetype)dequeueReusableCellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath*)indexPath{
    
    
    
    CoreListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self CollectionViewCellRid] forIndexPath:indexPath];
    
    return cell;
}

-(void)setModel:(CoreModel *)model{
    
    _model = model;
    
    [self dataFill:model];
}





+(NSString *)CollectionViewCellRid{

    return [self modelName];
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}

@end
