//
//  OnViewController.m
//  wangyimusic_demo
//
//  Created by vic_hyq on 14-10-9.
//  Copyright (c) 2014年 vic. All rights reserved.
//


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "OnViewController.h"

@interface OnViewController ()
{
    UIImageView *recordView;
    CFTimeInterval Otime;
}
@end

@implementation OnViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
           }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    recordView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-100, 200, 200)];
    [recordView setImage:[UIImage imageNamed:@"vago"]];
    [self.view addSubview:recordView];
    
    //控制按钮
    UIButton *go=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 20, 100, 20)];
    [go setTitle:recordView.layer.speed == 1 ? @"pause":@"go"  forState:UIControlStateNormal];
    [go setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [go addTarget:self action:@selector(Control:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:go];
    [self addanima];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAnm) name:@"run_back" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addanima) name:@"run_fore" object:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)removeAnm
{
    [recordView.layer removeAllAnimations];
}
-(void)addanima
{
    recordView.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(0));
    CABasicAnimation * runAnm = [CABasicAnimation animationWithKeyPath:@"transform"];
    //初始值 即0度
    [runAnm setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(0))]];
    //到达值 即180度
    [runAnm setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(M_PI))]];
    //重复次数最大整型
    [runAnm setRepeatCount:NSIntegerMax];
    //下一次动画在本次动画结束的基础上继续运作，即这次转了180度，下次继续再转180度，为什么不一次就转360度呢。
    [runAnm setCumulative:YES];
    //动画执行时间：2秒钟
    [runAnm setDuration:2];
    [recordView.layer addAnimation:runAnm forKey:nil];
}


/**
 *  响应按钮
 *
 *  @param btn
 */
-(void)Control:(id)btn
{
    if (recordView.layer.speed == 1) {
        [self pause];
    }
    else
    {
        [self go];
    }
    [(UIButton *)btn setTitle:recordView.layer.speed == 1 ? @"pause":@"go" forState:UIControlStateNormal];
}

/**
 *  运行
 */
-(void)go
{
    //动画速度设置为1，动画继续按正常速度运行
    recordView.layer.speed=1;
    //将动画位移重置。
    recordView.layer.timeOffset = 0;
    //设置动画的开始时间，绝对时间减去位移，也就是上次停止时的时间，这样动画就继续按照上次的位置状态运行。
    recordView.layer.beginTime = [recordView.layer convertTime:CACurrentMediaTime() fromLayer:recordView.layer] - Otime;
}


/**
 *  暂停
 */
-(void)pause
{
    //获取当前的时间位移，已便将动画停在此处，根据绝对时间和开始时间得到。
    Otime = [recordView.layer convertTime:CACurrentMediaTime() fromLayer:recordView.layer] - recordView.layer.beginTime;
    recordView.layer.timeOffset = Otime ;
    //动画速度设置为0，动画停止
    recordView.layer.speed=0;
}




@end
