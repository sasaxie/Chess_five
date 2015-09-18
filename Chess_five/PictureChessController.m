//
//  PictureChessController.m
//  Chess_five
//
//  Created by qianfeng on 15-8-4.
//  Copyright (c) 2015年 yanda. All rights reserved.
//

#import "PictureChessController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ChessBoard.h"

#define XXDCHESSCOUNTS 65
@interface PictureChessController ()
{
    int _XXD_flag;
    int _XXD_tag;
    BOOL _XXD_isEnd;
    //点击按钮
    SystemSoundID _clickSoundId;
    
    SystemSoundID _clickSoundIdx;
    // 胜利
    SystemSoundID _successedSoundId;
}
// 创建一个棋盘
@property (nonatomic, strong)UIView *XXD_chessBoard;
// 创建一个二维数组存放棋子
@property (nonatomic, strong)NSMutableArray *XXD_chess;
// 设置当前黑方棋子图片
@property (nonatomic, strong)NSString *XXD_currentBlackImageName;
// 设置当前白方棋子图片
@property (nonatomic, strong)NSString *XXD_currentWhiteImageName;

@end

@implementation PictureChessController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // 表示黑色开始
        _XXD_flag = 0;
        _XXD_tag = 1;
        _XXD_isEnd = NO;
        
        _XXD_currentBlackImageName = @"黑子副本.bmp";
        _XXD_currentWhiteImageName = @"白子副本.bmp";
        
        // 初始化棋子的二维数组为0个空间大小
        _XXD_chess = [NSMutableArray arrayWithCapacity:65];
        
        for (int i = 0; i < XXDCHESSCOUNTS; ++i)
        {
            // 将_XXD_chess都赋值为0,表示没有棋子
            [_XXD_chess addObject:[NSString stringWithFormat:@"%d", 0]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"图片模式";
    self.view.backgroundColor = [UIColor lightGrayColor];
    //创建一个view
    UIView *XXD_chessBoard = [[UIView alloc]initWithFrame:CGRectMake(10, (460 - 300) / 2 + 40, 300, 300)];
    XXD_chessBoard.backgroundColor = [UIColor blackColor];
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 60, 320, 420)];
    [bgview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.png"]]];
    [self.view addSubview:bgview];
    
    // 画棋盘
    _XXD_chessBoard = [ChessBoard XXD_CreateChessBoard];
    // 将棋盘添加到根控制器上
    [self.view addSubview:_XXD_chessBoard];
    
    // 初始化棋子
    [self XXD_InitChess];
    
    // 添加换图片的按钮啦
    [self XXD_CreateImageButton:@"star_0.png" andPosition:CGPointMake(10, 410) andTag:110];
    [self XXD_CreateImageButton:@"黑子1.png" andPosition:CGPointMake(10, 440) andTag:111];
    [self XXD_CreateImageButton:@"p11.png" andPosition:CGPointMake(50, 410) andTag:112];
    [self XXD_CreateImageButton:@"star_1.png" andPosition:CGPointMake(270, 410) andTag:120];
    [self XXD_CreateImageButton:@"白子1.png" andPosition:CGPointMake(270, 440) andTag:121];
    [self XXD_CreateImageButton:@"p22.png" andPosition:CGPointMake(230, 410) andTag:122];
    
    // 添加标签
    // 谁下了
    [self XXD_CreateLabel:@"黑方" andPosition:CGPointMake(0, 60) andTextSize:20 andWidth:330 andHeight:40 andColor:[UIColor redColor] andTag:200];
    // 黑色选择图片提示
    [self XXD_CreateLabel:@"黑方选图" andPosition:CGPointMake(70, 400) andTextSize:15 andWidth:100 andHeight:40 andColor:[UIColor blackColor] andTag:201];
    // 白色选择图片提示
    [self XXD_CreateLabel:@"白方选图" andPosition:CGPointMake(140, 400) andTextSize:15 andWidth:100 andHeight:40 andColor:[UIColor blackColor] andTag:202];
    
    // 重新开始按钮
    UIButton *XXD_restartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    XXD_restartButton.frame = CGRectMake(110, 440, 100, 30);
    [XXD_restartButton setTitle:@"重新开始" forState:UIControlStateNormal];
    XXD_restartButton.backgroundColor = [UIColor brownColor];
    [XXD_restartButton addTarget:self action:@selector(XXD_restartClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 加载音效
    _successedSoundId = [self loadSound:@"win.wav"];
    _clickSoundId = [self loadSound:@"chess.wav"];
    _clickSoundIdx = [self loadSound:@"点击按钮.aiff"];
    [self.view addSubview:XXD_restartButton];
    
    
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
#pragma mark------重新开始按钮监听事件
- (void)XXD_restartClick:(UIButton *)sender
{
    AudioServicesPlaySystemSound(_clickSoundIdx);
    // 清空棋盘
    for (int i = 0; i < XXDCHESSCOUNTS; ++i)
    {
        // 将_XXD_chess都赋值为0,表示没有棋子
        [_XXD_chess replaceObjectAtIndex:(i) withObject:@"0"];
    }
    // 重绘
    [self XXD_Draw];
    _XXD_isEnd = NO;
    _XXD_flag = 0;
}

#pragma mark------封装换图片按钮
- (void)XXD_CreateImageButton:(NSString *)XXD_ImageName andPosition:(CGPoint)XXD_point andTag:(long)XXD_tag
{
    UIButton *XXD_button = [UIButton buttonWithType:UIButtonTypeCustom];
    XXD_button.frame = CGRectMake(XXD_point.x, XXD_point.y, 33, 33);
    UIImage *XXD_image = [UIImage imageNamed:XXD_ImageName];
    [XXD_button setImage:XXD_image forState:UIControlStateNormal];
    // 设置监听事件
    [XXD_button addTarget:self action:@selector(XXD_BtnImageClick:) forControlEvents:UIControlEventTouchUpInside];
    XXD_button.tag = XXD_tag;
    // 添加
    [self.view addSubview:XXD_button];
}

#pragma mart------封装Label
- (void)XXD_CreateLabel:(NSString *)XXD_labelName andPosition:(CGPoint)XXD_point andTextSize:(int)XXD_size andWidth:(int)XXD_width andHeight:(int)XXD_height andColor:(UIColor *)XXD_color andTag:(long)XXD_tag
{
    UILabel *XXD_label = [[UILabel alloc]initWithFrame:CGRectMake(XXD_point.x, XXD_point.y, XXD_width, XXD_height)];
    XXD_label.text = XXD_labelName;
    // 居中
    XXD_label.textAlignment = NSTextAlignmentCenter;
    // 字体大小
    XXD_label.font = [UIFont systemFontOfSize:XXD_size];
    // 字体颜色
    XXD_label.textColor = XXD_color;
    XXD_label.tag = XXD_tag;
    
    [self.view addSubview:XXD_label];
}


#pragma mark------换图片按钮监听事件
- (void)XXD_BtnImageClick:(UIButton *)sender
{
    AudioServicesPlaySystemSound(_clickSoundIdx);
    if (110 == sender.tag)
    {
        _XXD_currentBlackImageName = @"star_0.png";
        UIButton *XXD_tempButton = (UIButton *)[self.view viewWithTag:111];
        UIImage *XXD_tempImage = [UIImage imageNamed:@"黑子1.png"];
        [XXD_tempButton setImage:XXD_tempImage forState:UIControlStateNormal];
        
        UIButton *XXD_tempButton2 = (UIButton *)[self.view viewWithTag:110];
        UIImage *XXD_tempImage2 = [UIImage imageNamed:@"star_0选中.png"];
        [XXD_tempButton2 setImage:XXD_tempImage2 forState:UIControlStateNormal];
        
        UIButton *XXD_tempButton3 = (UIButton *)[self.view viewWithTag:112];
        UIImage *XXD_tempImage3 = [UIImage imageNamed:@"p11.png"];
        [XXD_tempButton3 setImage:XXD_tempImage3 forState:UIControlStateNormal];
    }
    else if (111 == sender.tag)
    {
        _XXD_currentBlackImageName = @"黑子1.png";
        UIButton *XXD_tempButton = (UIButton *)[self.view viewWithTag:111];
        UIImage *XXD_tempImage = [UIImage imageNamed:@"黑子1选中.png"];
        [XXD_tempButton setImage:XXD_tempImage forState:UIControlStateNormal];
        
        UIButton *XXD_tempButton2 = (UIButton *)[self.view viewWithTag:110];
        UIImage *XXD_tempImage2 = [UIImage imageNamed:@"star_0.png"];
        [XXD_tempButton2 setImage:XXD_tempImage2 forState:UIControlStateNormal];
        
        UIButton *XXD_tempButton3 = (UIButton *)[self.view viewWithTag:112];
        UIImage *XXD_tempImage3 = [UIImage imageNamed:@"p11.png"];
        [XXD_tempButton3 setImage:XXD_tempImage3 forState:UIControlStateNormal];
    }
    else if (112 == sender.tag)
    {
        _XXD_currentBlackImageName = @"p11.png";
        UIButton *XXD_tempButton = (UIButton *)[self.view viewWithTag:111];
        UIImage *XXD_tempImage = [UIImage imageNamed:@"黑子1.png"];
        [XXD_tempButton setImage:XXD_tempImage forState:UIControlStateNormal];
        
        UIButton *XXD_tempButton2 = (UIButton *)[self.view viewWithTag:110];
        UIImage *XXD_tempImage2 = [UIImage imageNamed:@"star_0.png"];
        [XXD_tempButton2 setImage:XXD_tempImage2 forState:UIControlStateNormal];
        
        UIButton *XXD_tempButton3 = (UIButton *)[self.view viewWithTag:112];
        UIImage *XXD_tempImage3 = [UIImage imageNamed:@"p11选中.png"];
        [XXD_tempButton3 setImage:XXD_tempImage3 forState:UIControlStateNormal];
    }
    else if (120 == sender.tag)
    {
        _XXD_currentWhiteImageName = @"star_1.png";
        UIButton *XXD_tempButton = (UIButton *)[self.view viewWithTag:121];
        UIImage *XXD_tempImage = [UIImage imageNamed:@"白子1.png"];
        [XXD_tempButton setImage:XXD_tempImage forState:UIControlStateNormal];
        
        UIButton *XXD_tempButton2 = (UIButton *)[self.view viewWithTag:120];
        UIImage *XXD_tempImage2 = [UIImage imageNamed:@"star_1选中.png"];
        [XXD_tempButton2 setImage:XXD_tempImage2 forState:UIControlStateNormal];
        
        UIButton *XXD_tempButton3 = (UIButton *)[self.view viewWithTag:122];
        UIImage *XXD_tempImage3 = [UIImage imageNamed:@"p22.png"];
        [XXD_tempButton3 setImage:XXD_tempImage3 forState:UIControlStateNormal];
    }
    else if (121 == sender.tag)
    {
        _XXD_currentWhiteImageName = @"白子1.png";
        UIButton *XXD_tempButton = (UIButton *)[self.view viewWithTag:121];
        UIImage *XXD_tempImage = [UIImage imageNamed:@"白子1选中.png"];
        [XXD_tempButton setImage:XXD_tempImage forState:UIControlStateNormal];
        
        UIButton *XXD_tempButton2 = (UIButton *)[self.view viewWithTag:120];
        UIImage *XXD_tempImage2 = [UIImage imageNamed:@"star_1.png"];
        [XXD_tempButton2 setImage:XXD_tempImage2 forState:UIControlStateNormal];
        
        UIButton *XXD_tempButton3 = (UIButton *)[self.view viewWithTag:122];
        UIImage *XXD_tempImage3 = [UIImage imageNamed:@"p22.png"];
        [XXD_tempButton3 setImage:XXD_tempImage3 forState:UIControlStateNormal];
    }
    else if (122 == sender.tag)
    {
        _XXD_currentWhiteImageName = @"p22.png";
        UIButton *XXD_tempButton = (UIButton *)[self.view viewWithTag:121];
        UIImage *XXD_tempImage = [UIImage imageNamed:@"白子1.png"];
        [XXD_tempButton setImage:XXD_tempImage forState:UIControlStateNormal];
        
        UIButton *XXD_tempButton2 = (UIButton *)[self.view viewWithTag:120];
        UIImage *XXD_tempImage2 = [UIImage imageNamed:@"star_1.png"];
        [XXD_tempButton2 setImage:XXD_tempImage2 forState:UIControlStateNormal];
        
        UIButton *XXD_tempButton3 = (UIButton *)[self.view viewWithTag:122];
        UIImage *XXD_tempImage3 = [UIImage imageNamed:@"p22选中.png"];
        [XXD_tempButton3 setImage:XXD_tempImage3 forState:UIControlStateNormal];
    }
    
    [self XXD_Draw];
}

#pragma mark------初始化棋子
- (void)XXD_InitChess
{
    // 这里用64个button代替棋子
    for (int i = 0; i < _XXD_chess.count; ++i)
    {
        if ([@"0"  isEqual: [_XXD_chess objectAtIndex:i]])
        {
            [self XXD_CreateButton:0 andChessPoint:CGPointMake(37.5 * (i % 8), 37.5 * (i / 8))];
        }
        else if ([@"1"  isEqual: [_XXD_chess objectAtIndex:i]])
        {
            [self XXD_CreateButton:1 andChessPoint:CGPointMake(37.5 * (i % 8), 37.5 * (i / 8))];
        }
        else if ([@"2"  isEqual: [_XXD_chess objectAtIndex:i]])
        {
            [self XXD_CreateButton:2 andChessPoint:CGPointMake(37.5 * (i % 8), 37.5 * (i / 8))];
        }
    }
}

#pragma mark------创建棋子button
- (void)XXD_CreateButton:(int)XXD_chessType andChessPoint:(CGPoint)XXD_point
{
    UIButton *XXD_button = [UIButton buttonWithType:UIButtonTypeCustom];
    XXD_button.frame = CGRectMake(XXD_point.x, XXD_point.y, 37.5f, 37.5f);
    if (0 == XXD_chessType)
    {
        // 没有棋子
        [XXD_button setImage:nil forState:UIControlStateNormal];
        // [XXD_button setTitle:@"a" forState:UIControlStateNormal];
    }
    else if (1 == XXD_chessType)
    {
        // 黑棋
        UIImage *XXD_image = [UIImage imageNamed:_XXD_currentBlackImageName];
        [XXD_button setImage:XXD_image forState:UIControlStateNormal];
    }
    else if (2 == XXD_chessType)
    {
        // 白棋
        UIImage *XXD_image = [UIImage imageNamed:_XXD_currentWhiteImageName];
        [XXD_button setImage:XXD_image forState:UIControlStateNormal];
    }
    // 设置好tag
    XXD_button.tag = _XXD_tag;
    ++_XXD_tag;
    // 设置好监听事件
    [XXD_button addTarget:self action:@selector(XXD_BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_XXD_chessBoard addSubview:XXD_button];
}

#pragma mark------按钮监听事件
- (void)XXD_BtnClick:(UIButton *)sender
{
    if (NO == _XXD_isEnd)
    {
        // 当前棋子的类型
        int XXD_currentChessType = 0;
        AudioServicesPlaySystemSound(_clickSoundId);
        if ([@"0"  isEqual: [_XXD_chess objectAtIndex:(sender.tag)]])
        {
            if (0 == _XXD_flag)
            {
                // 黑色
                _XXD_flag = 1;
                // UIImage *XXD_image = [UIImage imageNamed:_XXD_currentBlackImageName];
                // [sender setImage:XXD_image forState:UIControlStateNormal];
                [_XXD_chess replaceObjectAtIndex:(sender.tag) withObject:@"1"];
                [self XXD_Draw];
                UILabel *XXD_labelTitle = (UILabel *)[self.view viewWithTag:200];
                XXD_labelTitle.text = @"白方";
                XXD_currentChessType = 1;
            }
            else if (1 == _XXD_flag)
            {
                // 白色
                _XXD_flag = 0;
                // UIImage *XXD_image = [UIImage imageNamed:_XXD_currentWhiteImageName];
                // [sender setImage:XXD_image forState:UIControlStateNormal];
                [_XXD_chess replaceObjectAtIndex:(sender.tag) withObject:@"2"];
                [self XXD_Draw];
                UILabel *XXD_labelTitle = (UILabel *)[self.view viewWithTag:200];
                XXD_labelTitle.text = @"黑方";
                XXD_currentChessType = 2;
            }
            // 判断胜负的逻辑
            if ([self XXD_IsWin:sender.tag andChessType:XXD_currentChessType])
            {
                // 胜利
                AudioServicesPlaySystemSound(_successedSoundId);
                NSString *XXD_tip = @"谁会获胜呢";
                if (1 == XXD_currentChessType)
                {
                    XXD_tip = @"黑方获胜了~";
                }
                else if (2 == XXD_currentChessType)
                {
                    XXD_tip = @"白方获胜了~";
                }
                //弹出消息框
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜您" message:XXD_tip delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
                [alert show];
                // 清空棋盘
                for (int i = 0; i < XXDCHESSCOUNTS; ++i)
                {
                    // 将_XXD_chess都赋值为0,表示没有棋子
                    [_XXD_chess replaceObjectAtIndex:(i) withObject:@"0"];
                }
                _XXD_isEnd = YES;
            }
            else if ([self XXD_IsGood])
            {
                // 判断是否下满棋子了，就是平局
                AudioServicesPlaySystemSound(_successedSoundId);
                NSString *XXD_tip = @"不分伯仲";
                //弹出消息框
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"平局" message:XXD_tip delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
                [alert show];
                // 清空棋盘
                for (int i = 0; i < XXDCHESSCOUNTS; ++i)
                {
                    // 将_XXD_chess都赋值为0,表示没有棋子
                    [_XXD_chess replaceObjectAtIndex:(i) withObject:@"0"];
                }
                _XXD_isEnd = YES;
            }
            else
            {
                // 继续下棋，什么都不做
                ;
            }
        }
    }
    else
    {
        ;
    }
}

#pragma mark------平局判断
- (BOOL)XXD_IsGood
{
    BOOL XXD_isGood = YES;
    
    // 判断棋盘是否下满
    for (int i = 0; i < XXDCHESSCOUNTS; ++i)
    {
        if ([@"0" isEqual:[_XXD_chess objectAtIndex:i]])
        {
            XXD_isGood = NO;
            break;
        }
    }
    
    return XXD_isGood;
}

#pragma mark------胜负判断（真）
- (BOOL)XXD_IsWin:(long)XXD_tag andChessType:(int)XXD_chessType
{
    BOOL XXD_isWin = NO;
    
    // 只要有一个符合就结束游戏，并提示胜利
    if ([self XXD_IsWinUpToDown:XXD_tag andChessType:XXD_chessType])
    {
        // 判断从当前棋子竖直方向上的情况
        XXD_isWin = YES;
    }
    else if ([self XXD_IsWinLeftToRight:XXD_tag andChessType:XXD_chessType])
    {
        // 判断从当前棋子横向方向上的情况
        XXD_isWin = YES;
    }
    else if ([self XXD_IsWinLeftUpToRightDown:XXD_tag andChessType:XXD_chessType])
    {
        // 判断从当前棋子左上到右下的情况
        XXD_isWin = YES;
    }
    else if ([self XXD_IsWinRightUpToLeftDown:XXD_tag andChessType:XXD_chessType])
    {
        // 判断从当前棋子右上到左下的情况
        XXD_isWin = YES;
    }
    
    return XXD_isWin;
}

#pragma mark------胜负判断（竖直）
- (BOOL)XXD_IsWinUpToDown:(long)XXD_tag andChessType:(int)XXD_chessType
{
    BOOL XXD_isWin = NO;
    // 当前包含的棋子数量
    int XXD_currentChessCounts = 1;
    // 保存当前棋子tag
    long XXD_currentTag = XXD_tag;
    int i = 1;
    NSString *XXD_currentChessType = [NSString stringWithFormat:@"%d", XXD_chessType];
    
    // 根据当前tag([1, 64])来判断
    // 当前棋子上方
    while (((1 <= (XXD_currentTag - (8 * i))) && (65 > (XXD_currentTag - (8 * i)))) && ([XXD_currentChessType isEqual:[_XXD_chess objectAtIndex:(XXD_currentTag - (8 * i))]]))
    {
        ++XXD_currentChessCounts;
        ++i;
    }
    i = 1;
    // 当前棋子下方
    while (((1 <= (XXD_currentTag + (8 * i))) && (65 > (XXD_currentTag + (8 * i)))) && ([XXD_currentChessType isEqual:[_XXD_chess objectAtIndex:(XXD_currentTag + (8 * i))]]))
    {
        ++XXD_currentChessCounts;
        ++i;
    }
    
    if (5 == XXD_currentChessCounts)
    {
        XXD_isWin = YES;
    }
    else
    {
        ;
    }
    
    return XXD_isWin;
}

#pragma mark------胜负判断（横向）
- (BOOL)XXD_IsWinLeftToRight:(long)XXD_tag andChessType:(int)XXD_chessType
{
    BOOL XXD_isWin = NO;
    // 当前包含的棋子数量
    int XXD_currentChessCounts = 1;
    // 保存当前棋子tag
    long XXD_currentTag = XXD_tag;
    int i = 1;
    NSString *XXD_currentChessType = [NSString stringWithFormat:@"%d", XXD_chessType];
    
    // 根据当前tag([1, 64])来判断
    // 当前棋子左边
    while (((1 <= (XXD_currentTag - i)) && (65 > (XXD_currentTag - i))) && ([XXD_currentChessType isEqual:[_XXD_chess objectAtIndex:(XXD_currentTag - i)]]))
    {
        ++XXD_currentChessCounts;
        ++i;
    }
    i = 1;
    // 当前棋子右边
    while (((1 <= (XXD_currentTag + i)) && (65 > (XXD_currentTag + i))) && ([XXD_currentChessType isEqual:[_XXD_chess objectAtIndex:(XXD_currentTag + i)]]))
    {
        ++XXD_currentChessCounts;
        ++i;
    }
    
    if (5 == XXD_currentChessCounts)
    {
        XXD_isWin = YES;
    }
    else
    {
        ;
    }
    
    return XXD_isWin;
}

#pragma mark------胜负判断（左上到右下）
- (BOOL)XXD_IsWinLeftUpToRightDown:(long)XXD_tag andChessType:(int)XXD_chessType
{
    BOOL XXD_isWin = NO;
    // 当前包含的棋子数量
    int XXD_currentChessCounts = 1;
    // 保存当前棋子tag
    long XXD_currentTag = XXD_tag;
    int i = 1;
    NSString *XXD_currentChessType = [NSString stringWithFormat:@"%d", XXD_chessType];
    
    // 根据当前tag([1, 64])来判断
    // 当前棋子左上
    while (((1 <= (XXD_currentTag - (9 * i))) && (65 > (XXD_currentTag - (9 * i)))) && ([XXD_currentChessType isEqual:[_XXD_chess objectAtIndex:(XXD_currentTag - (9 * i))]]))
    {
        ++XXD_currentChessCounts;
        ++i;
    }
    i = 1;
    // 当前棋子右下
    while (((1 <= (XXD_currentTag + (9 * i))) && (65 > (XXD_currentTag + (9 * i)))) && ([XXD_currentChessType isEqual:[_XXD_chess objectAtIndex:(XXD_currentTag + (9 * i))]]))
    {
        ++XXD_currentChessCounts;
        ++i;
    }
    
    if (5 == XXD_currentChessCounts)
    {
        XXD_isWin = YES;
    }
    else
    {
        ;
    }
    
    return XXD_isWin;
}

#pragma mark------胜负判断（右上到左下）
- (BOOL)XXD_IsWinRightUpToLeftDown:(long)XXD_tag andChessType:(int)XXD_chessType
{
    BOOL XXD_isWin = NO;
    // 当前包含的棋子数量
    int XXD_currentChessCounts = 1;
    // 保存当前棋子tag
    long XXD_currentTag = XXD_tag;
    int i = 1;
    NSString *XXD_currentChessType = [NSString stringWithFormat:@"%d", XXD_chessType];
    
    // 根据当前tag([1, 64])来判断
    // 当前棋子右上
    while (((1 <= (XXD_currentTag - (7 * i))) && (65 > (XXD_currentTag - (7 * i)))) && ([XXD_currentChessType isEqual:[_XXD_chess objectAtIndex:(XXD_currentTag - (7 * i)) ]]))
    {
        ++XXD_currentChessCounts;
        ++i;
    }
    i = 1;
    // 当前棋子左下
    while (((1 <= (XXD_currentTag + (7 * i))) && (65 > (XXD_currentTag + (7 * i)))) && ([XXD_currentChessType isEqual:[_XXD_chess objectAtIndex:(XXD_currentTag + (7 * i))]]))
    {
        ++XXD_currentChessCounts;
        ++i;
    }
    
    if (5 == XXD_currentChessCounts)
    {
        XXD_isWin = YES;
    }
    else
    {
        ;
    }
    
    return XXD_isWin;
}

#pragma mark------每次下棋都会重新绘制
- (void)XXD_Draw
{
    for (int i = 1; i < _XXD_chess.count; ++i)
    {
        // 根据_XXD_chess的值，重新设置每个棋子的样子
        if ([@"0"  isEqual: [_XXD_chess objectAtIndex:i]])
        {
            // 没有棋子
            UIButton *XXD_tempButton = (UIButton *)[self.view viewWithTag:i];
            UIImage *XXD_tempImage = [UIImage imageNamed:nil];
            [XXD_tempButton setImage:XXD_tempImage forState:UIControlStateNormal];
        }
        else if ([@"1"  isEqual: [_XXD_chess objectAtIndex:i]])
        {
            // 黑色
            UIButton *XXD_tempButton = (UIButton *)[self.view viewWithTag:i];
            UIImage *XXD_tempImage = [UIImage imageNamed:_XXD_currentBlackImageName];
            [XXD_tempButton setImage:XXD_tempImage forState:UIControlStateNormal];
        }
        else if ([@"2"  isEqual: [_XXD_chess objectAtIndex:i]])
        {
            // 白色
            UIButton *XXD_tempButton = (UIButton *)[self.view viewWithTag:i];
            UIImage *XXD_tempImage = [UIImage imageNamed:_XXD_currentWhiteImageName];
            [XXD_tempButton setImage:XXD_tempImage forState:UIControlStateNormal];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
