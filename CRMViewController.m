//
//  CRMViewController.m
//  Imprint
//
//  Created by Geoff Baker on 11/12/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import "CRMViewController.h"
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
#import "CRMDetailedView.h"

@interface CRMViewController ()

@end

@implementation CRMViewController {
    //Decide the orientation of the device
    UIDeviceOrientation Orientation;
    NSUserDefaults *defaults;
    
    //ColourCodes
    NSDictionary *jobColourCodes;
    NSDictionary *estColourCodes;
    NSDictionary *custColourCodes;
    
    //Buttons
    UIButton *filterDateBtn;
    UIButton *contactsBtn;
    UIButton *alertsBtn;
    
    //Overlays
    UIView *overlay;
    UIView *filterOverlay;
    UIView *contactsOverlay;
    UIView *alertsOverlay;
    
    //filter by date
    NSDate *startDate;
    UITextField *startDateSelectionField;
    NSDate *endDate;
    UITextField *endDateSelectionField;
    BOOL filterActive;
    
    NSDictionary *customerData;
    
    //Search Results view
    UIView *searchMainView;
    UIScrollView *searchResults;
    BOOL shouldBeginEditing;
    
    /*
    UIView *searchOverlay;
    UIPickerView *linePicker;
    NSMutableArray *pickerData;
     */
    
    //Display customer results and tab buttons
    UILabel *BILable;
    UIView *customerDataMainView;
    UIScrollView *customerResults;
    UIImageView *tabBar;
    UIButton *jobsTabBtn;
    UIButton *estimateTabBtn;
    UIButton *activityTabBtn;
    
    //Loading Animation
    MBProgressHUD *Hud;
    UIImageView *activityImageView;
    UIActivityIndicatorView *activityView;
    
    NSString *customerCode;
    NSString *reference;
    NSDictionary *customerHeader;
    NSDictionary *customerDetails;
}
@synthesize searchBar;
int activeTab = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    defaults = [NSUserDefaults standardUserDefaults];
    
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
            [navigationImage setFrame:CGRectMake(25, 4, 100, 28)];
        }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
        {
            [navigationImage setFrame:CGRectMake(-30, -12, 170, 53)];
        }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
        {
            [navigationImage setFrame:CGRectMake(25, 4, 100, 28)];
        }else{
            [navigationImage setFrame:CGRectMake(25, 4, 100, 28)];
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
    } else if ([[UIScreen mainScreen] bounds].size.height >= 812) //iPhone X size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    } else {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    }
    
    [workaroundImageView addSubview:navigationImage];
    self.navigationItem.titleView=workaroundImageView;
    self.navigationItem.titleView.center = self.view.center;
    
    // Build your regular UIBarButtonItem with Custom View
    UIImage *image = [UIImage imageNamed:@"ic_back"];
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0, 0, 5, 5);
    leftBarButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 30);
    [leftBarButton addTarget:self action:@selector(popViewControllerWithAnimation) forControlEvents:UIControlEventTouchDown];
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
    
    [self loadParseContent];
}

-(void) loadParseContent{
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
    [activityImageView startAnimating];
    
    //Load Colour Codes
    [self loadColourCodes];
    
    if(Orientation == UIDeviceOrientationPortrait){
        [self loadUser];
    }else if(Orientation == UIDeviceOrientationLandscapeLeft || Orientation ==  UIDeviceOrientationLandscapeRight){
        //[self loadUserHorizontal];
        
    } else {
        [self loadUser];
    }
    //[Hud removeFromSuperview];
}

-(void)loadColourCodes {
    ImprintDatabase *data = [[ImprintDatabase alloc]init];
    [data getJobColourCodes:nil completion:^(NSDictionary *JobColourCodes, NSError *error) {
        if(!error)
        {
            self->jobColourCodes = JobColourCodes[@"JobStatusItems"];
            //NSLog(@"%@", self->jobColourCodes);
        }
    }];
    
    ImprintDatabase *data1 = [[ImprintDatabase alloc]init];
    [data1 getEstimateColourCodes:nil completion:^(NSDictionary *EstimateColourCodes, NSError *error) {
        if(!error)
        {
            self->estColourCodes = EstimateColourCodes;
           //NSLog(@"%@", self->estColourCodes);
        }
    }];
}

