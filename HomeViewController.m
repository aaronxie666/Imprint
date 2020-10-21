//
//  HomeViewController.m
//  Imprint
//
//  Created by Geoff Baker on 14/09/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import "HomeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SWRevealViewController.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import "Reachability.h"
#import "MBProgressHUD.h"
//#import <Parse/Parse.h>
#import "Flurry.h"
#import "ImprintDatabase.h"

@interface HomeViewController ()
//Reachability
//@property (nonatomic) Reachability *hostReachability;
//@property (nonatomic) Reachability *internetReachability;
//@property (nonatomic) Reachability *wifiReachability;
@end

@implementation HomeViewController{
    //Deside the orientation of the device
    UIDeviceOrientation Orientation;
    
    
    UIView *tmpView;
    UIView *popUpView;
    UIImageView *profilePicture;
    UIImage *selectedProfileImage;
    UIScrollView *sideScroller;
    UIScrollView *pageScroller;
    NSUserDefaults *user;
    UIButton *findParksButton;
    //    CLLocationManager *locationManager;
    int iteration;
    bool refreshView;
    bool userIsOnOverlay;
    bool libraryPicked;
    bool viewHasFinishedLoading;
    bool isFindingNearestParkOn;
    int distanceMovedScroll;
    
    
    IBOutlet UITextField *userTextField;
    
    //Loading Animation
    MBProgressHUD *Hud;
    UIImageView *activityImageView;
    UIActivityIndicatorView *activityView;
    
    UIImageView *activePageView;
    
    //PFObjects
    //    PFObject *selectedMatchObject;
    //    PFObject *selectedOpponent;
    //    PFObject *achievementsObject;
    //    NSMutableArray *locationsObj;
    
    //AnimationImage
    UIImageView *glowImageView;
    
    //NEW
    NSString *URLString;
    UIButton *dailyReward;
    
    int videoCount;
    
    //Graph
    int firstVotes;
    int secondVotes;
    int thirdVotes;
    int forthVotes;
    int fifthVotes;
    
    int x;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    userIsOnOverlay = NO;
    viewHasFinishedLoading = NO;
    // Do any additional setup after loading the view.
    
    
    //Decide the orientation of the device
    Orientation = [[UIDevice currentDevice]orientation];
    
    
    /*
     Observer For App Background Handling
     */
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    
    
    //Header
    [self.navigationController.navigationBar  setBarTintColor:[UIColor colorWithRed:172/255.0f
                                                                              green:200/255.0f
                                                                               blue:55/255.0f
                                                                              alpha:1.0f]];
    [_sidebarButton setEnabled:NO];
    [_sidebarButton setTintColor: [UIColor clearColor]];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    UIImageView *navigationImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 38)];
    if(Orientation == UIDeviceOrientationLandscapeRight || Orientation == UIDeviceOrientationLandscapeLeft){
        if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
        {
            [navigationImage setFrame:CGRectMake(-30, -12, 170, 53)];
        }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
        {
            [navigationImage setFrame:CGRectMake(-30, -12, 170, 53)];
        }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
        {
            [navigationImage setFrame:CGRectMake(-30, -12, 170, 53)];
        } else {
            [navigationImage setFrame:CGRectMake(-30, -12, 100, 28)];
        }
        
    }
    navigationImage.image=[UIImage imageNamed:@"logo"];
    
    UIImageView *workaroundImageView = [[UIImageView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    }else{
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    }
    
    [workaroundImageView addSubview:navigationImage];
    self.navigationItem.titleView=workaroundImageView;
    self.navigationItem.titleView.center = self.view.center;
    
    
    
    // Build your regular UIBarButtonItem with Custom View
    UIImage *image = [UIImage imageNamed:@"ic_menu"];
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0, 0, 5, 5);
    leftBarButton.imageEdgeInsets = UIEdgeInsetsMake(8, 10, 8, 10);
    [leftBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchDown];
    [leftBarButton setImage:image forState:UIControlStateNormal];
    
    // Make BarButton Item
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    self.navigationItem.leftBarButtonItem = navLeftButton;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //    BackgroundImage
    UIImageView *background = [[UIImageView alloc] init];
    background.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [background setBackgroundColor:[UIColor whiteColor]];
    background.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:background];
    //
    
    
    [self loadParseContent];
}

