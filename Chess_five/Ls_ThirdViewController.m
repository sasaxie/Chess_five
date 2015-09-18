//
//  Ls_ThirdViewController.m
//  IntroduceChess
//
//  Created by qianfeng on 15-8-5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "Ls_ThirdViewController.h"

@interface Ls_ThirdViewController ()

@end

@implementation Ls_ThirdViewController

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
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 325, 420)];
    imageview.image = [UIImage imageNamed:@"图片模式简介.png"];
    [self.view addSubview:imageview];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(100, 30,400, 40)];
    title.text = @"游戏简介";
    title.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:30];
    
    title.textColor = [UIColor blackColor];
    [self.view addSubview:title];
    
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(250, 430, 40, 30);
    button2.backgroundColor = [UIColor lightGrayColor];
    UIImage *NormalImage = [UIImage imageNamed:@"按钮.png"];
    [button2 setBackgroundImage:NormalImage forState:UIControlStateNormal];
    [button2 setTitle:@"3/3" forState:UIControlStateNormal];
    
    [self.view addSubview:button2];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