-(void)loadUser{
    
    //Profile Group View
    UIView *header = [[UIView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
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
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        headImg.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        headImg.frame = CGRectMake(70, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        headImg.frame = CGRectMake(70, 20, 50, 50);
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
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        LtdLable.frame = CGRectMake(140, 10, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        LtdLable.frame = CGRectMake(140, 10, self.view.frame.size.width, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        LtdLable.frame = CGRectMake(140, 10, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        LtdLable.frame = CGRectMake(170, 10, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        LtdLable.frame = CGRectMake(250, 20, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        LtdLable.frame = CGRectMake(170, 10, self.view.frame.size.width, 50);
    } else {
        LtdLable.frame = CGRectMake(170, 10, self.view.frame.size.width, 50);
    }
    ImprintDatabase *data = [[ImprintDatabase alloc]init];
    LtdLable.textAlignment = NSTextAlignmentLeft;
    [LtdLable setFont:[UIFont boldSystemFontOfSize:16]];
    [data getCompanyDetails:nil completion:^(NSMutableArray *companyDetails, NSError *error) {
        if(!error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                LtdLable.text = [companyDetails objectAtIndex:0][@"CompanyName"];
            });
        }
    }];
    
    
    //LtdLable.text = @"Pretend Printers Ltd";
    LtdLable.textColor = [UIColor whiteColor];
    [header addSubview:LtdLable];
    
    UILabel *userLable = [[UILabel alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        userLable.frame = CGRectMake(140, 30, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        userLable.frame = CGRectMake(140, 30, self.view.frame.size.width, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        userLable.frame = CGRectMake(140, 30, self.view.frame.size.width, 50);
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
    userLable.text = [NSString stringWithFormat:@"Welcome %@", [defaults stringForKey:@"userEmail"]];
    [userLable setFont:[UIFont boldSystemFontOfSize:16]];
    userLable.textColor = [UIColor whiteColor];
    userLable.textAlignment = NSTextAlignmentLeft;
    [header addSubview:userLable];
    
    BILable = [[UILabel alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        BILable.frame = CGRectMake(0, 00, self.view.frame.size.width, 40);
        [BILable setCenter:CGPointMake(self.view.frame.size.width / 2, 155)];
        BILable.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:22];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        BILable.frame = CGRectMake(0, 150, self.view.frame.size.width, 20);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        BILable.frame = CGRectMake(0, 170, self.view.frame.size.width, 20);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        BILable.frame = CGRectMake(0, 170, self.view.frame.size.width, 20);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        BILable.frame = CGRectMake(200, 190, self.view.frame.size.width-400, 20);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        BILable.frame = CGRectMake(0, 170, self.view.frame.size.width, 20);
    } else {
        BILable.frame = CGRectMake(0, 170, self.view.frame.size.width, 20);
    }
    BILable.textAlignment = NSTextAlignmentCenter;
    BILable.text = [NSString stringWithFormat:@"CRM"];
    BILable.textColor = [UIColor colorWithRed:102/255.0f
                                             green:102/255.0f
                                              blue:102/255.0f
                                             alpha:1.0f];
    [self.view addSubview:BILable];
    
    searchBar = [[UISearchBar alloc] init];
    
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        searchBar.frame = CGRectMake(10, 177, 210, 37);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        searchBar.frame = CGRectMake(20, 200, 200, 40);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        searchBar.frame = CGRectMake(20, 200, 200, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        searchBar.frame = CGRectMake(20, 200, 200, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        searchBar.frame = CGRectMake(20, 200, 200, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        searchBar.frame = CGRectMake(20, 200, 200, 40);
    } else {
        searchBar.frame = CGRectMake(20, 200, 200, 40);
    }
    searchBar.barTintColor = [UIColor colorWithRed:226/255.0f
                                             green:213/255.0f
                                              blue:221/255.0f
                                             alpha:1.0f];
    searchBar.layer.borderWidth = 2;
    searchBar.layer.cornerRadius = 4;
    searchBar.layer.masksToBounds = true;
    searchBar.layer.borderColor = [[UIColor colorWithRed:192/255.0f
                                                   green:29/255.0f
                                                    blue:74/255.0f
                                                   alpha:1.0f] CGColor];
    UITextField *searchField = [searchBar valueForKey:@"searchField"];
    [searchBar setPlaceholder:@"Search"];
    // To change background color
    searchField.backgroundColor = [UIColor colorWithRed:226/255.0f
                                                  green:213/255.0f
                                                   blue:221/255.0f
                                                  alpha:1.0f];
    searchBar.delegate = self;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [searchBar setReturnKeyType:UIReturnKeyDone];
    [self.view addSubview:searchBar];
    
    shouldBeginEditing = YES;
    
    /**
    UITextField *searchBar = [[UITextField alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        searchBar.frame = CGRectMake(10, 175, 210, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        searchBar.frame = CGRectMake(20, 200, 200, 40);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        searchBar.frame = CGRectMake(20, 200, 200, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        searchBar.frame = CGRectMake(20, 200, 200, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        searchBar.frame = CGRectMake(20, 200, 200, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        searchBar.frame = CGRectMake(20, 200, 200, 40);
    } else {
        searchBar.frame = CGRectMake(20, 200, 200, 40);
    }
    [searchBar setDisabledBackground:[UIImage imageNamed:@"searchbar"]];
    //[searchBar setPlaceholder:[NSString stringWithFormat:@"Search"]];
    [searchBar setBackground:[UIImage imageNamed:@"searchbar_2"]];
    //[searchBar setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:searchBar];
     **/
    
    filterDateBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        filterDateBtn.frame = CGRectMake(225, 172.5, 45, 45);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        filterDateBtn.frame = CGRectMake(230, 180, 40, 40);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        filterDateBtn.frame = CGRectMake(230, 180, 40, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        filterDateBtn.frame = CGRectMake(230, 180, 40, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        filterDateBtn.frame = CGRectMake(230, 180, 40, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        filterDateBtn.frame = CGRectMake(230, 180, 40, 40);
    } else {
        filterDateBtn.frame = CGRectMake(230, 180, 40, 40);
    }
    [filterDateBtn setBackgroundImage:[UIImage imageNamed:@"btn_filterdate"] forState:UIControlStateNormal];
    [filterDateBtn addTarget:self action:@selector(displayFilterOverlay) forControlEvents:UIControlEventTouchDown];
    [filterDateBtn setEnabled:NO];
    [self.view addSubview:filterDateBtn];
    
    contactsBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        contactsBtn.frame = CGRectMake(270, 172.5, 45, 45);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        contactsBtn.frame = CGRectMake(230, 180, 40, 40);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        contactsBtn.frame = CGRectMake(230, 180, 40, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        contactsBtn.frame = CGRectMake(230, 180, 40, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        contactsBtn.frame = CGRectMake(230, 180, 40, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        contactsBtn.frame = CGRectMake(230, 180, 40, 40);
    } else {
        contactsBtn.frame = CGRectMake(230, 180, 40, 40);
    }
    [contactsBtn setBackgroundImage:[UIImage imageNamed:@"btn_contactinfo"] forState:UIControlStateNormal];
    [contactsBtn addTarget:self action:@selector(displayContactsOverlay) forControlEvents:UIControlEventTouchDown];
    [contactsBtn setEnabled:NO];
    [self.view addSubview:contactsBtn];
    
    alertsBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        alertsBtn.frame = CGRectMake(315, 172.5, 45, 45);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        alertsBtn.frame = CGRectMake(230, 180, 40, 40);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        alertsBtn.frame = CGRectMake(230, 180, 40, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        alertsBtn.frame = CGRectMake(230, 180, 40, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        alertsBtn.frame = CGRectMake(230, 180, 40, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        alertsBtn.frame = CGRectMake(230, 180, 40, 40);
    } else {
        alertsBtn.frame = CGRectMake(230, 180, 40, 40);
    }
    [alertsBtn setBackgroundImage:[UIImage imageNamed:@"btn_alerts"] forState:UIControlStateNormal];
    //[alertsBtn addTarget:self action:@selector(createNewCRMActivity) forControlEvents:UIControlEventTouchDown];
    [alertsBtn addTarget:self action:@selector(displayAlertsOverlay) forControlEvents:UIControlEventTouchDown];
    [alertsBtn setEnabled:NO];
    [self.view addSubview:alertsBtn];
    
    customerDataMainView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-225)];
    //[customerDataMainView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:customerDataMainView];
    
    tabBar = [[UIImageView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        tabBar.frame = CGRectMake(5, 5, customerDataMainView.frame.size.width-10, 35);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        tabBar.frame = CGRectMake(5, 5, customerDataMainView.frame.size.width-10, 35);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        tabBar.frame = CGRectMake(5, 5, customerDataMainView.frame.size.width-10, 35);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        tabBar.frame = CGRectMake(230, 5, 40, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        tabBar.frame = CGRectMake(230, 5, 40, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        tabBar.frame = CGRectMake(230, 5, 40, 40);
    } else {
        tabBar.frame = CGRectMake(5, 5, customerDataMainView.frame.size.width-10, 35);
    }
    [customerDataMainView addSubview:tabBar];
    
    jobsTabBtn = [[UIButton alloc] initWithFrame:CGRectMake(5,5, tabBar.frame.size.width/3, tabBar.frame.size.height)];
    [jobsTabBtn addTarget:self action:@selector(tapJobsBtn) forControlEvents:UIControlEventTouchUpInside];
    //[jobsTabBtn setBackgroundColor:[UIColor blackColor]];
    jobsTabBtn.hidden = YES;
    [customerDataMainView addSubview:jobsTabBtn];
    
    estimateTabBtn = [[UIButton alloc] initWithFrame:CGRectMake(tabBar.frame.size.width/3 + 5, 5, tabBar.frame.size.width/3, tabBar.frame.size.height)];
    [estimateTabBtn addTarget:self action:@selector(tapEstBtn) forControlEvents:UIControlEventTouchDown];
    //[estimateTabBtn setBackgroundColor:[UIColor whiteColor]];
    [customerDataMainView addSubview:estimateTabBtn];
    
    activityTabBtn = [[UIButton alloc] initWithFrame:CGRectMake(tabBar.frame.size.width/3 * 2 + 5, 5, tabBar.frame.size.width/3, tabBar.frame.size.height)];
    [activityTabBtn addTarget:self action:@selector(tapActBtn) forControlEvents:UIControlEventTouchDown];
    //[activityTabBtn setBackgroundColor:[UIColor blackColor]];
    [customerDataMainView addSubview:activityTabBtn];
    
    searchMainView = [[UIScrollView alloc] init];
    searchMainView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-225);
    [self.view addSubview:searchMainView];
}

-(void)tapJobsBtn {
    [customerResults removeFromSuperview];
    [self switchTabs:0];
}

-(void)tapEstBtn {
    [customerResults removeFromSuperview];
    [self switchTabs:1];
}

-(void)tapActBtn {
    [customerResults removeFromSuperview];
    [self switchTabs:2];
}

-(void)switchTabs:(int)tab {
    if (tab == 0) {
        activeTab = 0;
        tabBar.image = [UIImage imageNamed:@"section_jobs"];
        [self loadTabData];
        jobsTabBtn.hidden = YES;
        estimateTabBtn.hidden = NO;
        activityTabBtn.hidden = NO;
    } else if (tab == 1) {
        activeTab = 1;
        tabBar.image = [UIImage imageNamed:@"section_estimates"];
        [self loadTabData];
        jobsTabBtn.hidden = NO;
        estimateTabBtn.hidden = YES;
        activityTabBtn.hidden = NO;
    } else if (tab == 2) {
        activeTab = 2;
        tabBar.image = [UIImage imageNamed:@"section_activity"];
        [self loadTabData];
        jobsTabBtn.hidden = NO;
        estimateTabBtn.hidden = NO;
        activityTabBtn.hidden = YES;
    } else {
        activeTab = 0;
        tabBar.image = [UIImage imageNamed:@"section_jobs"];
        [self loadTabData];
        jobsTabBtn.hidden = YES;
        estimateTabBtn.hidden = NO;
        activityTabBtn.hidden = NO;
    }
}

-(void)loadTabData {
    if (customerData != nil) {
        self->customerResults = [[UIScrollView alloc] init];
        if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
        {
            self->customerResults.frame = CGRectMake(2, 45, self.view.frame.size.width-4, 395);
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
        {
            self->customerResults.frame = CGRectMake(230, 180, 40, 40);
        } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
        {
            self->customerResults.frame = CGRectMake(230, 180, 40, 40);
        }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
        {
            self->customerResults.frame = CGRectMake(230, 180, 40, 40);
        }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
        {
            self->customerResults.frame = CGRectMake(230, 180, 40, 40);
        }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
        {
            self->customerResults.frame = CGRectMake(230, 180, 40, 40);
        } else {
            self->customerResults.frame = CGRectMake(230, 180, 40, 40);
        }
        //[customerResults setBackgroundColor:[UIColor blackColor]];
        [customerDataMainView addSubview:self->customerResults];
        
        NSDictionary *newList;
        NSDateFormatter *ISO8601DateFormatter = [[NSDateFormatter alloc] init];
        ISO8601DateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        ISO8601DateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        ISO8601DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        [dateFormatter setLocalizedDateFormatFromTemplate:@"dd/MM/yyyy"];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        [timeFormatter setLocalizedDateFormatFromTemplate:@"HH:mm:ss"];
        if (activeTab == 0) {
            newList = customerData[@"Jobs"];
            int searchCount = (int) [newList count];
            if(filterActive) {
                searchCount = [self filterCustomerData:0];
            }
            NSLog(@"%d", searchCount);
            
            if (searchCount != 0) {
                self->customerResults.contentSize = CGSizeMake(self.view.frame.size.width-20, 42 * searchCount);
            
                int rowHeightIndex = 0;
                
                for(NSDictionary* row in newList) {
                    BOOL display = NO;
                    NSDate *date =  [ISO8601DateFormatter dateFromString:row[@"Date"]];
                    if(filterActive) {
                        if([self date:date isBetweenDate:startDate andDate:endDate]) {
                            //NSLog(@"Filter True");
                            display = YES;
                        } else {
                            //NSLog(@"Filter False");
                            display = NO;
                        }
                    } else {
                        //NSLog(@"Display Normal");
                        display = YES;
                    }
                    
                    if(display) {
                        UIView *rowItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0 + rowHeightIndex, self->customerResults.frame.size.width, 40)];
                        //[rowItem setBackgroundColor:[UIColor blackColor]];
                        [self->customerResults addSubview:rowItem];
                        
                        UIImageView *rowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rowItem.frame.size.width, 40)];
                        rowImage.image = [UIImage imageNamed:@"btn_list"];
                        [rowItem addSubview:rowImage];
                        
                        UILabel *rowPrefix = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 45, 30)];
                        rowPrefix.text = [NSString stringWithFormat:@"%@", row[@"Position"]];
                        [rowPrefix setFont:[UIFont boldSystemFontOfSize:12]];
                        rowPrefix.textAlignment = NSTextAlignmentCenter;
                        BOOL foundColour = false;
                        for(NSDictionary* colour in jobColourCodes) {
                            if ([row[@"Status"] isEqualToString:colour[@"Code"]]) {
                                [rowPrefix setBackgroundColor:[self colorFromHexCode:colour[@"BackgroundColourHex"]]];
                                rowPrefix.textColor = [self colorFromHexCode:colour[@"TextColourHex"]];
                                //NSLog(@"FoundColour");
                                foundColour = true;
                                break;
                            }
                        }
                        if (foundColour == false) {
                            [rowPrefix setBackgroundColor:[UIColor colorWithRed:97/255.0f
                                                                          green:97/255.0f
                                                                           blue:97/255.0f
                                                                          alpha:1.0f]];
                            rowPrefix.textColor = [UIColor whiteColor];
                        }
                        [rowItem addSubview:rowPrefix];
                        
                        UILabel *rowTitle = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 175, 30)];
                        rowTitle.text = [NSString stringWithFormat:@"%@", row[@"Title"]];
                        [rowTitle setFont:[UIFont boldSystemFontOfSize:12]];
                        //rowTitle.textColor = [UIColor whiteColor];
                        rowTitle.textColor = [UIColor blackColor];
                        rowTitle.textAlignment = NSTextAlignmentLeft;
                        //[rowTitle setBackgroundColor:[UIColor blackColor]];
                        [rowItem addSubview:rowTitle];
                        
                        UILabel *jobNo = [[UILabel alloc] initWithFrame:CGRectMake(235, 5, 40, 30)];
                        jobNo.text = [NSString stringWithFormat:@"%@", row[@"JobNo"]];
                        [jobNo setFont:[UIFont systemFontOfSize:9]];
                        //[jobNo setFont:[UIFont boldSystemFontOfSize:9]];
                        //jobNo = [UIColor whiteColor];
                        jobNo.textColor = [UIColor blackColor];
                        jobNo.textAlignment = NSTextAlignmentCenter;
                        //[jobNo setBackgroundColor:[UIColor blackColor]];
                        [rowItem addSubview:jobNo];
                        
                        UILabel *rowDate = [[UILabel alloc] initWithFrame:CGRectMake(280, 5, 60, 30)];
                        rowDate.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
                        [rowDate setFont:[UIFont systemFontOfSize:10]];
                        //[rowDate setFont:[UIFont boldSystemFontOfSize:10]];
                        //rowDate.textColor = [UIColor whiteColor];
                        rowDate.textColor = [UIColor blackColor];
                        rowDate.textAlignment = NSTextAlignmentCenter;
                        //[rowDate setBackgroundColor:[UIColor blackColor]];
                        [rowItem addSubview:rowDate];
                        
                        UIButton *rowBtn = [[UIButton alloc] initWithFrame:CGRectMake(4, 3, rowItem.frame.size.width-8, 33)];
                        //[rowBtn setBackgroundColor:[UIColor blackColor]];
                        [rowBtn.layer setValue:row[@"Ref"] forKey:@"ID"];
                        [rowBtn addTarget:self action:@selector(tapRow:) forControlEvents:UIControlEventTouchUpInside];
                        [rowItem addSubview:rowBtn];
                        
                        rowHeightIndex += 42;
                    }
                }
            } else {
                NSLog(@"Empty");
                self->customerResults.contentSize = CGSizeMake(self.view.frame.size.width-20, 150);
                
                
                UILabel *emptyArrayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
                [emptyArrayLabel setCenter:CGPointMake(customerResults.frame.size.width/2, 15)];
                emptyArrayLabel.text = [NSString stringWithFormat:@"No Jobs Found"];
                [emptyArrayLabel setFont:[UIFont systemFontOfSize:20]];
                //[rowTime setFont:[UIFont boldSystemFontOfSize:10]];
                //rowTime.textColor = [UIColor whiteColor];
                emptyArrayLabel.textColor = [UIColor blackColor];
                emptyArrayLabel.textAlignment = NSTextAlignmentCenter;
                //[emptyArrayLabel setBackgroundColor:[UIColor blackColor]];
                [customerResults addSubview:emptyArrayLabel];
            }
        } else if (activeTab  == 1) {
            newList = customerData[@"Estimates"];
            int searchCount = (int) [newList count];
            if(filterActive) {
                searchCount = [self filterCustomerData:1];
            }
            NSLog(@"%d", searchCount);
            
            if(searchCount != 0) {
                self->customerResults.contentSize = CGSizeMake(self.view.frame.size.width-20, 42 * searchCount);
            
                int rowHeightIndex = 0;
            
                for(NSDictionary* row in newList) {
                    BOOL display = NO;
                    NSDate *date =  [ISO8601DateFormatter dateFromString:row[@"Date"]];
                    if(filterActive) {
                        if([self date:date isBetweenDate:startDate andDate:endDate]) {
                            //NSLog(@"Filter True");
                            display = YES;
                        } else {
                            //NSLog(@"Filter False");
                            display = NO;
                        }
                    } else {
                        //NSLog(@"Display Normal");
                        display = YES;
                    }
                    
                    if(display) {
                        UIView *rowItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0 + rowHeightIndex, self->customerResults.frame.size.width, 40)];
                        //[rowItem setBackgroundColor:[UIColor blackColor]];
                        [self->customerResults addSubview:rowItem];
                        
                        UIImageView *rowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rowItem.frame.size.width, 40)];
                        rowImage.image = [UIImage imageNamed:@"btn_list"];
                        [rowItem addSubview:rowImage];
                        
                        UILabel *rowPrefix = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 55, 30)];
                        //[rowPrefix setBackgroundColor:[UIColor greenColor]];
                        rowPrefix.text = [NSString stringWithFormat:@"%@", row[@"EstimateNo"]];
                        [rowPrefix setFont:[UIFont boldSystemFontOfSize:12]];
                        //rowPrefix.textColor = [UIColor whiteColor];
                        rowPrefix.textAlignment = NSTextAlignmentCenter;
                        BOOL foundColour = false;
                        for(NSDictionary* colour in estColourCodes) {
                            if ([row[@"Status"] isEqualToString:colour[@"Code"]]) {
                                [rowPrefix setBackgroundColor:[self colorFromHexCode:colour[@"BackgroundColourHex"]]];
                                rowPrefix.textColor = [self colorFromHexCode:colour[@"TextColourHex"]];
                                //NSLog(@"FoundColour");
                                foundColour = true;
                                break;
                            }
                        }
                        if (foundColour == false) {
                            [rowPrefix setBackgroundColor:[UIColor colorWithRed:97/255.0f
                                                                          green:97/255.0f
                                                                           blue:97/255.0f
                                                                          alpha:1.0f]];
                            rowPrefix.textColor = [UIColor whiteColor];
                        }
                        [rowItem addSubview:rowPrefix];
                        
                        UILabel *rowTitle = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 200, 30)];
                        if ([row[@"Title"] isEqualToString:@""]) {
                            rowTitle.text = [NSString stringWithFormat:@"(No Title)"];
                        } else {
                            rowTitle.text = [NSString stringWithFormat:@"%@", row[@"Title"]];
                        }
                        [rowTitle setFont:[UIFont boldSystemFontOfSize:12]];
                        //rowTitle.textColor = [UIColor whiteColor];
                        rowTitle.textColor = [UIColor blackColor];
                        rowTitle.textAlignment = NSTextAlignmentLeft;
                        //[rowTitle setBackgroundColor:[UIColor blackColor]];
                        [rowItem addSubview:rowTitle];
                        
                        UILabel *rowDate = [[UILabel alloc] initWithFrame:CGRectMake(280, 5, 60, 30)];
                        rowDate.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
                        [rowDate setFont:[UIFont systemFontOfSize:10]];
                        //[rowDate setFont:[UIFont boldSystemFontOfSize:10]];
                        //rowDate.textColor = [UIColor whiteColor];
                        rowDate.textColor = [UIColor blackColor];
                        rowDate.textAlignment = NSTextAlignmentCenter;
                        //[rowDate setBackgroundColor:[UIColor blackColor]];
                        [rowItem addSubview:rowDate];
                        
                        UIButton *rowBtn = [[UIButton alloc] initWithFrame:CGRectMake(4, 3, rowItem.frame.size.width-8, 33)];
                        //[rowBtn setBackgroundColor:[UIColor blackColor]];
                        [rowBtn.layer setValue:row[@"Ref"] forKey:@"ID"];
                        [rowBtn addTarget:self action:@selector(tapRow:) forControlEvents:UIControlEventTouchUpInside];
                        [rowItem addSubview:rowBtn];
                        
                        rowHeightIndex += 42;
                    }
                }
            } else {
                NSLog(@"Empty");
                self->customerResults.contentSize = CGSizeMake(self.view.frame.size.width-20, 150);
                
                UILabel *emptyArrayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
                [emptyArrayLabel setCenter:CGPointMake(customerResults.frame.size.width/2, 15)];
                emptyArrayLabel.text = [NSString stringWithFormat:@"No Estimates Found"];
                [emptyArrayLabel setFont:[UIFont systemFontOfSize:20]];
                //[rowTime setFont:[UIFont boldSystemFontOfSize:10]];
                //rowTime.textColor = [UIColor whiteColor];
                emptyArrayLabel.textColor = [UIColor blackColor];
                emptyArrayLabel.textAlignment = NSTextAlignmentCenter;
                //[emptyArrayLabel setBackgroundColor:[UIColor blackColor]];
                [customerResults addSubview:emptyArrayLabel];
            }
        } else if (activeTab == 2) {
            newList = customerData[@"Contacts"];
            int searchCount = (int) [newList count];
            if(filterActive) {
                searchCount = [self filterCustomerData:2];
            }
            NSLog(@"%d", searchCount);
            
            if(searchCount != 0) {
                self->customerResults.contentSize = CGSizeMake(self.view.frame.size.width-20, 42 * searchCount);
            
                int rowHeightIndex = 0;
            
                for(NSDictionary* row in newList) {
                    BOOL display = NO;
                    NSDate *date =  [ISO8601DateFormatter dateFromString:row[@"ContactDate"]];
                    if(filterActive) {
                        if([self date:date isBetweenDate:startDate andDate:endDate]) {
                            //NSLog(@"Filter True");
                            display = YES;
                        } else {
                            //NSLog(@"Filter False");
                            display = NO;
                        }
                    } else {
                        //NSLog(@"Display Normal");
                        display = YES;
                    }
                    
                    if(display) {
                        UIView *rowItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0 + rowHeightIndex, self->customerResults.frame.size.width, 40)];
                        //[rowItem setBackgroundColor:[UIColor blackColor]];
                        [self->customerResults addSubview:rowItem];
                        
                        UIImageView *rowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rowItem.frame.size.width, 40)];
                        rowImage.image = [UIImage imageNamed:@"btn_list"];
                        [rowItem addSubview:rowImage];
                        
                        UILabel *rowPrefix = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 55, 30)];
                        [rowPrefix setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                                      green:200/255.0f
                                                                       blue:55/255.0f
                                                                      alpha:1.0f]];
                        rowPrefix.text = [NSString stringWithFormat:@"%@", row[@"Ref"]];
                        [rowPrefix setFont:[UIFont boldSystemFontOfSize:12]];
                        rowPrefix.textColor = [UIColor whiteColor];
                        rowPrefix.textAlignment = NSTextAlignmentCenter;
                        [rowItem addSubview:rowPrefix];
                        
                        UILabel *rowTitle = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 155, 30)];
                        if ([row[@"Contact"] isEqualToString:@""]) {
                            rowTitle.text = [NSString stringWithFormat:@"(No Contact Name)"];
                        } else {
                            rowTitle.text = [NSString stringWithFormat:@"%@", row[@"Contact"]];
                        }
                        [rowTitle setFont:[UIFont boldSystemFontOfSize:12]];
                        //rowTitle.textColor = [UIColor whiteColor];
                        rowTitle.textColor = [UIColor blackColor];
                        rowTitle.textAlignment = NSTextAlignmentLeft;
                        //[rowTitle setBackgroundColor:[UIColor blackColor]];
                        [rowItem addSubview:rowTitle];
                        
                        UILabel *rowDate = [[UILabel alloc] initWithFrame:CGRectMake(230, 5, 60, 30)];
                        rowDate.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
                        [rowDate setFont:[UIFont systemFontOfSize:10]];
                        //[rowDate setFont:[UIFont boldSystemFontOfSize:10]];
                        //rowDate.textColor = [UIColor whiteColor];
                        rowDate.textColor = [UIColor blackColor];
                        rowDate.textAlignment = NSTextAlignmentLeft;
                        //[rowDate setBackgroundColor:[UIColor blackColor]];
                        [rowItem addSubview:rowDate];
                        
                        UILabel *rowTime = [[UILabel alloc] initWithFrame:CGRectMake(295, 5, 50, 30)];
                        NSDate *date2 =  [ISO8601DateFormatter dateFromString:row[@"ContactTime"]];
                        rowTime.text = [NSString stringWithFormat:@"%@", [timeFormatter stringFromDate:date2]];
                        [rowTime setFont:[UIFont systemFontOfSize:10]];
                        //[rowTime setFont:[UIFont boldSystemFontOfSize:10]];
                        //rowTime.textColor = [UIColor whiteColor];
                        rowTime.textColor = [UIColor blackColor];
                        rowTime.textAlignment = NSTextAlignmentLeft;
                        //[rowTime setBackgroundColor:[UIColor blackColor]];
                        [rowItem addSubview:rowTime];
                        
                        UIButton *rowBtn = [[UIButton alloc] initWithFrame:CGRectMake(4, 3, rowItem.frame.size.width-8, 33)];
                        //[rowBtn setBackgroundColor:[UIColor blackColor]];
                        [rowBtn.layer setValue:row[@"Ref"] forKey:@"ID"];
                        [rowBtn addTarget:self action:@selector(tapRow:) forControlEvents:UIControlEventTouchUpInside];
                        [rowItem addSubview:rowBtn];
                        
                        rowHeightIndex += 42;
                    }
                }
            } else {
                NSLog(@"Empty");
                self->customerResults.contentSize = CGSizeMake(self.view.frame.size.width-20, 150);
                
                UILabel *emptyArrayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
                [emptyArrayLabel setCenter:CGPointMake(customerResults.frame.size.width/2, 15)];
                emptyArrayLabel.text = [NSString stringWithFormat:@"No Activities Found"];
                [emptyArrayLabel setFont:[UIFont systemFontOfSize:20]];
                //[rowTime setFont:[UIFont boldSystemFontOfSize:10]];
                //rowTime.textColor = [UIColor whiteColor];
                emptyArrayLabel.textColor = [UIColor blackColor];
                emptyArrayLabel.textAlignment = NSTextAlignmentCenter;
                //[emptyArrayLabel setBackgroundColor:[UIColor blackColor]];
                [customerResults addSubview:emptyArrayLabel];
            }
        } else {
            NSLog(@"erorr no active tab");
        }
        [Hud removeFromSuperview];
    } else {
        NSLog(@"Customer Data Empty");
    }
    
    
}