-(void)loadParseContent{
    // Create the UI Scroll View
    
    //Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //Hud.mode = MBProgressHUDModeCustomView;
    //Hud.labelText = @"Loading";
    
    //Loading Animation UIImageView
    
    //Create the first status image and the indicator view
    UIImage *statusImage = [UIImage imageNamed:@"load_anim000"];
    activityImageView = [[UIImageView alloc]
                         initWithImage:statusImage];
    
    
    //Add more images which will be used for the animation
    activityImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"load_anim000"],
                                         [UIImage imageNamed:@"load_anim001"],
                                         [UIImage imageNamed:@"load_anim002"],
                                         [UIImage imageNamed:@"load_anim003"],
                                         [UIImage imageNamed:@"load_anim004"],
                                         [UIImage imageNamed:@"load_anim005"],
                                         [UIImage imageNamed:@"load_anim006"],
                                         [UIImage imageNamed:@"load_anim007"],
                                         [UIImage imageNamed:@"load_anim008"],
                                         [UIImage imageNamed:@"load_anim009"],
                                         nil];
    
    //Set the duration of the animation (play with it
    //until it looks nice for you)
    activityImageView.animationDuration = 0.5;
    
    activityImageView.animationRepeatCount = 0;
    
    
    //Position the activity image view somewhere in
    //the middle of your current view
    activityImageView.frame = CGRectMake(
                                         self.view.frame.size.width/2
                                         -25,
                                         self.view.frame.size.height/2
                                         -25,
                                         50,
                                         50);
    
    //Start the animation
    //[activityImageView startAnimating];
    
    
    //Add your custom activity indicator to your current view
    //[self.view addSubview:activityImageView];
    
    // Add stuff to view here
    //Hud.customView = activityImageView;
    
    user = [NSUserDefaults standardUserDefaults];
    NSString *username = [user stringForKey:@"userEmail"];
    NSString *password = [user stringForKey:@"userPassword"];
    
    if(username == nil){
        [self showLoginView];
    }else{
        if(Orientation == UIDeviceOrientationPortrait){
            [self loadUser];
        }else if(Orientation == UIDeviceOrientationLandscapeLeft || Orientation ==  UIDeviceOrientationLandscapeRight){
            [self loadUserHorizontal];
            
        } else {
           [self loadUser];
        }
        //[Hud removeFromSuperview];
    }
    
}


-(void)showLoginView{
    SWRevealViewController *LoginControl = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"InitialLogin"];
    
    [self.navigationController pushViewController:LoginControl animated:NO];
}

-(void)showLoading
{
    Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeCustomView;
    Hud.labelText = NSLocalizedString(@"Loading", nil);
    //Start the animation
    [activityImageView startAnimating];
    
    
    //Add your custom activity indicator to your current view
    [self.view addSubview:activityImageView];
    Hud.customView = activityImageView;
}





