//
//  ViewController.m
//  BallGame
//
//  Created by Quix Creations Singapore iOS 1 on 22/8/15.
//  Copyright (c) 2015 Terry Chia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
//@property (strong, nonatomic) IBOutlet UIView *view;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSBundle mainBundle]loadNibNamed:@"ViewController" owner:self options:nil];
    
    //(X Speed, Y Speed)
    pos = CGPointMake(5.0, 4.0);
    
}

-(IBAction)start {
    [startButton setHidden:YES];
    randomMain = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
}

-(void)onTimer {
    
    [self checkCollision];
    
    enemy.center = CGPointMake(enemy.center.x + pos.x, enemy.center.y + pos.y);
    
    if (enemy.center.x > self.view.frame.size.width || enemy.center.x < 0) {
        pos.x = -pos.x;
    }
    
    if (enemy.center.y > self.view.frame.size.height || enemy.center.y <0) {
        pos.y = - pos.y;
    }
    
}

-(void)checkCollision {
    if (CGRectIntersectsRect(player.frame, enemy.frame)) {
        
        [randomMain invalidate];
        [startButton setHidden:NO];
        
        CGRect playerFrame = [player frame];
        playerFrame.origin.x = self.view.center.x;
        playerFrame.origin.y = (3 * (self.view.frame.size.height /4)) ;
        [player setFrame:playerFrame];
        
        CGRect enemyFrame = [enemy frame];
        enemyFrame.origin.x = self.view.center.x ;
        enemyFrame.origin.y = ((self.view.frame.size.height)/4);
        [enemy setFrame: enemyFrame];
        
        CGRect startFrame = [startButton frame];
        startFrame.origin.x = self.view.center.x;
        startFrame.origin.y = self.view.frame.size.height/2;
        [startButton setFrame:startFrame];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Lost" message:@"You are hit. Try Again!" delegate:self cancelButtonTitle:@"Dismiss!" otherButtonTitles:nil, nil];
        [alert show];
        
//        self.viewDidLoad;
        
    }
}

//detects the finger movement
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *myTouch = [[event allTouches]anyObject];
    player.center = [myTouch locationInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
