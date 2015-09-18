//
//  IntroduceChessController.m
//  Chess_five
//
//  Created by qianfeng on 15-8-4.
//  Copyright (c) 2015年 yanda. All rights reserved.
//

#import "IntroduceChessController.h"
#import "Ls_SecondViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface IntroduceChessController ()
{
    // 单击按钮
    SystemSoundID _MY_clickSoundId;
}
@end

@implementation IntroduceChessController

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
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"游戏简介";
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 325, 420)];
    imageview.image = [UIImage imageNamed:@"普通模式简介.png"];
    [self.view addSubview:imageview];

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(250, 430, 40, 30);
    button.backgroundColor = [UIColor lightGrayColor];
    UIImage *NormalImage = [UIImage imageNamed:@"按钮.png"];
    [button setBackgroundImage:NormalImage forState:UIControlStateNormal];
    [button setTitle:@"1/3" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 加载音效
    _MY_clickSoundId = [self MY_loadSound:@"点击按钮.aiff"];
    [self.view addSubview:button];

    
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

#pragma mark-------点击事件
-(void)btnClick:(UIButton *)sender
{   AudioServicesPlaySystemSound(_MY_clickSoundId);
    Ls_SecondViewController *ls_second = [[Ls_SecondViewController alloc]init];
    ls_second.ls_labelString = sender.currentTitle;
    
    [self.navigationController pushViewController:ls_second animated:YES];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