-(UIColor *) colorFromHexCode:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBarControl {
    [searchBarControl setShowsCancelButton:YES animated:YES];

    /*
    searchOverlay = [[UIView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        searchOverlay.frame = CGRectMake(0, 350, self.view.frame.size.width, 102);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        searchOverlay.frame = CGRectMake(230, 180, 40, 40);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        searchOverlay.frame = CGRectMake(230, 180, 40, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        searchOverlay.frame = CGRectMake(230, 180, 40, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        searchOverlay.frame = CGRectMake(230, 180, 40, 40);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        searchOverlay.frame = CGRectMake(230, 180, 40, 40);
    } else {
        searchOverlay.frame = CGRectMake(230, 180, 40, 40);
    }
    [searchOverlay setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:searchOverlay];
    
    linePicker = [[UIPickerView alloc] init];
    linePicker.frame = CGRectMake(0, 0, searchOverlay.frame.size.width, searchOverlay.frame.size.height);
    linePicker.delegate = self;
    linePicker.dataSource = self;
    linePicker.showsSelectionIndicator = YES;
    //pickerData = [NSArray arrayWithObjects:@"Hello",@"Bye", nil];
    //[linePicker setBackgroundColor:[UIColor whiteColor]];
    [searchOverlay addSubview:linePicker];
    */
    
}

