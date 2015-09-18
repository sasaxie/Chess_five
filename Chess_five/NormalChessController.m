//
//  NormalChessController.m
//  Chess_five
//
//  Created by qianfeng on 15-8-4.
//  Copyright (c) 2015年 yanda. All rights reserved.
//

#import "NormalChessController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface NormalChessController ()
{
    //下的棋子的个数
    NSInteger LTB_localCount;
    
    //记录每一个button的tag
    NSInteger LTB_localTag;
    
    //
    UIButton *LTB_blackButton;
    UIButton *LTB_whiteButton;
    
    //控制下棋者 为黑棋还是白棋
    NSInteger LTB_flag;
    
    //整个棋盘的棋子的分布
    int LTB_chessArray[10][10];
    
    //点击按钮
    SystemSoundID _clickSoundId;
    SystemSoundID _clickSoundIdx;
    // 胜利
    SystemSoundID _successedSoundId;
    
    //label  在棋盘底部显示该谁下了
    UILabel *LTB_whoChess;
    
    //屏幕底端
    UIButton *LTB_black;
    UIButton *LTB_white;
    UIButton *LTB_restart;
}

@end

@implementation NormalChessController

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
    self.navigationItem.title = @"普通模式";
    self.view.backgroundColor = [UIColor lightGrayColor];
    //创建一个view
    UIView *LTB_chessView= [[UIView alloc]initWithFrame:CGRectMake(10, (460-300)/2+45, 300, 300)];
    LTB_chessView.backgroundColor = [UIColor blackColor];
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 65, 320, 420)];
    [bgview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.png"]]];
    [self.view addSubview:bgview];
    
    //
    //显示该谁下的label
    //对该label初始化
    LTB_whoChess = [[UILabel alloc]initWithFrame:CGRectMake(100, 108, 150,15)];
    //LTB_whoChess.backgroundColor = [UIColor grayColor];
    [LTB_whoChess setTextColor:[UIColor blackColor]];
    LTB_whoChess.font = [UIFont systemFontOfSize:15];
    [LTB_whoChess setTextAlignment:NSTextAlignmentCenter];
    [LTB_whoChess setText:@"接下来黑方下子！"];
    [self.view addSubview:LTB_whoChess];
    
    
    
    LTB_black = [UIButton buttonWithType:UIButtonTypeCustom];
    LTB_black.frame = CGRectMake(20, 430, 70, 40);
    [self.view addSubview:LTB_black];
    UIImage *normalImage = [UIImage imageNamed:@"p1.png"];
    [LTB_black setBackgroundImage:normalImage forState:UIControlStateNormal];
    
    LTB_white = [UIButton buttonWithType:UIButtonTypeCustom];
    LTB_white .frame = CGRectMake(230, 430, 70, 40);
    [self.view addSubview:LTB_white ];
    UIImage *normalImagex = [UIImage imageNamed:@"p2.png"];
    [LTB_white  setBackgroundImage:normalImagex forState:UIControlStateNormal];
    
    //重新开始
    LTB_restart = [UIButton buttonWithType:UIButtonTypeCustom];
    LTB_restart.frame = CGRectMake(110, 430, 90, 40);
    [LTB_restart setTitle:@"重新开始" forState:UIControlStateNormal];
    LTB_restart.backgroundColor = [UIColor brownColor];
    [LTB_restart setTitleColor:[UIColor blackColor]  forState:UIControlStateHighlighted];//文字颜色
    [LTB_restart addTarget:self action:@selector(LTB_RestartClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LTB_restart];
    
    [self.view addSubview:LTB_chessView];
    
//    //定义一个大的view  棋盘的大小
//    UIView *LTB_chessView = [[UIView alloc]initWithFrame:CGRectMake(10, (460-300)/2+20, 300, 300)];
//    LTB_chessView.backgroundColor = [UIColor blackColor];
    //定义
    UIButton *LTB_chessButton;
    
    //初始化值
    //tag初值为1  不能为0  否则程序会崩溃
    LTB_localTag = 1;
    //
    LTB_flag =1;
    //给数组初始化值  都为0
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            LTB_chessArray[i][j] = 0;
        }
    }
    
    LTB_localCount = 0;
    
    
    // 循环创建64个button  并且给每一个button都赋一个tag值
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            //
            LTB_chessButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //设置button的位置  和  大小
            LTB_chessButton.frame = CGRectMake(37.5*j, 37.5*i, 37.5, 37.5);
            
            //给每一个button一个tag值   0~63
            LTB_chessButton.tag = LTB_localTag;
            LTB_localTag++;
            
