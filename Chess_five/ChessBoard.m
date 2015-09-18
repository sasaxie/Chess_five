//
//  ChessBoard.m
//  FiveChess
//
//  Created by qianfeng on 15-8-4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ChessBoard.h"

@implementation ChessBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (UIView *)XXD_CreateChessBoard
{
    UIView *XXD_chessBoard = [[UIView alloc]initWithFrame:CGRectMake(10, (460 - 300) / 2 + 20, 300, 300)];
    [XXD_chessBoard setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Chessboard2.png"]]];
    
    return XXD_chessBoard;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