/*
NSString *tempInputText;
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;  // Or return whatever as you intend
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView
numberOfRowsInComponent:(NSInteger)component {
    return [pickerData count] + 1;//Or, return as suitable for you...normally we use array for dynamic
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    NSMutableArray *placeholderPicker = [[NSMutableArray alloc] initWithObjects:@"default", @"", @"Please Select An Entry", nil];
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        [pickerLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:15]];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    NSArray *searchRow = row == 0 ? placeholderPicker : [pickerData objectAtIndex:row-1];
    //NSLog(@"--------- %@",searchRow);
    pickerLabel.text = [searchRow objectAtIndex:2];
    
    return pickerLabel;
}


- (void)pickerView:(UIPickerView *)thePickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    NSMutableArray *placeholderPicker = [[NSMutableArray alloc] initWithObjects:@"default", @"", @"Please select an entry", nil];
    NSArray *searchRow = row == 0 ? placeholderPicker : [pickerData objectAtIndex:row-1];
    
    //Here, like the table view you can get the each section of each row if you've multiple sections
    NSLog(@"Selected Customer: %@. Index: %li",
          [searchRow objectAtIndex:0], (long)row);
    tempInputText = [searchRow objectAtIndex:0];
    
}
 */

-(void) clearCustomerInfo {
    customerCode = nil;
    customerData = nil;
    customerHeader = nil;
    customerDetails = nil;
}

