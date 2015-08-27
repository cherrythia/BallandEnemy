//
//  ViewController.m
//  BallGame
//
//  Created by Quix Creations Singapore iOS 1 on 22/8/15.
//  Copyright (c) 2015 Terry Chia. All rights reserved.
//

#import "ViewController.h"
#import "EnemyBall.h"

@interface ViewController ()

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (atomic, strong) UIImageView *player;

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
    
    addMoreBall = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addMoreBall) userInfo:nil repeats:YES];
    
    [self startAcceleratorForPlayer];
    
    //Add player ball
    self.player = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 40, 40)];
    UIImage *playerImage = [UIImage imageNamed:@"playerball"];
    self.player.image = playerImage;
    [self.view addSubview:self.player];
    [self.view bringSubviewToFront:self.player];
}

-(void)addMoreBall {
    
    EnemyBall *addmoreClass = [[EnemyBall alloc]init];
    [self.view addSubview: addmoreClass.addEnemyBallFromClass];
}

-(void)onTimer {
    
    [self checkCollision];

    NSArray *subviews = [self.view subviews];
    
    for (UIView *view in subviews) {
        if ([view isKindOfClass: [UIImageView class]] && (view != self.player)) {
            
            view.center = CGPointMake(view.center.x + pos.x, view.center.y + pos.y);        //enemyball movement
            
            if (view.center.x > self.view.frame.size.width || view.center.x < 0) {
                pos.x = -pos.x;
            }
        
            if (view.center.y > self.view.frame.size.height || view.center.y <0) {
                pos.y = - pos.y;
            }
        }
    }
}

-(void)checkCollision {
    
    NSArray *subview = [self.view subviews];
    
    //check collision for all the enemy balls
    for (UIView *viewInSub in subview) {
        
        if ([viewInSub isKindOfClass:[UIImageView class]] && (viewInSub != self.player)) {
            
            if (CGRectIntersectsRect(self.player.frame, viewInSub.frame)) {                  //Perform these once player intersects with any enemy
                
                [randomMain invalidate];
                [startButton setHidden:NO];
                [self.motionManager stopAccelerometerUpdates];
                [addMoreBall invalidate];
                [self removeSubView];
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Lost" message:@"You are hit. Try Again!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }
    }
}


-(void)removeSubView {
    NSArray *subViews = [self.view subviews];
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIImageView class]]) { //remove enemy and player balls. Once start button is pressed, player ball will be added in.
                [view removeFromSuperview];
        }
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
                int intPlayerNewPosX = (int)(self.player.center.x + valueX);
                int intPlayerNewPosY = (int)(self.player.center.y + valueY);
                
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
                self.player.center = playerNewPoint;
                
            });
        }];
    } else{
        NSLog(@"Not Active.");
    }
}

//detects the finger movement
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *myTouch = [[event allTouches]anyObject];
    self.player.center = [myTouch locationInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
