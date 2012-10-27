//
//  DeviceInfoViewController.m
//  Hardware Diagnostic Tool
//
//  Created by Aryan Sharifian on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "BatteryInfoViewController.h"
#import "DeviceInfoTableViewController.h"
#import "Ads.h"
#import "HDTAppDelegate.h"

@interface DeviceInfoViewController() {
    SKProductsRequest *pRequest;
    NSArray *productArray;
    UIAlertView *alert;
}

@property (strong) ADBannerView *bannerView;

- (void)layoutForCurrentOrientation:(BOOL)animated;

@end

@implementation DeviceInfoViewController
@synthesize bannerView;
@synthesize adButton;

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    HDTAppDelegate *appDelegate = (HDTAppDelegate *)[[UIApplication sharedApplication] delegate];
    Ads *ads = [Ads purchaseValueInManagedObjectContext:appDelegate.managedObjectContext];
    ads.purchased = [NSNumber numberWithBool:YES];
    [appDelegate saveContext];
    [self hideBannerView:appDelegate.bannerView];
    self.adButton.hidden = YES;
    [appDelegate updateBanner];
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Your item was successfully purchased" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [al show];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error" message:transaction.error.localizedDescription delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [al show];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    HDTAppDelegate *appDelegate = (HDTAppDelegate *)[[UIApplication sharedApplication] delegate];
    Ads *ads = [Ads purchaseValueInManagedObjectContext:appDelegate.managedObjectContext];
    ads.purchased = [NSNumber numberWithBool:YES];
    [appDelegate saveContext];
    [self hideBannerView:appDelegate.bannerView];
    self.adButton.hidden = YES;
    [appDelegate updateBanner];
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Your item was successfully restored" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [al show];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if (alert) {
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }
    if ([response.products count]) {
        productArray = [NSArray arrayWithArray:response.products];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select item you want to buy" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: [NSString stringWithFormat:@"Buy (%@) for $%@", ((SKProduct *)[response.products lastObject]).localizedTitle, ((SKProduct *)[response.products lastObject]).price] ,nil];
        [actionSheet showInView:self.tabBarController.view];
    } else {
        UIAlertView *noProductAlert = [[UIAlertView alloc] initWithTitle:@"No products found" message:@"Sorry, There was a problem getting product lists.\nPlease check your connection and try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [noProductAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alert.title isEqualToString:@"Processing"]) {
        if (pRequest) {
            [pRequest cancel];
            pRequest = nil;
        } 
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        SKPayment *payment = [SKPayment paymentWithProduct:[productArray objectAtIndex:buttonIndex]];
        
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
}

- (IBAction)removeAdsTaped:(id)sender
{
    pRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"HDT_NO_ADS"]];
    pRequest.delegate = self;
    [pRequest start];
    alert = [[UIAlertView alloc] initWithTitle:@"Processing" message:@"Processing...\nConnecting to App Store" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
}

- (void)layoutForCurrentOrientation:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    
    CGRect bannerFrame = self.bannerView.frame;
    if (self.bannerView.bannerLoaded) {
        bannerFrame.origin.y = 0;
    } else {
        bannerFrame.origin.y = [[UIScreen mainScreen] bounds].size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        self.bannerView.frame = bannerFrame;
    }];
}

- (void)showBannerView:(ADBannerView *)banner
{
    self.bannerView = banner;
    [self.view addSubview:banner];
    [self layoutForCurrentOrientation:YES];
}

- (void)hideBannerView:(ADBannerView *)banner
{
    [banner removeFromSuperview];
    self.bannerView = nil;
    [self layoutForCurrentOrientation:YES];
}

- (void)setup
{
    self.title = @"Device Info";
    self.tabBarItem.image = [UIImage imageNamed:@"info 15"];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (IBAction)batteryTaped:(id)sender
{
    BatteryInfoViewController *bivc = [[BatteryInfoViewController alloc] init];
    [self.navigationController pushViewController:bivc animated:YES];
}

- (IBAction)infoTaped:(id)sender
{
    DeviceInfoTableViewController *ditvc = [[DeviceInfoTableViewController alloc] init];
    [self.navigationController pushViewController:ditvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    HDTAppDelegate *appDelegate = (HDTAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate AdsPurchased]) {
        self.adButton.hidden = YES;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