- (void)searchBar:(UISearchBar *)searchBarObject textDidChange:(NSString *)searchText {
    
    if (![searchBar isFirstResponder]) {
        // The user clicked the [X] button while the keyboard was hidden
        shouldBeginEditing = NO;
        [filterDateBtn setEnabled:NO];
        [contactsBtn setEnabled:NO];
        [self clearCustomerInfo];
        BILable.text = [NSString stringWithFormat:@"CRM"];
        //Animate removal
        [UIView animateWithDuration:0.5f animations:^{
            self->searchMainView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-225);
            self->customerDataMainView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-225);
        } completion:^(BOOL finished) {
            [self->searchResults removeFromSuperview];
            [self->customerResults removeFromSuperview];
        }];
    } else {
        if([searchText length] != 0) {
            ImprintDatabase *data = [[ImprintDatabase alloc] init];
            [data getMagicFilter:searchText completion:^(NSDictionary *magicFilter, NSError *error) {
                if(!error)
                {
                    if ([magicFilter count] != 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //CHANGE GUI IN HERE
                            //Animate removal
                            [UIView animateWithDuration:0.5f animations:^{
                                self->customerDataMainView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-225);
                            } completion:^(BOOL finished) {
                                //Animation Completed
                            }];
                            [self->searchResults removeFromSuperview];
                            [self displaySearchResults:magicFilter];
                        });
                    }
                    /*
                     self->pickerData = [NSMutableArray new];
                     for(NSDictionary* row in magicFilter) {
                     NSArray *rowData = [NSArray arrayWithObjects:row[@"CustomerCode"],row[@"Ref"],row[@"DisplayName"], nil];
                     //NSLog(@"--- %@", rowData);
                     [self->pickerData addObject:rowData];
                     }
                     //self->pickerData = [NSArray arrayWithObjects:@"Hello",@"Bye", nil];
                     dispatch_async(dispatch_get_main_queue(), ^{
                     //CHANGE GUI IN HERE
                     tempInputText = @"default";
                     [self->linePicker reloadAllComponents];
                     [self->linePicker selectRow:0 inComponent:0 animated:true];
                     });
                     //NSLog(@"%lu", (unsigned long)[magicFilter count]);
                     //NSLog(@"--------------- %@", magicFilter)                NSLog(@"%@", self->pickerData);
                     */
                } else {
                    NSLog(@"error");
                }
            }];
        } else if ([searchText length] == 0) {
            // The user clicked the [X] button or otherwise cleared the text.
            
        }
    }
}

-(void) displaySearchResults:(NSDictionary*)magicFilter {
    int count = (int)[magicFilter count];
    searchResults = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, searchMainView.frame.size.width-10, searchMainView.frame.size.height)];
    searchResults.contentSize = CGSizeMake(searchMainView.frame.size.width-20, 42 * count +(self.view.frame.size.height-450));
    [searchMainView addSubview:searchResults];
    [UIView animateWithDuration:0.5f animations:^{
        self->searchMainView.frame = CGRectMake(0, 225, self.view.frame.size.width, self.view.frame.size.height-225);
    } completion:^(BOOL finished) {
        //Animation finished
    }];
    
    int rowHeightIndex = 0;
    
    for(NSDictionary* row in magicFilter) {
        UIView *rowItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0 + rowHeightIndex, searchResults.frame.size.width, 40)];
        //[rowItem setBackgroundColor:[UIColor blackColor]];
        [searchResults addSubview:rowItem];
        
        UIImageView *rowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rowItem.frame.size.width, 40)];
        rowImage.image = [UIImage imageNamed:@"btn_list"];
        [rowItem addSubview:rowImage];
        
        UILabel *rowTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, rowItem.frame.size.width-50, 30)];
        rowTitle.text = [NSString stringWithFormat:@"%@", row[@"DisplayName"]];
        [rowTitle setFont:[UIFont boldSystemFontOfSize:12]];
        //rowTitle.textColor = [UIColor whiteColor];
        rowTitle.textColor = [UIColor blackColor];
        rowTitle.textAlignment = NSTextAlignmentLeft;
        //[rowTitle setBackgroundColor:[UIColor blackColor]];
        [rowItem addSubview:rowTitle];
        
        UIButton *rowBtn = [[UIButton alloc] initWithFrame:CGRectMake(4, 3, rowItem.frame.size.width-8, 33)];
        //[rowBtn setBackgroundColor:[UIColor blackColor]];
        [rowBtn.layer setValue:row[@"CustomerCode"] forKey:@"CustomerCode"];
        [rowBtn.layer setValue:row[@"Title"] forKey:@"Title"];
        [rowBtn addTarget:self action:@selector(tapSearchRow:) forControlEvents:UIControlEventTouchUpInside];
        [rowItem addSubview:rowBtn];
        
        rowHeightIndex += 42;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBarObject {
    //NSLog(@"Search Clicked");
    //[searchOverlay removeFromSuperview];
    [searchBarObject resignFirstResponder];
    [searchBarObject setShowsCancelButton:NO animated:YES];
    /*
     if ([tempInputText length] == 0 || [tempInputText isEqualToString:@"default"]) {
     customerCode = searchBar.text;
     } else {
     customerCode =  tempInputText;
     searchBar.text = customerCode;
     }
     [customerResults removeFromSuperview];
     [self searchCustomer];
     */
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBarObject {
    //NSLog(@"Cancel clicked");
    //[searchOverlay removeFromSuperview];
    [searchBarObject resignFirstResponder];
    [searchBarObject setShowsCancelButton:NO animated:YES];
    if (customerCode != nil) {
        searchBar.text = customerCode;
        if (searchResults.superview) {
            [UIView animateWithDuration:0.5f animations:^{
                self->searchMainView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-225);
                self->customerDataMainView.frame = CGRectMake(0, 225, self.view.frame.size.width, self.view.frame.size.height-225);
            } completion:^(BOOL finished) {
                [self->searchResults removeFromSuperview];
            }];
        }
    } else {
        searchBar.text = @"";
        [self clearCustomerInfo];
        //Aminate removal
        if (searchResults.superview) {
            [UIView animateWithDuration:0.5f animations:^{
                self->searchMainView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-225);
            } completion:^(BOOL finished) {
                [self->searchResults removeFromSuperview];
            }];
        }
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)bar {
    // reset the shouldBeginEditing BOOL ivar to YES, but first take its value and use it to return it from the method call
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    return boolToReturn;
}

-(void) tapSearchRow:(UIButton*)sender {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    //Animate removal
    [UIView animateWithDuration:0.5f animations:^{
        self->searchMainView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-225);
    } completion:^(BOOL finished) {
        [self->searchResults removeFromSuperview];
    }];
    
    NSString *cusCode = [sender.layer valueForKey:@"CustomerCode"];
    customerCode =  cusCode;
    searchBar.text = cusCode;
    NSString *cusTitle = [sender.layer valueForKey:@"Title"];
    BILable.text = cusTitle;
    if(customerResults.superview) [customerResults removeFromSuperview];
    [self searchCustomer];
    //animation of search results
    [UIView animateWithDuration:0.5f animations:^{
        self->customerDataMainView.frame = CGRectMake(0, 225, self.view.frame.size.width, self.view.frame.size.height-225);
    } completion:^(BOOL finished) {
        //Animation finished
    }];
}

-(void)searchCustomer {
    if(customerCode != nil) {
        [self showLoading];
        NSLog(@"Search Begin");
        reference = [NSString stringWithFormat:@"STANDARD"];
        
        ImprintDatabase *data = [[ImprintDatabase alloc] init];
        [data getCustomerList:customerCode: reference completion:^(NSDictionary *customerList, NSError *error) {
            if(!error)
            {
                self->customerData = customerList;
                [self searchCustomerInfo];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self switchTabs:activeTab];
                    [self->filterDateBtn setEnabled:YES];
                });
                //
                //NSLog(@"--------------- %@", customerList);
            } else {
                NSLog(@"Error Data");
            }
        }];
    } else {
        
    }
}

-(void)searchCustomerInfo {
    ImprintDatabase *data = [[ImprintDatabase alloc] init];
    [data getCustomerDetails:customerCode completion:^(NSDictionary *CustomerDetails, NSError *error) {
        if(!error) {
            self->customerDetails = CustomerDetails;
            NSLog(@"Header: %@",CustomerDetails[@"Header"]);
            for(NSDictionary *row in CustomerDetails[@"Addresses"]) {
                if ([row[@"AddressReference"] isEqualToString:@"STANDARD"]) {
                    self->customerHeader = row;
                    //NSLog(@"Main Contact: %@", row);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self->contactsBtn setEnabled:YES];
                    });
                }
            }
        }
        //NSLog(@"%@",CustomerDetails);
    }];
}

