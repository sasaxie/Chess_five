//
//  SpecialChessController.m
//  Chess_five
//
//  Created by qianfeng on 15-8-4.
//  Copyright (c) 2015年 yanda. All rights reserved.
//

#import "SpecialChessController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SpecialChessController ()
{
    int SR_chess[10][10];
    UIButton *button_black;
    UIButton *button_white;
    int iswin[3];//iswin[1]=1代表黑色赢，iswin[2]=1代表白色赢
    int flag;//是黑手还是白手
    int forbid;//是否是禁手棋
    NSString *model;//是哪种禁手
    UIButton *p1;//黑方
    UIButton *p2;//白方
    UIButton *restart;    
    //点击按钮
    SystemSoundID _clickSoundId;
    
    SystemSoundID _clickSoundIdx;
    // 胜利
    SystemSoundID _successedSoundId;
    UILabel *iswho;
}

@end

@implementation SpecialChessController

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
    self.navigationItem.title = @"禁手模式";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self InitValue];//初始化各种值
    NSLog(@"%d %d %d",flag,SR_chess[2][3],SR_chess[4][2]);
    //创建一个view
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, (460-300)/2+45, 300, 300)];
    view.backgroundColor = [UIColor blackColor];
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 65, 320, 420)];
    [bgview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.png"]]];
    [self.view addSubview:bgview];
    
    for(int k = 0;k < 64; k++)
    {
        int i = k / 8;
        int j = k % 8;
        UIView  *viewtp = [[UIView alloc]initWithFrame:CGRectMake(37.5*j, 37.5*i, 37.5, 37.5)];
        // if ( (i + j) % 2 == 0) {
        //    viewtp.backgroundColor = [UIColor blackColor];
        // }
        //else
        //  viewtp.backgroundColor = [UIColor whiteColor];
        [view addSubview:viewtp];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = k+1;//tag不能从0开始
        button.frame = CGRectMake(37.5*j, 37.5*i, 37.5, 37.5);
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    
    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Chessboard2.png"]]];
    p1 = [UIButton buttonWithType:UIButtonTypeCustom];
    p1.frame = CGRectMake(20, 430, 70, 40);
    [self.view addSubview:p1];
    UIImage *normalImage = [UIImage imageNamed:@"p1.png"];
    [p1 setBackgroundImage:normalImage forState:UIControlStateNormal];
    
    p2 = [UIButton buttonWithType:UIButtonTypeCustom];
    p2.frame = CGRectMake(220, 430, 70, 40);
    [self.view addSubview:p2];
    UIImage *normalImagex = [UIImage imageNamed:@"p2.png"];
    [p2 setBackgroundImage:normalImagex forState:UIControlStateNormal];
    
    
    restart = [UIButton buttonWithType:UIButtonTypeCustom];
    restart.frame = CGRectMake(110, 430, 90, 40);
    [restart setTitle:@"重新开始" forState:UIControlStateNormal];
    restart.backgroundColor = [UIColor brownColor];
    [restart setTitleColor:[UIColor blackColor]  forState:UIControlStateHighlighted];//文字颜色
    [restart addTarget:self action:@selector(restartClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:restart];
    
    // 加载音效
    _successedSoundId = [self loadSound:@"win.wav"];
    _clickSoundId = [self loadSound:@"chess.wav"];
    _clickSoundIdx = [self loadSound:@"点击按钮.aiff"];
    
    iswho = [[UILabel alloc]initWithFrame:CGRectMake(100, 108, 150,15)];
    //LTB_whoChess.backgroundColor = [UIColor grayColor];
    [iswho setTextColor:[UIColor blackColor]];
    iswho.font = [UIFont systemFontOfSize:15];
    [iswho setTextAlignment:NSTextAlignmentCenter];
    [iswho setText:@"黑方"];
    [self.view addSubview:iswho];

    
    [self.view addSubview:view];
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


#pragma mark ----初始化值
- (void) InitValue
{
    for(int i =0 ; i < 10; i++)
        for(int j = 0; j < 10 ;j++)
            SR_chess[i][j]=0;
    flag = 1;
    iswin[0] = 0 ; iswin[1] = 0; iswin[2] = 0;
    forbid = 0;
}
- (void) restartClick:(UIButton *) sender
{
    AudioServicesPlaySystemSound(_clickSoundIdx);
    [self ClearChess];//清空棋盘
    [iswho setText:@"黑方"];
}

#pragma mark --- 监听事件
- (void) btnClick:(UIButton *) sender
{
    AudioServicesPlaySystemSound(_clickSoundId);
    //NSLog(@"%d ",sender.tag);
    if( flag == 1)//该黑棋子下了
    {
        button_black = (UIButton *)[self.view viewWithTag:sender.tag];
        int i = (sender.tag -1) / 8;
        int j = (sender.tag -1) % 8;
        if(SR_chess[i][j] == 1 || SR_chess[i][j] ==2 )
            return ;
        
        //判断是否是禁手！
        
        [self isForbid:button_black];
        if (forbid == 1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:model message:@" " delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
            [alert show];
            forbid = 0;
            NSLog(@" forddd %d",forbid);
            return ;
        }
        
        SR_chess[i][j] = 1;
        
        //加图片
        UIImage *normalImage = [UIImage imageNamed:@"黑子1.png"];
        [button_black setBackgroundImage:normalImage forState:UIControlStateNormal];
        
        [self Judge:button_black andColor:1];
        if (iswin[ 1 ] == 1)
        {
            AudioServicesPlaySystemSound(_successedSoundId);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"黑方赢了！" message:@" " delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
            [alert show];
            //[self showDialog:@"点击了导航栏右边按钮"];
            //NSLog(@"黑方赢!");
            
            
            //还原棋盘
            //[self ClearChess];//清空棋盘
            
            return ;
        }
        [iswho setText:@"白方"];
        flag = 0;
        
    }
    else//该白棋子下了
    {
        button_white = (UIButton *)[self.view viewWithTag:sender.tag];
        int i = (sender.tag-1) / 8;
        int j = (sender.tag-1) % 8;
        if(SR_chess[i][j] == 1 || SR_chess[i][j] == 2)
            return;
        SR_chess[i][j] = 2;
        //加图片
        UIImage *NormalImage = [UIImage imageNamed:@"白子1.png"];
        [button_white setBackgroundImage:NormalImage forState:UIControlStateNormal];
        
        [self Judge:button_white andColor:2];
        if(iswin[ 2 ] == 1)
        {
            AudioServicesPlaySystemSound(_successedSoundId);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"白方赢了！" message:@" " delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
            [alert show];
            
            //[self ClearChess];//清空棋盘
            
            //NSLog(@"白方赢!");
            return ;
        }
        flag = 1;
        [iswho setText:@"黑方"];
    }
}

- (void) isForbid:(UIButton *)cureenButton
{
    int curi = (cureenButton.tag-1) / 8;
    int curj = (cureenButton.tag-1) % 8;
    
    //为了方便 ，只判断了一种方向
    
    //三三禁手
    if (SR_chess[curi][curj-1] ==1 &&SR_chess[curi][curj-2] == 1 && SR_chess[curi+1][curj] ==0
        && SR_chess[curi+2][curj] == 1 && SR_chess[curi+3][curj] ==1 && SR_chess[curi-1][curj] == 0) {
        model = @"三三禁手，请重新下棋";
        forbid = 1;
        return ;
    }
    
    if (SR_chess[curi-1][curj-1] == 1 &&SR_chess[curi-1][curj+1] == 1
        &&SR_chess[curi+1][curj-1] == 1 &&SR_chess[curi+1][curj+1] == 1) {
        model = @"三三禁手，请重新下棋";
        forbid = 1;
        return ;
    }
    
    //四四禁手
    if (SR_chess[curi][curj-1] == 1 && SR_chess[curi][curj-2] == 1 && SR_chess[curi][curj-3] == 1
        && SR_chess[curi+1][curj] == 1 &&SR_chess[curi+2][curj] ==1 &&
        SR_chess[curi+3][curj] == 1) {
        model = @"四四禁手，请重新下棋";
        forbid = 1;
        return;
    }
    
    //四四禁手
    if (SR_chess[curi][curj-1] == 1 &&SR_chess[curi-1][curj] == 1 && SR_chess[curi+1][curj] == 1
        && SR_chess[curi+2][curj] == 1 && SR_chess[curi][curj+1] ==1
        &&SR_chess[curi][curj+2] == 1) {
        model = @"四四禁手，请重新下棋";
        forbid = 1;
        return;
    }
    
    //四四禁手
    if (SR_chess[curi][curj-1] == 1 && SR_chess[curi][curj-2] == 0 && SR_chess[curi][curj-3] == 1
        && SR_chess[curi][curj+1] == 1 &&SR_chess[curi][curj+2] == 0 &&
        SR_chess[curi][curj+3] == 1) {
        model = @"四四禁手，请重新下棋";
        forbid = 1;
        return;
    }
    
    //四三三禁手
    if (SR_chess[curi][curj-1] == 1 && SR_chess[curi][curj-2]==1 && SR_chess[curi-1][curj+1] ==1
        && SR_chess[curi+1][curj -1]==1 && SR_chess[curi+2][curj-2] == 1
        && SR_chess[curi+1][curj+1] == 1 && SR_chess[curi+2][curj+2] == 1) {
        model = @"四三三禁手,请重新下棋";
        forbid = 1;
        return;
        
    }
    
    //长连禁手
    if (SR_chess[curi][curj-1] == 1 && SR_chess[curi][curj-2] == 1 && SR_chess[curi][curj+1] == 1
        && SR_chess[curi][curj+2] == 1 && SR_chess[curi][curj+3] ==1 ) {
        model = @"长连禁手";
        forbid = 1;
        return ;
    }
    
}

#pragma mark---清空棋盘
- (void) ClearChess
{
    for (int i = 0 ;i < 8; i++)
        for (int j = 0 ;j < 8 ;j ++)
        {
            
            UIButton *btn = (UIButton *)[self.view viewWithTag: (i*8+j)+1];
            [btn setBackgroundImage:nil forState:UIControlStateNormal];
            SR_chess[i][j] = 0;
        }
    iswin[0]=0;iswin[1]=0;iswin[2]=0;
}

- (void) Judge:(UIButton *) currentButton andColor: (int )color
{
    //左右判断
    int cnt = 1; //连棋子的个数
    int curi = (currentButton.tag -1 ) / 8;
    int curj = (currentButton.tag -1 ) % 8;
    //  NSLog(@"here   %d  %d",curi, curj);
    int tpi = curi, tpj = curj-1;
    while( tpj>= 0) //向左
    {
        //NSLog(@"i %d j %d   %d ",tpi,tpj,SR_chess[tpi][tpj]);
        if (SR_chess[curi][tpj] == color) {
            cnt ++;
            if (cnt == 5 ) {
                iswin[color]=1;
                return ;
            }
        }
        else
            break;
        tpj--;
    }
    tpj = curj + 1;//向右
    while (tpj <= 7) {
        if(SR_chess[curi][tpj] == color)
        {
            cnt++;
            if(cnt == 5)
            {
                iswin[color]=1;
                return;
            }
        }
        else
            break;
        tpj++;
    }
    
    //上下判断
    cnt = 1;
    tpi = curi - 1;
    tpj = curj;
    while (tpi >= 0) {
        if(SR_chess[tpi][curj] == color)
        {
            cnt++;
            if (cnt == 5)
            {
                iswin[color] = 1;
                return;
                
            }
        }
        else
            break;
        tpi--;
    }
    tpi = curi + 1;
    while (tpi <= 7)
    {
        if(SR_chess[tpi][curj] == color)
        {
            cnt++;
            if(cnt==5)
            {
                iswin[color] = 1;
                return;
            }
        }
        else
            break;
        tpi ++;
    }
    
    //左上右下判断
    cnt = 1;
    tpi = curi - 1;
    tpj = curj - 1;
    while (tpi >= 0 && tpj >=0) {
        
        if(SR_chess[tpi][tpj] == color)
        {
            cnt++;
            if (cnt == 5) {
                iswin[color] = 1;
                return ;
            }
        }
        else
            break;
        tpi--;
        tpj--;
    }
    tpi = curi + 1;
    tpj = curj + 1;
    while (tpi <=7 && tpj <=7 ) {
        if(SR_chess[tpi][tpj] == color)
        {
            cnt++;
            if (cnt == 5) {
                iswin[color] = 1;
                return;
            }
        }
        else
            break;
        tpi++;
        tpj++;
    }
    
    //左下右上判断
    cnt = 1;
    tpi = curi + 1;
    tpj = curj - 1;
    while (tpi <= 7 && tpj>=0) {
        
        if(SR_chess[tpi][tpj] == color)
        {
            cnt++;
            if(cnt == 5)
            {
                iswin[color] = 1;
                return ;
            }
        }
        else
            break;
        tpi++;
        tpj--;
    }
    
    tpi = curi - 1;
    tpj = curj + 1;
    while (tpi >= 0 && tpj <=7) {
        if (SR_chess[tpi][tpj] == color) {
            cnt++;
            if (cnt == 5) {
                iswin[color] = 1;
                return ;
            }
        }
        else
            break;
        tpi--;
        tpj++;
    }
    
    //
    //NSLog(@"cnt %d",cnt);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
