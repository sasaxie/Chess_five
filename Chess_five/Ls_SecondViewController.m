//
//  Ls_SecondViewController.m
//  IntroduceChess
//
//  Created by qianfeng on 15-8-5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "Ls_SecondViewController.h"
#import "Ls_ThirdViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface Ls_SecondViewController ()
{
    // 单击按钮
    SystemSoundID _MY_clickSoundId;
}
@end

@implementation Ls_SecondViewController

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
    //self.navigationItem.title = @"游戏简介";

    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 325, 420)];
    imageview.image = [UIImage imageNamed:@"禁手模式简介.png"];
    [self.view addSubview:imageview];
       UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(250, 430, 40, 30);
    button1.backgroundColor = [UIColor lightGrayColor];
    UIImage *NormalImage = [UIImage imageNamed:@"按钮.png"];
    [button1 setBackgroundImage:NormalImage forState:UIControlStateNormal];
    [button1 setTitle:@"2/3" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
    // 加载音效
    _MY_clickSoundId = [self MY_loadSound:@"点击按钮.aiff"];
    [self.view addSubview:button1];
    


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
#pragma mark-----点击事件
-(void)btnClick1:(UIButton *)sender
{
    AudioServicesPlaySystemSound(_MY_clickSoundId);
    Ls_ThirdViewController *ls_third = [[Ls_ThirdViewController alloc]init];
    
    ls_third.labelString1 = sender.currentTitle;
    
    [self.navigationController pushViewController:ls_third animated:YES];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
