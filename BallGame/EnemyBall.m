//
//  EnemyBall.m
//  BallGame
//
//  Created by Quix Creations Singapore iOS 1 on 27/8/15.
//  Copyright © 2015 Terry Chia. All rights reserved.
//

#import "EnemyBall.h"

@implementation EnemyBall

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIImageView *)addEnemyBallFromClass{
    
    UIImageView *enemyRedBall = [[UIImageView alloc]initWithFrame:CGRectMake(250, 250, 44, 44)];
    UIImage *enemyImage = [UIImage imageNamed:@"enemyball"];
    enemyRedBall.image = enemyImage;
    
    return enemyRedBall;
}

@end
