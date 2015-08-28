//
//  EnemyBall.m
//  BallGame
//
//  Created by Quix Creations Singapore iOS 1 on 27/8/15.
//  Copyright © 2015 Terry Chia. All rights reserved.
//

#import "EnemyBall.h"
#import "ViewController.h"

@implementation EnemyBall

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIImageView *)addEnemyBallFromClass{
    
    UIViewController *myView = [[UIViewController alloc]init];
    int myViewHeight = myView.view.frame.size.height;
    int myViewWidth = myView.view.frame.size.width;
    
    int randomBool = rand()%2;
    
    if ((BOOL)randomBool) {
        UIImageView *enemyRedBall = [[UIImageView alloc]initWithFrame:CGRectMake(rand()%myViewWidth, 0, 44, 44)];
        UIImage *enemyImage = [UIImage imageNamed:@"enemyball"];
        enemyRedBall.image = enemyImage;
        return enemyRedBall;
    }else{
        UIImageView *enemyRedBall = [[UIImageView alloc]initWithFrame:CGRectMake(0, rand()%myViewHeight, 44, 44)];
        UIImage *enemyImage = [UIImage imageNamed:@"enemyball"];
        enemyRedBall.image = enemyImage;
        return enemyRedBall;
    }
}

-(CGPoint)enemyBallSpeed {
    
    long randomX = (random()%2+1) ;
    long randomY = (random()%4+1);
    CGPoint speed = CGPointMake(randomX , randomY);
    
    return speed;
}

@end
