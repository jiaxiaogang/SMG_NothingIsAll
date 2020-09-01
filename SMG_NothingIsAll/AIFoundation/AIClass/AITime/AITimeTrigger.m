//
//  AITime.m
//  SMG_NothingIsAll
//
//  Created by 贾  on 2017/9/17.
//  Copyright © 2017年 XiaoGang. All rights reserved.
//

#import "AITimeTrigger.h"
#import "TOModelBase.h"

//@interface AITimeTrigger ()
//@property (strong,nonatomic) NSTimer *timer;            //计时器
//@end

@implementation AITimeTrigger

//-(id) init{
//    self = [super init];
//    if (self) {
//        [self initData];
//    }
//    return self;
//}
//
//-(void) initData{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(notificationTimer) userInfo:nil repeats:YES];
//}
//
////MARK:===============================================================
////MARK:                     < privateMethod >
////MARK:===============================================================
//- (void)notificationTimer{
//    NSLog(@"AITime触发器触发");
//}

/**
 *  MARK:--------------------生物钟触发器--------------------
 *  @callers
 *      1. demand.ActYes处 (等待外循环mv抵消);
 *      2. 行为化Hav().HNGL.ActYes处 (等待外循环输入符合HNGL的概念)
 *      3. 行为输出ActYes处 (等待外循环输入推进下一帧概念)
 *  @version
 *      2020.08.14: 支持生物钟触发器;
 *          1. timer计时器触发,取deltaT x 1.3时间;
 *          2. "计时触发"时,对触发者的ActYes状态进行判断,如果还未由外循环实际输入,则"实际触发";
 *          3. 实际触发后,对预想时序fo 与 实际时序fo 进行反省类比;
 *          x. 当outModel中某时序完成时,则追回(销毁)与其对应的触发器 (废弃,不用销毁,改变status状态即可);
 *          x. 直到触发时,还未销毁,则说明实际时序并未完成,此时调用反省类比 (废弃,由commitFromOuterPushMiddleLoop()来做状态改变即可);
 *  @param canTrigger : 触发条件;
 */
+(void) setTimeTrigger:(NSTimeInterval)deltaTime canTrigger:(BOOL(^)())canTrigger trigger:(void(^)())trigger{
    //1. 数据检查
    if (!canTrigger || !trigger) return;
    
    //2. 用after延迟定时deltaT x 1.3触发;
    CGFloat triggerTime = deltaTime / 1000.0f * 1.3f;
    NSLog(@"---> 生物钟触发器: %f",triggerTime);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(triggerTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //3. 触发时,判断是否还是actYes状态 (在OuterPushMiddleLoop()中,会将ActYes且符合,且PM算法成功的,改为Finish);
        if (canTrigger()) trigger();
    });
}

@end