-(void)loadUserHorizontal{
    //Profile Group View
    UIView *header = [[UIView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 80);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 80);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 80);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        header.frame = CGRectMake(0, 70, self.view.frame.size.width, 80);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 80);
    } else {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 80);
    }
    [header setBackgroundColor:[UIColor colorWithRed:192/255.0f
                                               green:29/255.0f
                                                blue:74/255.0f
                                               alpha:1.0f]];
    [self.view addSubview:header];
    
    UIImageView *headImg = [[UIImageView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        headImg.frame = CGRectMake(220, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        headImg.frame = CGRectMake(220, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        headImg.frame = CGRectMake(220, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        headImg.frame = CGRectMake(220, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        headImg.frame = CGRectMake(220, 20, 50, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        headImg.frame = CGRectMake(220, 20, 50, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        headImg.frame = CGRectMake(220, 5, 70, 70);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        headImg.frame = CGRectMake(220, 20, 50, 50);
    } else {
        headImg.frame = CGRectMake(220, 20, 50, 50);
    }
    headImg.image = [UIImage imageNamed:@"brand-logo"];
    [header addSubview:headImg];
    
    
    UILabel *LtdLable = [[UILabel alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        LtdLable.frame = CGRectMake(300, 10, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        LtdLable.frame = CGRectMake(300, 10, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        LtdLable.frame = CGRectMake(300, 10, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        LtdLable.frame = CGRectMake(300, 10, self.view.frame.size.width, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        LtdLable.frame = CGRectMake(300, 10, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        LtdLable.frame = CGRectMake(300, 10, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        LtdLable.frame = CGRectMake(350, 20, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        LtdLable.frame = CGRectMake(300, 10, self.view.frame.size.width, 50);
    } else {
        LtdLable.frame = CGRectMake(300, 10, self.view.frame.size.width, 50);
    }
    /*if([[user stringForKey:@"userEmail"] isEqualToString:@"NBourne"]){
     LtdLable.text = @"Imprint Business Systems Ltd";
     }else{
     LtdLable.text = @"Pretend Printers Ltd";
     }*/
    
    //    LtdLable.text = @"Pretend Printers Ltd";
    LtdLable.textColor = [UIColor whiteColor];
    [LtdLable setFont:[UIFont boldSystemFontOfSize:16]];
    LtdLable.textAlignment = NSTextAlignmentLeft;
    [header addSubview:LtdLable];
    
    UILabel *userLable = [[UILabel alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        userLable.frame = CGRectMake(700, 20, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    } else {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    }
    userLable.text = [NSString stringWithFormat:@"Welcome %@", [user stringForKey:@"userEmail"]];
    [userLable setFont:[UIFont boldSystemFontOfSize:16]];
    userLable.textColor = [UIColor whiteColor];
    userLable.textAlignment = NSTextAlignmentLeft;
    [header addSubview:userLable];
    
    
    
    UIView *mainPart = [[UIView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        mainPart.frame = CGRectMake(10, 170, self.view.frame.size.width, 280);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        mainPart.frame = CGRectMake(10, 170, self.view.frame.size.width, 280);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        mainPart.frame = CGRectMake(10, 170, self.view.frame.size.width, 280);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        mainPart.frame = CGRectMake(10, 170, self.view.frame.size.width, 280);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        mainPart.frame = CGRectMake(10, 170, self.view.frame.size.width, 280);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        mainPart.frame = CGRectMake(10, 170, self.view.frame.size.width, 280);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        mainPart.frame = CGRectMake(200, 230, self.view.frame.size.width-400, self.view.frame.size.height);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        mainPart.frame = CGRectMake(10, 170, self.view.frame.size.width, 280);
    } else {
        mainPart.frame = CGRectMake(10, 170, self.view.frame.size.width, 280);
    }
    [self.view addSubview:mainPart];
    
    
    UIButton *BusinessIntelligenceBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        BusinessIntelligenceBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [BusinessIntelligenceBtn setBackgroundImage:[UIImage imageNamed:@"btn_business-intel"] forState:UIControlStateNormal];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        BusinessIntelligenceBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [BusinessIntelligenceBtn setBackgroundImage:[UIImage imageNamed:@"btn_business-intel"] forState:UIControlStateNormal];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        BusinessIntelligenceBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [BusinessIntelligenceBtn setBackgroundImage:[UIImage imageNamed:@"btn_business-intel"] forState:UIControlStateNormal];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        BusinessIntelligenceBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [BusinessIntelligenceBtn setBackgroundImage:[UIImage imageNamed:@"btn_business-intel"] forState:UIControlStateNormal];
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        BusinessIntelligenceBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [BusinessIntelligenceBtn setBackgroundImage:[UIImage imageNamed:@"btn_business-intel"] forState:UIControlStateNormal];
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        BusinessIntelligenceBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [BusinessIntelligenceBtn setBackgroundImage:[UIImage imageNamed:@"btn_business-intel_ipad"] forState:UIControlStateNormal];
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        BusinessIntelligenceBtn.frame = CGRectMake(0, 0, (self.view.frame.size.width-400)/2, (self.view.frame.size.height-300)/2);
        [BusinessIntelligenceBtn setBackgroundImage:[UIImage imageNamed:@"btn_business-intel_ipad"] forState:UIControlStateNormal];
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        BusinessIntelligenceBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [BusinessIntelligenceBtn setBackgroundImage:[UIImage imageNamed:@"btn_business-intel_ipad"] forState:UIControlStateNormal];
    } else {
        BusinessIntelligenceBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [BusinessIntelligenceBtn setBackgroundImage:[UIImage imageNamed:@"btn_business-intel_ipad"] forState:UIControlStateNormal];
    }
    [BusinessIntelligenceBtn addTarget:self action:@selector(tapBusinessIntelligenceBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:BusinessIntelligenceBtn];
    
    UIButton *factoryViewBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        factoryViewBtn.frame = CGRectMake(self.view.frame.size.width/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [factoryViewBtn setBackgroundImage:[UIImage imageNamed:@"btn_factory-view"] forState:UIControlStateNormal];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        factoryViewBtn.frame = CGRectMake(self.view.frame.size.width/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [factoryViewBtn setBackgroundImage:[UIImage imageNamed:@"btn_factory-view"] forState:UIControlStateNormal];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        factoryViewBtn.frame = CGRectMake(self.view.frame.size.width/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [factoryViewBtn setBackgroundImage:[UIImage imageNamed:@"btn_factory-view"] forState:UIControlStateNormal];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        factoryViewBtn.frame = CGRectMake(self.view.frame.size.width/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [factoryViewBtn setBackgroundImage:[UIImage imageNamed:@"btn_factory-view"] forState:UIControlStateNormal];
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        factoryViewBtn.frame = CGRectMake(self.view.frame.size.width/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [factoryViewBtn setBackgroundImage:[UIImage imageNamed:@"btn_factory-view"] forState:UIControlStateNormal];
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        factoryViewBtn.frame = CGRectMake(self.view.frame.size.width/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [factoryViewBtn setBackgroundImage:[UIImage imageNamed:@"btn_factory-view"] forState:UIControlStateNormal];
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        factoryViewBtn.frame = CGRectMake((self.view.frame.size.width-400)/2+10, 0, (self.view.frame.size.width-400)/2, (self.view.frame.size.height-300)/2);
        [factoryViewBtn setBackgroundImage:[UIImage imageNamed:@"btn_factory-view_ipad"] forState:UIControlStateNormal];
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        factoryViewBtn.frame = CGRectMake(self.view.frame.size.width/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [factoryViewBtn setBackgroundImage:[UIImage imageNamed:@"btn_factory-view"] forState:UIControlStateNormal];
    } else {
        factoryViewBtn.frame = CGRectMake(self.view.frame.size.width/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [factoryViewBtn setBackgroundImage:[UIImage imageNamed:@"btn_factory-view"] forState:UIControlStateNormal];
    }
    [factoryViewBtn addTarget:self action:@selector(tapfactoryViewBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:factoryViewBtn];
    
    UIButton *salesBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        salesBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [salesBtn setBackgroundImage:[UIImage imageNamed:@"btn_quotehub"] forState:UIControlStateNormal];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        salesBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [salesBtn setBackgroundImage:[UIImage imageNamed:@"btn_quotehub"] forState:UIControlStateNormal];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        salesBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [salesBtn setBackgroundImage:[UIImage imageNamed:@"btn_quotehub"] forState:UIControlStateNormal];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        salesBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [salesBtn setBackgroundImage:[UIImage imageNamed:@"btn_quotehub"] forState:UIControlStateNormal];
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        salesBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [salesBtn setBackgroundImage:[UIImage imageNamed:@"btn_quotehub"] forState:UIControlStateNormal];
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        salesBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [salesBtn setBackgroundImage:[UIImage imageNamed:@"btn_quotehub"] forState:UIControlStateNormal];
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        salesBtn.frame = CGRectMake(0, (self.view.frame.size.height-300)/2+10, (self.view.frame.size.width-400)/2, (self.view.frame.size.height-300)/2);
        [salesBtn setBackgroundImage:[UIImage imageNamed:@"btn_sales_ipad"] forState:UIControlStateNormal];
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        salesBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [salesBtn setBackgroundImage:[UIImage imageNamed:@"btn_quotehub"] forState:UIControlStateNormal];
    } else {
        salesBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [salesBtn setBackgroundImage:[UIImage imageNamed:@"btn_quotehub"] forState:UIControlStateNormal];
    }
    [salesBtn addTarget:self action:@selector(tapsalesBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:salesBtn];
    
    
    UIButton *Top10CrmBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        Top10CrmBtn.frame = CGRectMake(self.view.frame.size.width*3/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [Top10CrmBtn setBackgroundImage:[UIImage imageNamed:@"btn_crm"] forState:UIControlStateNormal];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        Top10CrmBtn.frame = CGRectMake(self.view.frame.size.width*3/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [Top10CrmBtn setBackgroundImage:[UIImage imageNamed:@"btn_crm"] forState:UIControlStateNormal];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        Top10CrmBtn.frame = CGRectMake(self.view.frame.size.width*3/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [Top10CrmBtn setBackgroundImage:[UIImage imageNamed:@"btn_crm"] forState:UIControlStateNormal];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        Top10CrmBtn.frame = CGRectMake(self.view.frame.size.width*3/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [Top10CrmBtn setBackgroundImage:[UIImage imageNamed:@"btn_crm"] forState:UIControlStateNormal];
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        Top10CrmBtn.frame = CGRectMake(self.view.frame.size.width*3/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [Top10CrmBtn setBackgroundImage:[UIImage imageNamed:@"btn_crm"] forState:UIControlStateNormal];
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        Top10CrmBtn.frame = CGRectMake(self.view.frame.size.width*3/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [Top10CrmBtn setBackgroundImage:[UIImage imageNamed:@"btn_crm"] forState:UIControlStateNormal];
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        Top10CrmBtn.frame = CGRectMake((self.view.frame.size.width-400)/2+10, (self.view.frame.size.height-300)/2+10, (self.view.frame.size.width-400)/2, (self.view.frame.size.height-300)/2);
        [Top10CrmBtn setBackgroundImage:[UIImage imageNamed:@"btn_crm_ipad"] forState:UIControlStateNormal];
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        Top10CrmBtn.frame = CGRectMake(self.view.frame.size.width*3/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [Top10CrmBtn setBackgroundImage:[UIImage imageNamed:@"btn_crm"] forState:UIControlStateNormal];
    } else {
        Top10CrmBtn.frame = CGRectMake(self.view.frame.size.width*3/4-15+10, 0, self.view.frame.size.width/4-15, self.view.frame.size.width/4-15);
        [Top10CrmBtn setBackgroundImage:[UIImage imageNamed:@"btn_crm"] forState:UIControlStateNormal];
    }
    [Top10CrmBtn addTarget:self action:@selector(tapTop10CrmBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:Top10CrmBtn];
    
    [self showLoading];
    ImprintDatabase *data = [[ImprintDatabase alloc]init];
    [data getCompanyDetails:nil completion:^(NSMutableArray *companyDetails, NSError *error) {
        if(!error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                LtdLable.text = [companyDetails objectAtIndex:0][@"CompanyName"];
                [Hud removeFromSuperview];
            });
        }
    }];
    
    
    //    [Hud removeFromSuperview];
    
}





-(void)loadUser{
    //Profile Group View
    UIView *header = [[UIView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        header.frame = CGRectMake(0, 60, self.view.frame.size.width, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        header.frame = CGRectMake(0, 60, self.view.frame.size.width, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        header.frame = CGRectMake(0, 60, self.view.frame.size.width, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        header.frame = CGRectMake(0, 60, self.view.frame.size.width, 80);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        header.frame = CGRectMake(0, 80, self.view.frame.size.width, 80);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        header.frame = CGRectMake(0, 80, self.view.frame.size.width, 80);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        header.frame = CGRectMake(0, 70, self.view.frame.size.width, 80);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        header.frame = CGRectMake(0, 80, self.view.frame.size.width, 80);
    } else {
        header.frame = CGRectMake(0, 80, self.view.frame.size.width, 80);
    }
    [header setBackgroundColor:[UIColor colorWithRed:192/255.0f
                                               green:29/255.0f
                                                blue:74/255.0f
                                               alpha:1.0f]];
    [self.view addSubview:header];
    
    UIImageView *headImg = [[UIImageView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        headImg.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        headImg.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        headImg.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        headImg.frame = CGRectMake(100, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        headImg.frame = CGRectMake(100, 20, 50, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        headImg.frame = CGRectMake(100, 20, 50, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        headImg.frame = CGRectMake(150, 5, 70, 70);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        headImg.frame = CGRectMake(100, 20, 50, 50);
    } else {
        headImg.frame = CGRectMake(100, 20, 50, 50);
    }
    headImg.image = [UIImage imageNamed:@"brand-logo"];
    [header addSubview:headImg];
    
    
    UILabel *LtdLable = [[UILabel alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        LtdLable.frame = CGRectMake(140, 10, 200, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        LtdLable.frame = CGRectMake(140, 10, 200, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        LtdLable.frame = CGRectMake(140, 10, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        LtdLable.frame = CGRectMake(170, 10, 200, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        LtdLable.frame = CGRectMake(170, 10, 200, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        LtdLable.frame = CGRectMake(170, 10, 200, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        LtdLable.frame = CGRectMake(250, 20, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        LtdLable.frame = CGRectMake(170, 10, 200, 50);
    } else {
        LtdLable.frame = CGRectMake(170, 10, 200, 50);
    }
    /*if([[user stringForKey:@"userEmail"] isEqualToString:@"NBourne"]){
     LtdLable.text = @"Imprint Business Systems Ltd";
     }else{
     LtdLable.text = @"Pretend Printers Ltd";
     }*/
    
    //    LtdLable.text = @"Pretend Printers Ltd";
    LtdLable.textColor = [UIColor whiteColor];
    [LtdLable setFont:[UIFont boldSystemFontOfSize:16]];
    LtdLable.textAlignment = NSTextAlignmentLeft;
    [header addSubview:LtdLable];
    
    UILabel *userLable = [[UILabel alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        userLable.frame = CGRectMake(140, 30, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        userLable.frame = CGRectMake(140, 30, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        userLable.frame = CGRectMake(140, 30, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        userLable.frame = CGRectMake(170, 30, self.view.frame.size.width, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        userLable.frame = CGRectMake(170, 30, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        userLable.frame = CGRectMake(170, 30, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        userLable.frame = CGRectMake(500, 20, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        userLable.frame = CGRectMake(170, 30, self.view.frame.size.width, 50);
    } else {
        userLable.frame = CGRectMake(170, 30, self.view.frame.size.width, 50);
    }
    userLable.text = [NSString stringWithFormat:@"Welcome %@", [user stringForKey:@"userEmail"]];
    [userLable setFont:[UIFont boldSystemFontOfSize:16]];
    userLable.textColor = [UIColor whiteColor];
    userLable.textAlignment = NSTextAlignmentLeft;
    [header addSubview:userLable];
    
    
    
    UIView *mainPart = [[UIView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        mainPart.frame = CGRectMake(10, 190, self.view.frame.size.width, 280);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        mainPart.frame = CGRectMake(10, 190, self.view.frame.size.width, 280);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        mainPart.frame = CGRectMake(10, 190, self.view.frame.size.width, 280);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        mainPart.frame = CGRectMake(10, 190, self.view.frame.size.width, 280);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        mainPart.frame = CGRectMake(10, 210, self.view.frame.size.width, 280);
    } else {
        mainPart.frame = CGRectMake(10, 210, self.view.frame.size.width, 280);
    }
    [self.view addSubview:mainPart];
    
    
    UIButton *BusinessIntelligenceBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        BusinessIntelligenceBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        BusinessIntelligenceBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        BusinessIntelligenceBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        BusinessIntelligenceBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        BusinessIntelligenceBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    } else {
        BusinessIntelligenceBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    [BusinessIntelligenceBtn setBackgroundImage:[UIImage imageNamed:@"btn_business-intel"] forState:UIControlStateNormal];
    [BusinessIntelligenceBtn addTarget:self action:@selector(tapBusinessIntelligenceBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:BusinessIntelligenceBtn];
    
    UIButton *factoryViewBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        factoryViewBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, 0, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        factoryViewBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, 0, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        factoryViewBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, 0, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        factoryViewBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, 0, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        factoryViewBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, 0, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    } else {
        factoryViewBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, 0, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    [factoryViewBtn setBackgroundImage:[UIImage imageNamed:@"btn_factory-view"] forState:UIControlStateNormal];
    [factoryViewBtn addTarget:self action:@selector(tapfactoryViewBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:factoryViewBtn];
    
    UIButton *salesBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        salesBtn.frame = CGRectMake(0, self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        salesBtn.frame = CGRectMake(0, self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        salesBtn.frame = CGRectMake(0, self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        salesBtn.frame = CGRectMake(0, self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        salesBtn.frame = CGRectMake(0, self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    } else {
        salesBtn.frame = CGRectMake(0, self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    [salesBtn setBackgroundImage:[UIImage imageNamed:@"btn_quotehub"] forState:UIControlStateNormal];
    [salesBtn addTarget:self action:@selector(tapsalesBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:salesBtn];
    
    
    UIButton *Top10CrmBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        Top10CrmBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        Top10CrmBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        Top10CrmBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        Top10CrmBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        Top10CrmBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    } else {
        Top10CrmBtn.frame = CGRectMake(self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15+10, self.view.frame.size.width/2-15, self.view.frame.size.width/2-15);
    }
    [Top10CrmBtn setBackgroundImage:[UIImage imageNamed:@"btn_crm"] forState:UIControlStateNormal];
    [Top10CrmBtn addTarget:self action:@selector(tapTop10CrmBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:Top10CrmBtn];
    
    [self showLoading];
    ImprintDatabase *data = [[ImprintDatabase alloc]init];
    [data getCompanyDetails:nil completion:^(NSMutableArray *companyDetails, NSError *error) {
        if(!error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                LtdLable.text = [companyDetails objectAtIndex:0][@"CompanyName"];
                [Hud removeFromSuperview];
            });
        }
    }];
    
    
    //    [Hud removeFromSuperview];
}




-(void) tapBusinessIntelligenceBtn{
    [self showLoading];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"BusinessIntelligence"];
    [self.navigationController pushViewController:vc animated:NO];
    [Hud removeFromSuperview];
}


-(void)tapfactoryViewBtn{
    [self showLoading];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"FactoryView"];
    [self.navigationController pushViewController:vc animated:NO];
    [Hud removeFromSuperview];
}


-(void)tapsalesBtn{
    
}

-(void)tapTop10CrmBtn{
    [self showLoading];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"CRM"];
    [self.navigationController pushViewController:vc animated:NO];
    [Hud removeFromSuperview];
}

-(void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:
            [self viewDidLoad];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            [self viewDidLoad];
            break;
        case UIDeviceOrientationLandscapeRight:
            [self viewDidLoad];
            break;
            
        default:
            break;
    };
}





@end
