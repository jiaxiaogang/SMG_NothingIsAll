//
//  TOModelVision.m
//  SMG_NothingIsAll
//
//  Created by jia on 2021/5/11.
//  Copyright © 2021年 XiaoGang. All rights reserved.
//

#import "TOModelVision.h"
#import "TOModelBase.h"
#import "PerceptDemandModel.h"
#import "ReasonDemandModel.h"
#import "AIMatchFoModel.h"

@implementation TOModelVision

+(NSString*) cur2Root:(TOModelBase*)curModel{
    //1. 数据准备
    NSMutableString *mStr = [[NSMutableString alloc] init];
    TOModelBase *single = curModel;
    
    //2. 递归取值
    while (single) {
        NSString *singleStr = [self singleVision:single];
        
        //3. 当前/base有效时,插入首部一行;
        if (STRISOK(singleStr)) {
            if (STRISOK(mStr)) [mStr insertString:@"\n   ↑\n" atIndex:0];
            [mStr insertString:singleStr atIndex:0];
        }
        single = single.baseOrGroup;
    }
    
    //4. 头尾
    [mStr insertString:@"\n︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹\n" atIndex:0];
    [mStr appendString:@"\n︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺"];
    return mStr;
}

/**
 *  MARK:--------------------从当前到sub可视化日志--------------------
 *  @desc 用无符号序列表示;
 */
+(NSString*) cur2Sub:(TOModelBase*)curModel{
    //1. 将所有子节点先转成字符串;
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    NSArray *allSubs = [TOUtils getSubOutModels_AllDeep:curModel validStatus:nil];
    for (TOModelBase *item in allSubs) {
        NSString *itemStr = [self singleVision:item];
        [mDic setObject:itemStr forKey:STRFORMAT(@"%p",item)];
    }
    
//    //2. 递归排版
//    while (curmodel.subModels) {
//        //4. 对sub各自显示到下一tab处;
//        if (STRISOK(mStr)) [mStr insertString:@"\n   ↑\n" atIndex:0];
//
//    }
//
//    //4. 头尾
//    [mStr insertString:@"\n︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹︹\n" atIndex:0];
//    [mStr appendString:@"\n︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺︺"];
    return nil;
}

/**
 *  MARK:--------------------单model转str--------------------
 *  @version
 *      2021.06.01: 支持ReasonDemandModel;
 */
+(NSString*) singleVision:(TOModelBase*)model{
    //1. 取content_p
    AIKVPointer *content_p = nil;
    if (ISOK(model, ReasonDemandModel.class)) {
        content_p = ((ReasonDemandModel*)model).mModel.matchFo.pointer;
    }else if(ISOK(model, TOModelBase.class)){
        content_p = model.content_p;
    }
    
    //2. 转成str
    if (content_p) {
        AnalogyType type = DS2ATType(content_p.dataSource);
        return STRFORMAT(@"%@: %@ (%@)",NSStringFromClass(model.class),Pit2FStr(content_p),ATType2Str(type));
    }
    return nil;
}

@end
