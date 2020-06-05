//
//  AIThinkOutAction.m
//  SMG_NothingIsAll
//
//  Created by jia on 2020/5/20.
//  Copyright © 2020年 XiaoGang. All rights reserved.
//

#import "AIThinkOutAction.h"
#import "AIAbsAlgNode.h"
#import "ThinkingUtils.h"
#import "AINetUtils.h"
#import "AINetService.h"
#import "ShortMatchManager.h"
#import "AIShortMatchModel.h"
#import "TOFoModel.h"
#import "TOAlgModel.h"
#import "TOValueModel.h"
#import "TOUtils.h"

@implementation AIThinkOutAction

/**
 *  MARK:--------------------SP行为化--------------------
 *  @desc 参考:MC_V3;
 *  @desc 工作模式:
 *      1. 将S加工成P;
 *      2. 满足P;
 *  _param complete : 必然执行,且仅执行一次;
 *  @version
 *      2020-05-22: 调用cHav,在原先solo与group的基础上,新增了最优先的checkAlg (因为solo和group可能压根不存在此概念,而TO是主应用,而非构建的);
 *      2020-06-03: 支持将cGLDic缓存至TOAlgModel,以便一条GL子任务完成时,顺利转移至下一GL子任务;
 *  @TODO_TEST_HERE:
 *      1. 测试时,在_GL时,可将pAlg换成checkAlg试试,因为pAlg本来就是反向类比后的fo,可能没有再进行内类比的机会,所以无_GL经验;
 *  @todo
 *      1. 收集_GL向抽象和具象延伸,而尽量避免到_Hav,尤其要避免重组,无论是group还是solo (参考n19p18-todo4);
 *      2. 将group和solo重组的方式废弃掉,参考:n19p18-todo5
 *      3. 替代group和solo的方法为: 用outModel.checkAlg找同层节点进行_Hav,并判断其符合GLDic中的稀疏码同区,且与GL的innerType相同,同大或同小;
 */
-(void) convert2Out_SP:(AIKVPointer*)sAlg_p pAlg_p:(AIKVPointer*)pAlg_p outModel:(TOAlgModel*)outModel {
    //1. 结果数据准备
    AIAlgNodeBase *sAlg = [SMGUtils searchNode:sAlg_p];
    AIAlgNodeBase *pAlg = [SMGUtils searchNode:pAlg_p];
    if (!pAlg) {
        outModel.status = TOModelStatus_ActNo;
        [self.delegate toAction_SubModelFailure:outModel];
        return;
    }
    NSLog(@"STEPKEY==========================SP START==========================\nSTEPKEYS:%@\nSTEPKEYP:%@",Alg2FStr(sAlg),Alg2FStr(pAlg));
    
    //2. 满足P: GL部分;
    NSDictionary *cGLDic = [SMGUtils filterPointers:sAlg.content_ps b_ps:pAlg.content_ps checkItemValid:^BOOL(AIKVPointer *a_p, AIKVPointer *b_p) {
        return [a_p.identifier isEqualToString:b_p.identifier];
    }];
    
    //3. 将cGLDic & pAlg保留到短时记忆;
    [outModel.cGLDic setDictionary:cGLDic];
    outModel.pAlg = pAlg;
    
    //3. 满足P: cHav部分;
    NSArray *cHavArr = [SMGUtils removeSub_ps:cGLDic.allValues parent_ps:pAlg.content_ps];
    
    //4. GL行为化 (仅对第一条行为化,其后都由流程控制方法来控制推动);
    for (NSData *key in cGLDic.allKeys) {
        //a. 数据准备;
        AIKVPointer *sValue_p = DATA2OBJ(key);
        AIKVPointer *pValue_p = [cGLDic objectForKey:key];
        TOValueModel *valueOutModel = [TOValueModel newWithSValue:sValue_p pValue:pValue_p group:outModel];
        //b. 行为化
        NSLog(@"------SP_GL行为化:%@ -> %@",[NVHeUtil getLightStr:sValue_p],[NVHeUtil getLightStr:pValue_p]);
        [self convert2Out_GL:pAlg outModel:valueOutModel];
        break;
    }
    
    //5. H行为化;
    for (AIKVPointer *pValue_p in cHavArr) {
        //b. 将pValue_p独立找到概念,并找cHav;
        AIAbsAlgNode *soloAlg = [theNet createAbsAlg_NoRepeat:@[pValue_p] conAlgs:nil isMem:false];
        TOAlgModel *soloOutModel = [TOAlgModel newWithAlg_p:soloAlg.pointer group:outModel];
        [self convert2Out_Hav:soloOutModel];
        if (soloOutModel.status == TOModelStatus_ActNo || soloOutModel.status == TOModelStatus_ScoreNo) {
            continue;
        }
        
        //c. 将pValue_p+same_ps重组找到概念,并找cHav;
        AIAlgNodeBase *checkAlg = [SMGUtils searchNode:outModel.content_p];
        NSMutableArray *group_ps = [SMGUtils removeSub_ps:pAlg.content_ps parent_ps:checkAlg.content_ps];
        [group_ps addObject:pValue_p];
        AIAbsAlgNode *groupAlg = [theNet createAbsAlg_NoRepeat:group_ps conAlgs:nil isMem:false];
        TOAlgModel *groupOutModel = [TOAlgModel newWithAlg_p:groupAlg.pointer group:outModel];
        [self convert2Out_Hav:groupOutModel];
        if (groupOutModel.status == TOModelStatus_ActNo || groupOutModel.status == TOModelStatus_ScoreNo) {
            continue;
        }
        
        //c. solo和group方式都未成功,则: 一条稀疏码行为化失败,则直接返回失败;
        outModel.status = TOModelStatus_ActNo;
        [self.delegate toAction_SubModelFailure:outModel];
        return;
    }
}