-(void)tapRow:(UIButton*)sender {
    [self showLoading];
    NSString *ID = [NSString stringWithFormat:@"%@", [sender.layer valueForKey:@"ID"]];
    NSLog(@"%@", ID);
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CRMDetailedView *CRMViewDetailed= [mainStoryboard instantiateViewControllerWithIdentifier:@"CRMDetailed"];
    
    NSDictionary *dictToSend;
    if(activeTab == 0) {
        for(NSDictionary* row in customerData[@"Jobs"]) {
            if([row[@"Ref"] isEqualToString:ID]) {
                dictToSend = row;
                //NSLog(@"%@",dictToSend);
            }
        }
    } else if(activeTab == 1) {
        for(NSDictionary* row in customerData[@"Estimates"]) {
            if([row[@"Ref"] isEqualToString:ID]) {
                dictToSend = row;
                //NSLog(@"%@",dictToSend);
            }
        }
    } else if(activeTab == 2) {
        for(NSDictionary* row in customerData[@"Contacts"]) {
            if([row[@"Ref"] isEqualToString:ID]) {
                dictToSend = row;
                //NSLog(@"%@",dictToSend);
            }
        }
    }
    CRMViewDetailed.selectedData = dictToSend;
    CRMViewDetailed.tabSelected = (int) activeTab;
    [self.navigationController pushViewController:CRMViewDetailed animated:NO];
    [Hud removeFromSuperview];
}

-(void)tapRefreshBtn {
    [customerResults removeFromSuperview];
    [self searchCustomer];
}

-(void)displayFilterOverlay {
    overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [overlay setBackgroundColor:[UIColor colorWithRed:26/255.0f
                                                green:26/255.0f
                                                 blue:26/255.0f
                                                alpha:0.95f]];
    [self.view addSubview:overlay];
    
    filterOverlay = [[UIView alloc] init];
    filterOverlay.frame = CGRectMake(0, 0, overlay.frame.size.width-20, 200);
    [filterOverlay setCenter:CGPointMake(overlay.frame.size.width /2 , overlay.frame.size.height /2)];
    [filterOverlay setBackgroundColor:[UIColor whiteColor]];
    filterOverlay.layer.cornerRadius = 5;
    filterOverlay.layer.masksToBounds = true;
    [overlay addSubview:filterOverlay];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
    [title setCenter:CGPointMake(filterOverlay.frame.size.width/2, 20)];
    title.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:22];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"Filter By Date";
    title.textColor = [UIColor colorWithRed:102/255.0f
                                      green:102/255.0f
                                       blue:102/255.0f
                                      alpha:1.0f];
    [filterOverlay addSubview:title];
    
    UIButton *exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(filterOverlay.frame.size.width-30, 12, 18, 18)];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(tapCloseFilter) forControlEvents:UIControlEventTouchDown];
    [filterOverlay addSubview:exitBtn];
    
    UIView *filterCont = [[UIView alloc] initWithFrame:CGRectMake(0, 30, filterOverlay.frame.size.width, 120)];
    //[filterCont setCenter:CGPointMake(filterOverlay.frame.size.width/2, 90)];
    //[filterCont setBackgroundColor:[UIColor blackColor]];
    [filterOverlay addSubview:filterCont];
    
    UILabel *startLabel = [[UILabel alloc] init];
    startLabel.frame = CGRectMake(5, 0, 200, 20);
    startLabel.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:12];
    startLabel.text = @"From";
    startLabel.textColor = [UIColor colorWithRed:102/255.0f
                                         green:102/255.0f
                                          blue:102/255.0f
                                         alpha:1.0f];
    startLabel.textAlignment = NSTextAlignmentLeft;
    [filterCont addSubview:startLabel];
    
    startDateSelectionField = [[UITextField alloc] init];
    startDateSelectionField.frame = CGRectMake(5, 20, filterCont.frame.size.width-50, 30);
    //startDateSelectionField.enabled = NO;
    startDateSelectionField.textAlignment = NSTextAlignmentCenter;
    [startDateSelectionField setBackgroundColor:[UIColor colorWithRed:226/255.0f
                                                                green:213/255.0f
                                                                 blue:221/255.0f
                                                                alpha:1.0f]];
    startDateSelectionField.layer.borderWidth = 2;
    startDateSelectionField.layer.cornerRadius = 4;
    startDateSelectionField.layer.masksToBounds = true;
    startDateSelectionField.layer.borderColor = [[UIColor colorWithRed:192/255.0f
                                                                 green:29/255.0f
                                                                  blue:74/255.0f
                                                                 alpha:1.0f] CGColor];
    [filterCont addSubview:startDateSelectionField];
    
    UIButton *startCal = [[UIButton alloc] init];
    startCal.frame = CGRectMake(startDateSelectionField.frame.size.width + 10, 17, 35, 35);
    [startCal setBackgroundImage:[UIImage imageNamed:@"btn_calendar"] forState:UIControlStateNormal];
    startCal.tag = 1;
    [startCal addTarget:self action:@selector(tapCal:) forControlEvents:UIControlEventTouchDown];
    [filterCont addSubview:startCal];
    
    UILabel *endLabel = [[UILabel alloc] init];
    endLabel.frame = CGRectMake(5, 60, 200, 20);
    endLabel.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:12];
    endLabel.text = @"To";
    endLabel.textColor = [UIColor colorWithRed:102/255.0f
                                      green:102/255.0f
                                       blue:102/255.0f
                                      alpha:1.0f];
    endLabel.textAlignment = NSTextAlignmentLeft;
    [filterCont addSubview:endLabel];
    
    endDateSelectionField = [[UITextField alloc] init];
    endDateSelectionField.frame = CGRectMake(5, 80, filterCont.frame.size.width-50, 30);
    //endDateSelectionField.enabled = NO;
    endDateSelectionField.textAlignment = NSTextAlignmentCenter;
    [endDateSelectionField setBackgroundColor:[UIColor colorWithRed:226/255.0f
                                                              green:213/255.0f
                                                               blue:221/255.0f
                                                              alpha:1.0f]];
    endDateSelectionField.layer.borderWidth = 2;
    endDateSelectionField.layer.cornerRadius = 4;
    endDateSelectionField.layer.masksToBounds = true;
    endDateSelectionField.layer.borderColor = [[UIColor colorWithRed:192/255.0f
                                                               green:29/255.0f
                                                                blue:74/255.0f
                                                               alpha:1.0f] CGColor];
    [filterCont addSubview:endDateSelectionField];
    
    UIButton *endCal = [[UIButton alloc] init];
    endCal.frame = CGRectMake(endDateSelectionField.frame.size.width + 10, 77, 35, 35);
    [endCal setBackgroundImage:[UIImage imageNamed:@"btn_calendar"] forState:UIControlStateNormal];
    endCal.tag = 2;
    [endCal addTarget:self action:@selector(tapCal:) forControlEvents:UIControlEventTouchDown];
    [filterCont addSubview:endCal];
    
    //Add datePickers to UITextFields
    startDatePicker = [[UIDatePicker alloc] init];
    startDatePicker.datePickerMode = UIDatePickerModeDate;
    [startDateSelectionField setInputView:startDatePicker];
    
    endDatePicker = [[UIDatePicker alloc] init];
    endDatePicker.datePickerMode = UIDatePickerModeDate;
    [endDateSelectionField setInputView:endDatePicker];
    
    //Format toolbars
    UIBarButtonItem *space= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIToolbar *startToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [startToolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *startDoneBtn= [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(displaySelectedDate:)];
    startDoneBtn.tag = 1;
    [startToolBar setItems:[NSArray arrayWithObjects:space,startDoneBtn, nil]];
    [startDateSelectionField setInputAccessoryView:startToolBar];
    
    UIToolbar *endToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [endToolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *endDoneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(displaySelectedDate:)];
    endDoneBtn.tag = 2;
    [endToolBar setItems:[NSArray arrayWithObjects:space,endDoneBtn, nil]];
    [endDateSelectionField setInputAccessoryView:endToolBar];
    
    UIButton *clearBtn = [[UIButton alloc] init];
    clearBtn.frame = CGRectMake(5, filterOverlay.frame.size.height-45, 132, 40);
    //[clearBtn setCenter:CGPointMake(filterOverlay.frame.size.width / 4, filterOverlay.frame.size.height - 20)];
    [clearBtn setBackgroundImage:[UIImage imageNamed:@"btn_clear"] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(tapClearFilter) forControlEvents:UIControlEventTouchUpInside];
    [filterOverlay addSubview:clearBtn];
    
    UIButton *applyBtn = [[UIButton alloc] init];
    applyBtn.frame = CGRectMake(filterOverlay.frame.size.width - 137, filterOverlay.frame.size.height-45, 132, 40);
    //[applyBtn setCenter:CGPointMake(filterOverlay.frame.size.width - filterOverlay.frame.size.width / 4, filterOverlay.frame.size.height - 20)];
    [applyBtn setBackgroundImage:[UIImage imageNamed:@"btn_apply"] forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(tapApplyFilter) forControlEvents:UIControlEventTouchUpInside];
    [filterOverlay addSubview:applyBtn];
    
    if(filterActive) {
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd MMMM YYYY"];
        [startDatePicker setDate:startDate];
        startDateSelectionField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:startDate]];
        [endDatePicker setDate:endDate];
        endDateSelectionField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:endDate]];
    }
}

