//
//  ViewController.m
//  BallGame
//
//  Created by Quix Creations Singapore iOS 1 on 22/8/15.
//  Copyright (c) 2015 Terry Chia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation ViewController

#define MovingObjectRadius 22

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //(X Speed, Y Speed)
    pos = CGPointMake(5.0, 4.0);

}



-(IBAction)start {
    [startButton setHidden:YES];
    
    randomMain = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    addMoreBall = [NSTimer scheduledTimerWithTimeInterval:1.50 target:self selector:@selector(addMoreBall) userInfo:nil repeats:YES];
    
    [self startAcceleratorForPlayer];
    
}

-(void)addMoreBall {
    
    UIImageView *enemy2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImage *image = [UIImage imageNamed:@"enemyball"];
    enemy2.image = image;
    
    [self.view addSubview:enemy2];
    
    [enemyArray addObject:enemy2];
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
        
        [self.motionManager stopAccelerometerUpdates];
//        self.viewDidLoad;
        
    }
}

//starts the acceleration
-(void)startAcceleratorForPlayer {
    
    //declare start of motion sensor
    self.motionManager = [[CMMotionManager alloc]init];
    
    self.motionManager.accelerometerUpdateInterval = 1/60;
    
    if ([self.motionManager isAccelerometerAvailable]) {
        
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [self.motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData * accelerometerData, NSError * _Nullable error) {
            
            NSLog(@"X = %0.4f, Y = %.04f, Z = %0.4f",
                  accelerometerData.acceleration.x,
                  accelerometerData.acceleration.y,
                  accelerometerData.acceleration.z);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //acceleration for player
                float valueX = accelerometerData.acceleration.x * 40.0;
                float valueY = accelerometerData.acceleration.y * 40.0;
                
                //create new integers
                int intPlayerNewPosX = (int)(player.center.x + valueX);
                int intPlayerNewPosY = (int)(player.center.y + valueY);
                
                //position validation
                if (intPlayerNewPosX > (self.view.frame.size.width - MovingObjectRadius)) {
                    intPlayerNewPosX = (self.view.frame.size.width - MovingObjectRadius);
                }
                
                if (intPlayerNewPosX < (0 + MovingObjectRadius)) {
                    intPlayerNewPosX = (0 + MovingObjectRadius);
                }
                
                if (intPlayerNewPosY > (self.view.frame.size.width - MovingObjectRadius)) {
                    intPlayerNewPosY = (self.view.frame.size.width - MovingObjectRadius);
                }
                
                if (intPlayerNewPosY < (0 + MovingObjectRadius)) {
                    intPlayerNewPosY = (0+ MovingObjectRadius);
                }
                
                //Make new point
                CGPoint playerNewPoint = CGPointMake(intPlayerNewPosX, intPlayerNewPosY);
                player.center = playerNewPoint;
                
            });
        }];
    } else{
        NSLog(@"Not Active.");
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