/**
 *  MARK:--------------------P行为化--------------------
 *  _param curAlg_p : 来源: TOR.R-;
 */
-(void) convert2Out_P:(TOAlgModel*)outModel{
    [self convert2Out_Hav:outModel];
}


//MARK:===============================================================
//MARK:                     < Fo >
//MARK:===============================================================
/**
 *  MARK:--------------------对一个rangeOrder进行行为化;--------------------
 *  @desc 一些记录:
 *      1. 191105总结下,此处有多少处,使用短时,长时,在前面插入瞬时;
 *      2. 191105针对概念嵌套的代码,先去掉;
 *      3. 191107考虑将foScheme也搬过来,优先使用matchFo做第一解决方案;
 *  @TODO_TEST_HERE: 测试下阈值-3,是否合理;
 */
-(void) convert2Out_Fo:(NSArray*)curAlg_ps outModel:(TOFoModel*)outModel{
    //1. 数据准备
    AIFoNodeBase *curFo = [SMGUtils searchNode:outModel.content_p];
    NSLog(@"STEPKEY============================== 行为化 START ==================== \nSTEPKEY时序:%@->%@\nSTEPKEY需要:[%@]",Fo2FStr(curFo),Mvp2Str(curFo.cmvNode_p),Pits2FStr(curAlg_ps));
    if (!ARRISOK(curAlg_ps) || curFo == nil || ![self.delegate toAction_EnergyValid]) {
        outModel.status = TOModelStatus_ActNo;
        [self.delegate toAction_SubModelFailure:outModel];
        return;
    }
    
    //2. 反思评价
    BOOL scoreSuccess = [TOUtils toAction_RethinkScore:outModel rtBlock:^AIShortMatchModel *{
        return [self.delegate toAction_RethinkInnerFo:curFo];
    }];
    if (!scoreSuccess) {
        outModel.status = TOModelStatus_ScoreNo;
        [self.delegate toAction_SubModelFailure:outModel];
        return;
    }

    //3. 触发,首个概念行为化;
    for (AIKVPointer *curAlg_p in curAlg_ps) {
        TOAlgModel *algOutModel = [TOAlgModel newWithAlg_p:curAlg_p group:outModel];
        [self convert2Out_Hav:algOutModel];
        return;
    }
}

//MARK:===============================================================
//MARK:                     < H/G/L >
//MARK:===============================================================