-(void)tapCal:(UIButton *)sender {
    int cal = (int) [sender tag];
    if(cal == 1) {
        [startDateSelectionField becomeFirstResponder];
    } else if (cal == 2) {
        [endDateSelectionField becomeFirstResponder];
    }
}

-(void)displaySelectedDate:(UIButton *)sender {
    int cal = (int) [sender tag];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd MMMM YYYY"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    if(cal == 1) {
        //startDate = datePicker.date;
        startDate = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:startDatePicker.date options:0];
        //NSLog(@"Start: %@",startDate);
        startDateSelectionField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:startDate]];
        [startDateSelectionField resignFirstResponder];
    } else if (cal == 2) {
        //endDate = datePicker.date;
        endDate = [calendar dateBySettingHour:23 minute:59 second:59 ofDate:endDatePicker.date options:0];
        //NSLog(@"End: %@",endDate);
        endDateSelectionField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:endDate]];
        [endDateSelectionField resignFirstResponder];
    }
}

-(BOOL) date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate {
    return (([date compare:beginDate] != NSOrderedAscending) && ([date compare:endDate] != NSOrderedDescending));
}

-(int) filterCustomerData:(int)tab {
    int count = 0;
    if(customerData != nil) {
        NSDictionary *newList;
        if(tab == 0) {
            newList = customerData[@"Jobs"];
        } else if (tab == 1) {
            newList = customerData[@"Estimates"];
        } else if (tab == 2) {
            newList = customerData[@"Contacts"];
        }
        
        int searchCount = (int) [newList count];
        if (searchCount != 0) {
            for(NSDictionary* row in newList) {
                NSDateFormatter *ISO8601DateFormatter = [[NSDateFormatter alloc] init];
                ISO8601DateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
                ISO8601DateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
                ISO8601DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                
                if(tab == 2) {
                    NSDate *date = [ISO8601DateFormatter dateFromString:row[@"ContactDate"]];
                    if([self date:date isBetweenDate:startDate andDate:endDate]) count++;
                } else {
                    NSDate *date = [ISO8601DateFormatter dateFromString:row[@"Date"]];
                    if([self date:date isBetweenDate:startDate andDate:endDate]) count++;
                }
            }
        }
    }
    return count;
}


-(void)tapApplyFilter {
    filterActive = YES;
    [self tapCloseFilter];
    [customerResults removeFromSuperview];
    [self switchTabs:activeTab];
}

-(void) tapClearFilter {
    filterActive = NO;
    startDate = nil;
    startDateSelectionField.text = @"";
    endDate = nil;
    endDateSelectionField.text = @"";
    [self tapCloseFilter];
    [customerResults removeFromSuperview];
    [self switchTabs:activeTab];
}

-(void)tapCloseFilter {
    [filterOverlay removeFromSuperview];
    [overlay removeFromSuperview];
}

-(void) loadContacts {
    UIScrollView *contactsResults = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, contactsOverlay.frame.size.width, contactsOverlay.frame.size.height-50)];
    contactsResults.contentSize = CGSizeMake(contactsResults.frame.size.width, 500);
    
    int rowHeightIndex = 0;
    
    UIView *rowItem = [self createContactRow:customerHeader withFrameWidth:contactsResults.frame.size.width];
    rowItem.frame = CGRectMake(0, rowHeightIndex, rowItem.frame.size.width, rowItem.frame.size.height);
    rowHeightIndex += rowItem.frame.size.height + 5;
    [contactsResults addSubview:rowItem];
    
    for(NSDictionary *custAddress in customerDetails[@"Addresses"]) {
        if(![custAddress[@"AddressReference"] isEqualToString:@"STANDARD"]){
            UIView *rowItem = [self createContactRow:custAddress withFrameWidth:contactsResults.frame.size.width];
            rowItem.frame = CGRectMake(0, rowHeightIndex, rowItem.frame.size.width, rowItem.frame.size.height);
            rowHeightIndex += rowItem.frame.size.height + 5;
            [contactsResults addSubview:rowItem];
        }
    }
    contactsResults.contentSize = CGSizeMake(contactsResults.frame.size.width, rowHeightIndex-5);
    [contactsOverlay addSubview:contactsResults];
}

-(UIView *)createContactRow:(NSDictionary *)contact withFrameWidth:(int) width {
    BOOL number = NO;
    BOOL email = NO;
    BOOL address = NO;
    
    UIView *rowItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 220)];
    //[rowItem setBackgroundColor:[UIColor blackColor]];
    
    UILabel *contactName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rowItem.frame.size.width-10, 20)];
    [contactName setCenter:CGPointMake(rowItem.frame.size.width/2, 10)];
    contactName.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:18];
    contactName.textAlignment = NSTextAlignmentCenter;
    contactName.text = [NSString stringWithFormat:@"%@",contact[@"ContactName"]];
    contactName.textColor = [UIColor colorWithRed:102/255.0f
                                            green:102/255.0f
                                             blue:102/255.0f
                                            alpha:1.0f];
    [rowItem addSubview:contactName];
    
    if(![contact[@"TelNo"] isEqualToString:@""]) {
        number = YES;
        UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, rowItem.frame.size.width, 40)];
        phoneImg.image = [UIImage imageNamed:@"btn_phone"];
        //[phoneImg setBackgroundColor:[UIColor blueColor]];
        [rowItem addSubview:phoneImg];
        
        UILabel *phoneTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, rowItem.frame.size.width-50, 30)];
        phoneTitle.text = [NSString stringWithFormat:@"%@",contact[@"TelNo"]];
        [phoneTitle setFont:[UIFont boldSystemFontOfSize:12]];
        //rowTitle.textColor = [UIColor whiteColor];
        phoneTitle.textColor = [UIColor blackColor];
        phoneTitle.textAlignment = NSTextAlignmentLeft;
        //[rowTitle setBackgroundColor:[UIColor blackColor]];
        [phoneImg addSubview:phoneTitle];
        
        UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(rowItem.frame.size.width-64, 3, 60, 33)];
        //[phoneBtn setBackgroundColor:[UIColor blackColor]];
        //[phoneBtn.layer setValue:row[@""] forKey:@"PhoneNum"];
        //[phoneBtn addTarget:self action:@selector(tapPhoneNum:) forControlEvents:UIControlEventTouchUpInside];
        [phoneImg addSubview:phoneBtn];
    }
    
    if(![contact[@"EmailAddress"] isEqualToString:@""]) {
        email = YES;
        UIImageView *emailImg = [[UIImageView alloc] init];
        if(number) emailImg.frame = CGRectMake(0, 70, rowItem.frame.size.width, 40);
        else emailImg.frame = CGRectMake(0, 25, rowItem.frame.size.width, 40);
        emailImg.image = [UIImage imageNamed:@"btn_email"];
        //[emailImg setBackgroundColor:[UIColor blueColor]];
        [rowItem addSubview:emailImg];
        
        UILabel *emailTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, rowItem.frame.size.width-50, 30)];
        emailTitle.text = [NSString stringWithFormat:@"%@",contact[@"EmailAddress"]];
        [emailTitle setFont:[UIFont boldSystemFontOfSize:12]];
        //rowTitle.textColor = [UIColor whiteColor];
        emailTitle.textColor = [UIColor blackColor];
        emailTitle.textAlignment = NSTextAlignmentLeft;
        //[rowTitle setBackgroundColor:[UIColor blackColor]];
        [emailImg addSubview:emailTitle];
        
        UIButton *emailBtn = [[UIButton alloc] initWithFrame:CGRectMake(rowItem.frame.size.width-64, 3, 60, 33)];
        //[emailBtn setBackgroundColor:[UIColor blackColor]];
        //[emailBtn.layer setValue:row[@""] forKey:@"PhoneNum"];
        //[emailBtn addTarget:self action:@selector(tapPhoneNum:) forControlEvents:UIControlEventTouchUpInside];
        [emailImg addSubview:emailBtn];
    }
    
    if(![contact[@"PostCode"] isEqualToString:@""]) {
        address = YES;
        UIImageView *addressImg = [[UIImageView alloc] init];
        if (number & email) addressImg.frame = CGRectMake(0, 115, rowItem.frame.size.width, 100);
        else if (number || email) addressImg.frame = CGRectMake(0, 70, rowItem.frame.size.width, 100);
        else addressImg.frame = CGRectMake(0, 25, rowItem.frame.size.width, 100);
        addressImg.image = [UIImage imageNamed:@"btn_address"];
        //[emailImg setBackgroundColor:[UIColor blueColor]];
        [rowItem addSubview:addressImg];
        
        UILabel *addressTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, rowItem.frame.size.width-50, 80)];
        NSString *addressLine1 = [NSString stringWithFormat:@"%@", contact[@"AddressLine1"]];
        NSString *addressLine2 = [NSString stringWithFormat:@"\n%@", contact[@"AddressLine2"]];
        NSString *addressLine3 = [NSString stringWithFormat:@"\n%@", contact[@"AddressLine3"]];
        NSString *addressLine4 = [NSString stringWithFormat:@"\n%@", contact[@"AddressLine4"]];
        NSString *addressLine5 = [NSString stringWithFormat:@"\n%@", contact[@"AddressLine5"]];
        NSString *postCode = [NSString stringWithFormat:@"\n%@", contact[@"PostCode"]];
        
        //NSString *addressLine = @"Hello";
        NSString *addressLine = addressLine1;
        if([addressLine2 length] > 1) addressLine = [addressLine stringByAppendingString:addressLine2];
        if([addressLine3 length] > 1) addressLine = [addressLine stringByAppendingString:addressLine3];
        if([addressLine4 length] > 1) addressLine = [addressLine stringByAppendingString:addressLine4];
        if([addressLine5 length] > 1) addressLine = [addressLine stringByAppendingString:addressLine5];
        addressLine = [addressLine stringByAppendingString:postCode];
        
        //NSLog(@"%@",addressLine);
        addressTitle.text = addressLine;
        [addressTitle setFont:[UIFont boldSystemFontOfSize:12]];
        //rowTitle.textColor = [UIColor whiteColor];
        addressTitle.textColor = [UIColor blackColor];
        addressTitle.textAlignment = NSTextAlignmentLeft;
        addressTitle.numberOfLines = 5;
        //[rowTitle setBackgroundColor:[UIColor blackColor]];
        [addressImg addSubview:addressTitle];
        
        UIButton *addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(rowItem.frame.size.width-64, 3, 60, 93)];
        //[addressBtn setBackgroundColor:[UIColor blackColor]];
        //[addressBtn.layer setValue:row[@""] forKey:@"PhoneNum"];
        //[addressBtn addTarget:self action:@selector(tapPhoneNum:) forControlEvents:UIControlEventTouchUpInside];
        [addressImg addSubview:addressBtn];
    }
    
    if (number & email & address) {
        //Don't change
    }
    else if (number & email) rowItem.frame =  CGRectMake(0, 0, width, 115);
    else if ((number & address) || (email & address)) rowItem.frame =  CGRectMake(0, 0, width, 175);
    else if (number || email) rowItem.frame =  CGRectMake(0, 0, width, 70);
    else if (address) rowItem.frame =  CGRectMake(0, 0, width, 130);
    else rowItem.frame =  CGRectMake(0, 0, width, 25);
    
    return rowItem;
}