//            if ((i+j)%2 == 0) {
//                //
//                LTB_chessButton.backgroundColor = [UIColor yellowColor];
//            }else{
//                //
//                LTB_chessButton.backgroundColor = [UIColor greenColor];
//            }
//            
            [LTB_chessView addSubview:LTB_chessButton];
            [LTB_chessView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Chessboard2.png"]]];
            //设置点击事件
            [LTB_chessButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        // 加载音效
        _successedSoundId = [self loadSound:@"win.wav"];
        _clickSoundId = [self loadSound:@"chess.wav"];
         _clickSoundIdx = [self loadSound:@"点击按钮.aiff"];
    }
    
    
    [self.view addSubview:LTB_chessView];
    
}


#pragma mark---点击事件
- (void)btnClick:(UIButton *)sender{
    
    AudioServicesPlaySystemSound(_clickSoundId);
    
    //获得所点击按钮的坐标
    int i = (sender.tag-1)/8;
    int j = (sender.tag-1)%8;
    
    if (LTB_flag == 1 && LTB_chessArray[i][j] == 0) {
        //通过sender的tag值  与 LTB_Button或者LTB_blackButton绑定
        LTB_blackButton = (UIButton *)[self.view viewWithTag:sender.tag];
        //点击button  将点击的这个button的图片设置为棋子
        UIImage *LTB_imageName = [UIImage imageNamed:@"黑子1.png"];
        [LTB_blackButton setBackgroundImage:LTB_imageName forState:UIControlStateNormal];
        //1代表下的是黑棋
        LTB_chessArray[i][j] = LTB_flag;
        
        //判断是否赢棋
        //水平方向
        [self LTB_JudgeRow:sender andColor:1];
        //竖直方向
        [self LTB_JudgeLine:sender andColor:1];
        //左上到右下
        [self LTB_JudgeLeftToRight:sender andColor:1];
        //右上到左下
        [self LTB_JudgeRightToLeft:sender andColor:1];
        
        //下一次 该白棋下
        [LTB_whoChess setText:@"接下来，白方下子！"];
        
        //
        LTB_flag = 2;
        
        //判断平局
        LTB_localCount++;
        if (LTB_localCount == 64) {
            LTB_localCount = 0;
            AudioServicesPlaySystemSound(_successedSoundId);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"加油！" message:@"平局！" delegate:self cancelButtonTitle:@"点击继续"otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
    }else if (LTB_flag == 2 && LTB_chessArray[i][j] == 0) {
        //通过sender的tag值  与 LTB_Button或者LTB_blackButton绑定
        LTB_whiteButton = (UIButton *)[self.view viewWithTag:sender.tag];
        
        //点击button  将点击的这个button的图片设置为棋子
        UIImage *LTB_imageName = [UIImage imageNamed:@"白子1.png"];
        [LTB_whiteButton setBackgroundImage:LTB_imageName forState:UIControlStateNormal];
        
        //2代表下的是黑棋
        LTB_chessArray[i][j] = LTB_flag;
        
        //判断是否赢棋
        //水平方向
        [self LTB_JudgeRow:sender andColor:2];
        //竖直方向
        [self LTB_JudgeLine:sender andColor:2];
        //左上到右下
        [self LTB_JudgeLeftToRight:sender andColor:2];
        //右上到左下
        [self LTB_JudgeRightToLeft:sender andColor:2];
        
        
        //下一次 该白棋下
        [LTB_whoChess setText:@"接下来，黑方下子！"];
        
        //flag
        LTB_flag = 1;
        
        //判断平局
        LTB_localCount++;
        if (LTB_localCount == 64) {
            LTB_localCount = 0;
            AudioServicesPlaySystemSound(_successedSoundId);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"加油！" message:@"平局！" delegate:self cancelButtonTitle:@"点击继续"otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
    }
}

#pragma mark----加载音效文件
- (SystemSoundID)loadSound:(NSString *)soundName
{
    
    NSURL *url = [[NSBundle mainBundle]URLForResource:soundName withExtension:nil];
    //创建一个声音id
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundId);
    
    return soundId;
    
}


#pragma mark---点击
- (void)LTB_RestartClick:(UIButton *)sender{
    AudioServicesPlaySystemSound(_clickSoundIdx);

    
    [self LTB_InitChess];
}

#pragma mark----初始化棋盘
- (void)LTB_InitChess{
    
    int i,j;
    
    //再次初始化棋盘
    UIButton *LTB_tempButton;
    //将数组清空
    for (i =  0; i < 8; i++) {
        for (j = 0 ; j < 8; j++) {
            LTB_chessArray[i][j] = 0;
            
            //将button的背景图片掉  把棋子去掉
            LTB_tempButton = (UIButton *)[self.view viewWithTag:i*8+j+1];
            [LTB_tempButton setBackgroundImage:nil forState:UIControlStateNormal];
            
        }
    }
}


//判断左右赢
#pragma mark---判断水平方向输赢
- (void) LTB_JudgeRow:(UIButton *)currentButton andColor:(int)Color{
    
    //获得当前的button的坐标
    int i = (currentButton.tag-1)/8;
    int j = (currentButton.tag-1)%8;
    
    //
    int current = 1;
    
    int tempj = j;
    //判断所下棋子的左边
    while (tempj > 0) {
        tempj--;
        //如果
        if(LTB_chessArray[i][tempj] == Color){
            current++;
        }else{
            break;
        }
    }
    
    tempj = j;
    //判断所下棋子的右边
    while (tempj < 7) {
        tempj++;
        if(LTB_chessArray[i][tempj] == Color)
        {
            current++;
        }else{
            break;
        }
    }
    
    //判断时黑棋赢 还是白棋赢  赢了  便弹出消息框
    if (Color == 1 && current >= 5) {
        AudioServicesPlaySystemSound(_successedSoundId);
        //弹出消息框
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜您" message:@"黑棋获胜了！" delegate:self cancelButtonTitle:@"点击继续"otherButtonTitles:nil, nil];
        [alert show];
        
        return;
        
    }
    if (Color == 2 && current >= 5) {
        AudioServicesPlaySystemSound(_successedSoundId);
        //弹出消息框
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜您" message:@"白棋获胜了！" delegate:self cancelButtonTitle:@"点击继续"otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    current = 1;
}

//判断上下赢
#pragma mark---判断竖直方向输赢
- (void) LTB_JudgeLine:(UIButton *)currentButton andColor:(int)Color{
    
    //获得当前的button的坐标
    int i = (currentButton.tag-1)/8;
    int j = (currentButton.tag-1)%8;
    
    //
    int current = 1;
    
    int tempi = i;
    //判断所下棋子的上边
    while (tempi > 0) {
        tempi--;
        //如果
        if(LTB_chessArray[tempi][j] == Color){
            current++;
        }else{
            break;
        }
    }
    
    tempi = i;
    //判断所下棋子的下边
    while (tempi < 7) {
        tempi++;
        if(LTB_chessArray[tempi][j] == Color)
        {
            current++;
        }else{
            break;
        }
    }
    
    //判断时黑棋赢 还是白棋赢  赢了  便弹出消息框
    if (Color == 1 && current >= 5) {
        AudioServicesPlaySystemSound(_successedSoundId);
        //弹出消息框
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜您" message:@"黑棋获胜了！" delegate:self cancelButtonTitle:@"点击继续"otherButtonTitles:nil, nil];
        [alert show];
        
        return;
        
    }
    if (Color == 2 && current >= 5) {
        AudioServicesPlaySystemSound(_successedSoundId);
        //弹出消息框
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜您" message:@"白棋获胜了！" delegate:self cancelButtonTitle:@"点击继续"otherButtonTitles:nil, nil];
        [alert show];

        
        return;
    }
    current = 1;
}

//判断左上右下
#pragma mark---判断左上到右下方向输赢
- (void) LTB_JudgeLeftToRight:(UIButton *)currentButton andColor:(int)Color{
    
    //获得当前的button的坐标
    int i = (currentButton.tag-1)/8;
    int j = (currentButton.tag-1)%8;
    
    //
    int current = 1;
    
    int tempi = i;
    int tempj = j;
    //判断所下棋子的上边
    while (tempi > 0 && tempj > 0) {
        tempi--;
        tempj--;
        //如果
        if(LTB_chessArray[tempi][tempj] == Color){
            current++;
        }else{
            break;
        }
    }
    
    tempi = i;
    tempj = j;
    //判断所下棋子的下边
    while (tempi < 7 && tempj < 7) {
        tempi++;
        tempj++;
        if(LTB_chessArray[tempi][tempj] == Color)
        {
            current++;
        }else{
            break;
        }
    }
    
    //判断时黑棋赢 还是白棋赢  赢了  便弹出消息框
    if (Color == 1 && current >= 5) {
        AudioServicesPlaySystemSound(_successedSoundId);
        //弹出消息框
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜您" message:@"黑棋获胜了！" delegate:self cancelButtonTitle:@"点击继续"otherButtonTitles:nil, nil];
        [alert show];
        
    
        
        return;
        
    }
    if (Color == 2 && current >= 5) {
        AudioServicesPlaySystemSound(_successedSoundId);
        //弹出消息框
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜您" message:@"白棋获胜了！" delegate:self cancelButtonTitle:@"点击继续"otherButtonTitles:nil, nil];
        [alert show];
        

        
        return;
    }
    current = 1;
}

//判断右上左下
#pragma mark---判断右上到左下方向输赢
- (void) LTB_JudgeRightToLeft:(UIButton *)currentButton andColor:(int)Color{
    
    //获得当前的button的坐标
    int i = (currentButton.tag-1)/8;
    int j = (currentButton.tag-1)%8;
    
    //
    int current = 1;
    
    int tempi = i;
    int tempj = j;
    //判断所下棋子的上边
    while (tempi > 0 && tempj < 7) {
        tempi--;
        tempj++;
        //如果
        if(LTB_chessArray[tempi][tempj] == Color){
            current++;
        }else{
            break;
        }
    }
    
    tempi = i;
    tempj = j;
    //判断所下棋子的下边
    while (tempi < 7 && tempj > 0) {
        tempi++;
        tempj--;
        if(LTB_chessArray[tempi][tempj] == Color)
        {
            current++;
        }else{
            break;
        }
    }
    
    //判断时黑棋赢 还是白棋赢  赢了  便弹出消息框
    if (Color == 1 && current >= 5) {
        AudioServicesPlaySystemSound(_successedSoundId);
        //弹出消息框
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜您" message:@"黑棋获胜了！" delegate:self cancelButtonTitle:@"点击继续"otherButtonTitles:nil, nil];
        [alert show];

        
        return;
    }
    if (Color == 2 && current >= 5) {
        AudioServicesPlaySystemSound(_successedSoundId);
        //弹出消息框
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜您" message:@"白棋获胜了！" delegate:self cancelButtonTitle:@"点击继续"otherButtonTitles:nil, nil];
        [alert show];

        
        return;
    }
    current = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
