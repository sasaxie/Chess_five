//
//  MainChessController.m
//  Chess_five
//
//  Created by qianfeng on 15-8-4.
//  Copyright (c) 2015年 yanda. All rights reserved.
//

#import "MainChessController.h"
#import "IntroduceChessController.h"
#import "NormalChessController.h"
#import "SpecialChessController.h"
#import "PictureChessController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#define INR 1
#define NOM 2
#define SPE 3
#define PIC 4
#define MIS 5
#define GAP 440
@interface MainChessController ()
{
    AVAudioPlayer *_MY_backmusicplayer;
    
    // 单击按钮
    SystemSoundID _MY_clickSoundId;
    // 音乐控制
    int XXX_musicControl;
}
//定义全局UIImageView
@property(nonatomic ,strong)UIImageView *MY_imageView;
@end

@implementation MainChessController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        XXX_musicControl = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"五子棋";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //创建imageview
    UIImageView *MY_imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 325, 420)];
    MY_imageview.backgroundColor = [UIColor lightGrayColor];
    MY_imageview.image = [UIImage imageNamed:@"首页.png"];
    self.MY_imageView = MY_imageview;
    
    //添加imageview
    [self.view addSubview:self.MY_imageView];
    
    //调用MY_createbutton方法
    [self MY_CreateButton:@"简介" andPostion:CGPointMake(40,GAP) andTag:1];
    [self MY_CreateButton:@"普通" andPostion:CGPointMake(90,GAP) andTag:2];
    [self MY_CreateButton:@"禁手" andPostion:CGPointMake(140,GAP) andTag:3];
    [self MY_CreateButton:@"图片" andPostion:CGPointMake(190,GAP) andTag:4];
    [self MY_CreateButton:@"音乐" andPostion:CGPointMake(240, GAP) andTag:5];
    
            NSString *MY_path = [[NSBundle mainBundle]pathForResource:@"年轮" ofType:@"mp3"];
            //
            NSURL *MY_url = [NSURL fileURLWithPath:MY_path];
            _MY_backmusicplayer = [[AVAudioPlayer alloc]initWithContentsOfURL:MY_url error:nil];
            _MY_backmusicplayer.numberOfLoops = -1;
    
            [_MY_backmusicplayer prepareToPlay];
            [_MY_backmusicplayer play];

    // 加载音效
    _MY_clickSoundId = [self MY_loadSound:@"点击按钮.aiff"];

}

#pragma  mark---创建button的方法
-(void)MY_CreateButton:(NSString *)ButtonName andPostion:(CGPoint)MY_point andTag:(int)MY_tag
{
    //创建button
    UIButton *MY_button = [UIButton buttonWithType:UIButtonTypeCustom];
    //加图片
    UIImage *NormalImage = [UIImage imageNamed:@"按钮.png"];
    [MY_button setBackgroundImage:NormalImage forState:UIControlStateNormal];
     //MY_button.backgroundColor = [UIColor clearColor];
    [MY_button setTitle:ButtonName forState:UIControlStateNormal];
    [MY_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //设置它的位置
    MY_button.frame = CGRectMake(MY_point.x, MY_point.y, 40, 30);
    //给每一个tag赋值
    MY_button.tag = MY_tag;
    [MY_button addTarget:self action:@selector(MY_btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:MY_button];
}


#pragma mark----加载音效文件
- (SystemSoundID)MY_loadSound:(NSString *)MY_soundName
{
    
    NSURL *MY_url = [[NSBundle mainBundle]URLForResource:MY_soundName withExtension:nil];
    //创建一个声音id
    SystemSoundID MY_soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(MY_url), &MY_soundId);
    
    return MY_soundId;
    
}



#pragma mark----点击事件方法
-(void)MY_btnClick:(UIButton *)sender
{
    AudioServicesPlaySystemSound(_MY_clickSoundId);
    if (sender.tag == INR)
    {
        IntroduceChessController *MY_introduce = [[IntroduceChessController alloc]init];
        [self.navigationController pushViewController:MY_introduce animated:YES];

    }
    if (sender.tag == NOM) {
        NormalChessController *MY_normal = [[NormalChessController alloc]init];
        [self.navigationController pushViewController:MY_normal animated:YES];
    }
    if (sender.tag == SPE) {
        SpecialChessController *MY_special = [[SpecialChessController alloc]init];
        [self.navigationController pushViewController:MY_special animated:YES];
    }
    if (sender.tag == PIC) {
        PictureChessController *MY_picture = [[PictureChessController alloc]init];
        [self.navigationController pushViewController:MY_picture animated:YES];
    }
    if (sender.tag == MIS) {
        //
//        NSString *MY_path = [[NSBundle mainBundle]pathForResource:@"背景音乐" ofType:@"caf"];
//        //
//        NSURL *MY_url = [NSURL fileURLWithPath:MY_path];
//        _MY_backmusicplayer = [[AVAudioPlayer alloc]initWithContentsOfURL:MY_url error:nil];
//        _MY_backmusicplayer.numberOfLoops = -1;
//        
//        [_MY_backmusicplayer prepareToPlay];
        if (0 == XXX_musicControl)
        {
            [_MY_backmusicplayer stop];
            XXX_musicControl = 1;
            UIButton *tempButtonMusic = (UIButton *)[self.view viewWithTag:sender.tag];
            [tempButtonMusic setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        else
        {
            [_MY_backmusicplayer play];
            XXX_musicControl = 0;
            UIButton *tempButtonMusic = (UIButton *)[self.view viewWithTag:sender.tag];
            [tempButtonMusic setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