/**
 *  MARK:--------------------单个概念的行为化--------------------
 *  第1级: 直接判定curAlg_p为输出则收集;
 *  第2级: MC匹配行为化
 *  第3级: LongNet长短时网络行为化
 *  _param curAlg_p : 三个来源: 1.Fo的元素A;  2.Range的元素A; 3.Alg的嵌套A;
 *  @version
 *      2020-05-22 : 支持更发散的联想(要求matchAlg和hAlg同被引用),因每次递归都要这么联想,所以从TOP搬到这来 (由19152改成19192);
 *      2020-05-27 : 支持outModel (目前cHav方法,收集所有acts,一次性返回行为,而并未进行多轮外循环,所以此处不必做subOutModel);
 */
-(void) convert2Out_Hav:(TOAlgModel*)outModel {
    //1. 数据准备 (空白无需行为化);
    if (!outModel.content_p) {
        outModel.status = TOModelStatus_Finish;
        [self.delegate toAction_SubModelFinish:outModel];
        return;
    }
    
    //2. 本身即是isOut时,直接行为化返回;
    if (outModel.content_p.isOut) {
        outModel.status = TOModelStatus_ActYes;
        [self.delegate toAction_updateEnergy:-0.1f];
        [self.delegate toAction_Output:@[outModel.content_p]];
        NSLog(@"-> SP_Hav_isOut为TRUE: %@",AlgP2FStr(outModel.content_p));
        return;
    }else{
        //3. 数据检查curAlg
        AIAlgNodeBase *curAlg = [SMGUtils searchNode:outModel.content_p];
        if (!curAlg) {
            outModel.status = TOModelStatus_ActNo;
            [self.delegate toAction_SubModelFailure:outModel];
            return;
        }
        
        //4. 数据检查hAlg_根据type和value_p找ATHav
        AIAlgNodeBase *hAlg = [AINetService getInnerAlg:curAlg vAT:outModel.content_p.algsType vDS:outModel.content_p.dataSource type:ATHav];
        if (!hAlg) {
            outModel.status = TOModelStatus_ActNo;
            [self.delegate toAction_SubModelFailure:outModel];
            return;
        }
        
        //5. 取hAlg的refs引用时序大全;
        NSArray *hRef_ps = [SMGUtils convertPointersFromPorts:[AINetUtils refPorts_All4Alg:hAlg]];
        for (AIShortMatchModel *model in theTC.inModelManager.models) {
            //6. 遍历入短时记忆,根据matchAlg取refs;
            NSArray *mRef_ps = [SMGUtils convertPointersFromPorts:[AINetUtils refPorts_All4Alg:model.matchAlg]];
            
            //7. 对hRefs和mRefs取交集;
            NSArray *hmRef_ps = [SMGUtils filterSame_ps:hRef_ps parent_ps:mRef_ps];
            hmRef_ps = ARR_SUB(hmRef_ps, 0, cHavNoneAssFoCount);
            
            //7. 去掉不应期
            NSArray *except_ps = [TOUtils convertPointersFromTOModels:outModel.actionFoModels];
            hmRef_ps = [SMGUtils removeSub_ps:except_ps parent_ps:hmRef_ps];
            
            //8. 只要有善可尝试的方式,即从首条开始尝试;
            if (ARRISOK(hmRef_ps)) {
                [self convert2Out_RelativeFo_ps:hmRef_ps outModel:outModel];
                return;
            }
            //9. 可尝试的方案全无,则循环至下个mModel试一下;
        }
    }
    
    //10. 所有mModel都没成功行为化一条,则失败;
    outModel.status = TOModelStatus_ActNo;
    [self.delegate toAction_SubModelFailure:outModel];
}

/**
 *  MARK:--------------------对单稀疏码的变化进行行为化--------------------
 *  @desc 伪代码:
 *  1. 根据type和value_p找ATLess/ATGreater
 *      2. 找不到,failure;
 *      3. 找到,判断range是否导致条件C转移;
 *          4. 未转移: success
 *          5. 转移: C条件->递归到convert2Out_Single_Alg();
 *  _param vAT & vDS : 用作查找"大/小"的标识;
 *  @param alg : GL的微信息所处的概念, (所有微信息变化不应脱离概念,比如鸡蛋可以通过烧成固态,但水不能,所以变成固态这种特征变化,不应脱离概念去操作);
 */