-(void) displayContactsOverlay {
    overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [overlay setBackgroundColor:[UIColor colorWithRed:26/255.0f
                                                green:26/255.0f
                                                 blue:26/255.0f
                                                alpha:0.95f]];
    [self.view addSubview:overlay];
    
    contactsOverlay = [[UIView alloc] init];
    contactsOverlay.frame = CGRectMake(0, 0, overlay.frame.size.width-20, 450);
    [contactsOverlay setCenter:CGPointMake(overlay.frame.size.width /2 , overlay.frame.size.height /2)];
    [contactsOverlay setBackgroundColor:[UIColor whiteColor]];
    contactsOverlay.layer.cornerRadius = 5;
    contactsOverlay.layer.masksToBounds = true;
    [overlay addSubview:contactsOverlay];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
    [title setCenter:CGPointMake(contactsOverlay.frame.size.width/2, 20)];
    title.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:24];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"Customer Contacts";
    title.textColor = [UIColor colorWithRed:102/255.0f
                                      green:102/255.0f
                                       blue:102/255.0f
                                      alpha:1.0f];
    [contactsOverlay addSubview:title];
    
    UIButton *exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(contactsOverlay.frame.size.width-30, 12, 18, 18)];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(tapCloseContacts) forControlEvents:UIControlEventTouchDown];
    [contactsOverlay addSubview:exitBtn];
    
    [self loadContacts];
}

-(void) tapCloseContacts {
    [contactsOverlay removeFromSuperview];
    [overlay removeFromSuperview];
}

-(void) loadAlerts {
    ImprintDatabase *data = [[ImprintDatabase alloc] init];
    [data getProductionEvents:nil completion:^(NSDictionary *ProductionEvents, NSError *error) {
        if(!error) {
            NSMutableArray *myIntegers = [NSMutableArray array];
            for(NSDictionary *row in ProductionEvents) {
                int eventNo = [[NSString stringWithFormat:@"%@",row[@"EventNo"]] intValue];
                [myIntegers addObject:[NSNumber numberWithInteger:eventNo]];
            }
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:myIntegers forKey:@"EventNumbers"];
            [dict setValue:@"2018-01-22T10:08:22" forKey:@"StartDate"];
            [dict setValue:@"2019-01-25T11:22:26" forKey:@"EndDate"];
            
            NSError *err;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&err];
            
            NSLog(@"JSON = %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
            
            [self loadAlerts2:jsonData];
        }
        //NSLog(@"%@", ProductionEvents);
    }];
    
}

-(void) loadAlerts2:(NSData *)dataToSend {
    ImprintDatabase *data2 = [[ImprintDatabase alloc] init];
    [data2 getProductionControls:dataToSend completion:^(NSDictionary *ProductionControls, NSError *error) {
        if(!error) {
            
        }
        //NSLog(@"%@", ProductionControls);
    }];
}

-(void) displayAlertsOverlay {
    overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [overlay setBackgroundColor:[UIColor colorWithRed:26/255.0f
                                                green:26/255.0f
                                                 blue:26/255.0f
                                                alpha:0.95f]];
    [self.view addSubview:overlay];
    
    alertsOverlay = [[UIView alloc] init];
    alertsOverlay.frame = CGRectMake(0, 0, overlay.frame.size.width-20, 400);
    [alertsOverlay setCenter:CGPointMake(overlay.frame.size.width /2 , overlay.frame.size.height /2)];
    [alertsOverlay setBackgroundColor:[UIColor whiteColor]];
    alertsOverlay.layer.cornerRadius = 5;
    alertsOverlay.layer.masksToBounds = true;
    [overlay addSubview:alertsOverlay];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
    [title setCenter:CGPointMake(alertsOverlay.frame.size.width/2, 20)];
    title.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:24];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"Alerts";
    title.textColor = [UIColor colorWithRed:102/255.0f
                                      green:102/255.0f
                                       blue:102/255.0f
                                      alpha:1.0f];
    [alertsOverlay addSubview:title];
    
    UIButton *exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(alertsOverlay.frame.size.width-30, 12, 18, 18)];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(tapCloseAlerts) forControlEvents:UIControlEventTouchDown];
    [alertsOverlay addSubview:exitBtn];
    
    [self loadAlerts];
}

-(void) tapCloseAlerts {
    [alertsOverlay removeFromSuperview];
    [overlay removeFromSuperview];
}

-(void) addNewProspect {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"ICN" forKey:@"ProspectName"];
    [dict setValue:@"28 Stoney Street" forKey:@"AddressLine1"];
    [dict setValue:@"" forKey:@"AddressLine2"];
    [dict setValue:@"Nottingham" forKey:@"Town"];
    [dict setValue:@"Nottinghamshire" forKey:@"County"];
    [dict setValue:@"NG1 1LL" forKey:@"PostCode"];
    [dict setValue:@"Aidan" forKey:@"ContactName"];
    [dict setValue:@"07457 758473" forKey:@"Tel"];
    [dict setValue:@"07457 758473" forKey:@"Mobile"];
    [dict setValue:@"aidan@icn-apps.com" forKey:@"EmailAddress"];
    [dict setValue:@"Trainee" forKey:@"Position"];
    
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&err];
    
    NSLog(@"JSON = %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    /*
    {
        "ProspectName": "sample string 1",
        "AddressLine1": "sample string 2",
        "AddressLine2": "sample string 3",
        "Town": "sample string 4",
        "County": "sample string 5",
        "PostCode": "sample string 6",
        "ContactName": "sample string 7",
        "Tel": "sample string 8",
        "Mobile": "sample string 9",
        "EmailAddress": "sample string 10",
        "Position": "sample string 11"
    }
     */
}

-(void) saveProspect:(NSData *)dataToSend {
    ImprintDatabase *data = [[ImprintDatabase alloc] init];
    [data saveProspect:dataToSend completion:^(NSDictionary *ProspectResponse, NSError *error) {
        if(!error) {
            
        }
        NSLog(@"%@", ProspectResponse);
    }];
}

-(void) createNewCRMActivity {
    NSLog(@"createCRM");
    
}

-(void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:
            [Hud removeFromSuperview];
            [self viewDidLoad];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            [Hud removeFromSuperview];
            [self viewDidLoad];
            break;
        case UIDeviceOrientationLandscapeRight:
            [Hud removeFromSuperview];
            [self viewDidLoad];
            break;
            
        default:
            break;
    };
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

-(void)popViewControllerWithAnimation{
    //    NSLog(@"Back");
    //
    //    [Hud removeFromSuperview];
    //
    //    SWRevealViewController *homeControl = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"Home"];
    //
    //    [self.navigationController popViewControllerAnimated:homeControl];
    //have to re-load every page because of the oritation
    [self showLoading];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Home"];
    [self.navigationController pushViewController:vc animated:NO];
    [Hud removeFromSuperview];
}

@end