-(void) convert2Out_GL:(AIAlgNodeBase*)alg outModel:(TOValueModel*)outModel {
    //1. 数据准备
    AnalogyType type = [ThinkingUtils compare:outModel.curValue_p valueB_p:outModel.content_p];
    NSString *vAT = outModel.content_p.algsType;
    NSString *vDS = outModel.content_p.dataSource;
    if ((type != ATGreater && type != ATLess)) {
        WLog(@"value_行为化类参数type|value_p错误");
        //相等不必行为化,直接返回true;
        outModel.status = TOModelStatus_Finish;
        [self.delegate toAction_SubModelFinish:outModel];
        return;
    }
    
    //2. 根据type和value_p找ATLess/ATGreater
    AIAlgNodeBase *glAlg = [AINetService getInnerAlg:alg vAT:vAT vDS:vDS type:type];
    if (!glAlg) {
        outModel.status = TOModelStatus_ActNo;
        [self.delegate toAction_SubModelFailure:outModel];
        return;
    }
    
    //3. 根据havAlg联想时序,并找出新的解决方案,与新的行为化的概念,与新的条件概念;
    NSArray *hdRef_ps = [SMGUtils convertPointersFromPorts:ARR_SUB(glAlg.refPorts, 0, cHavNoneAssFoCount)];
    
    //4. 去掉不应期
    NSArray *except_ps = [TOUtils convertPointersFromTOModels:outModel.actionFoModels];
    hdRef_ps = [SMGUtils removeSub_ps:except_ps parent_ps:hdRef_ps];
    
    //5. 转移至_fos
    if (ARRISOK(hdRef_ps)) {
        [self convert2Out_RelativeFo_ps:hdRef_ps outModel:outModel];
    }else{
        //6. 无计可施
        outModel.status = TOModelStatus_ActNo;
        [self.delegate toAction_SubModelFailure:outModel];
    }
}

//MARK:===============================================================
//MARK:                     < Relativen Fos >
//MARK:===============================================================

/**
 *  MARK:--------------------"相对时序"的行为化--------------------
 *  @param relativeFo_ps    : 相对时序地址;
 *  _param success          : 回调传回: 相对时序 & 行为化结果;
 *  _param failure          : 只要有一条行为化成功则success(),否则failure();
 *  注:
 *      1. 参数: 由方法调用者保证传入的是"相对时序"而不是普通时序
 *      2. 流程: 取出相对时序,并取rangeOrder,行为化并返回
 */
-(void) convert2Out_RelativeFo_ps:(NSArray*)relativeFo_ps outModel:(TOModelBase<ITryActionFoDelegate>*)outModel {
    //1. 数据准备
    relativeFo_ps = ARRTOOK(relativeFo_ps);
    
    //2. 逐个尝试行为化
    NSLog(@"----> RelativeFo_ps Start 目标:%@",[NVHeUtil getLightStr4Ps:relativeFo_ps]);
    for (AIPointer *relativeFo_p in relativeFo_ps) {
        AIFoNodeBase *relativeFo = [SMGUtils searchNode:relativeFo_p];
        
        //3. 取出havFo除第一个和最后一个之外的中间rangeOrder
        NSLog(@"---> RelativeFo Item 内容:%@",[NVHeUtil getLightStr4Ps:relativeFo.content_ps]);
        if (relativeFo != nil && relativeFo.content_ps.count >= 1) {
            NSArray *foRangeOrder = ARR_SUB(relativeFo.content_ps, 0, relativeFo.content_ps.count - 1);
            
            //5. 转移,则进行行为化 (递归到总方法);
            if (ARRISOK(foRangeOrder)) {
                TOFoModel *foOutModel = [TOFoModel newWithFo_p:relativeFo.pointer base:outModel];
                [self convert2Out_Fo:foRangeOrder outModel:foOutModel];
                return;
            }
        }
    }
    //7. 没一个成功 或 行为化成功 或 等待行为化,则失败;
    outModel.status = TOModelStatus_ActNo;
    [self.delegate toAction_SubModelFailure:outModel];
}

@end
