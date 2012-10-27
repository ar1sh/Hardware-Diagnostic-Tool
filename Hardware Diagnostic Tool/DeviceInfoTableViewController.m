//
//  DeviceInfoTableViewController.m
//  Hardware Diagnostic Tool
//
//  Created by Aryan Sharifian on 10/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DeviceInfoTableViewController.h"

@interface DeviceInfoTableViewController() {
    float inUse, totalCPU;
    Reachability* internetReach;
    Reachability* wifiReach;
    
    processor_info_array_t cpuInfo, prevCpuInfo;
    mach_msg_type_number_t numCpuInfo, numPrevCpuInfo;
    unsigned numCPUs;
    NSTimer *updateTimer;
    NSLock *CPUUsageLock;
    
    NSMutableArray *cpuTotalArray;
    NSMutableArray *cpuUsageArray;
}

@property (strong) ADBannerView *bannerView;

- (void)layoutForCurrentOrientation:(BOOL)animated;

@end

@implementation DeviceInfoTableViewController
@synthesize bannerView;

- (void)layoutForCurrentOrientation:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    
    CGRect bannerFrame = self.bannerView.frame;
    if (self.bannerView.bannerLoaded) {
        self.tableView.contentInset = UIEdgeInsetsMake(bannerFrame.size.height, 0, 0, 0);
        [self.tableView scrollRectToVisible:CGRectMake(bannerFrame.origin.x, bannerFrame.origin.y, 1, 1) animated:YES];
        bannerFrame.origin.y = - bannerFrame.size.height;
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableView.scrollsToTop = YES;
        bannerFrame.origin.y = [[UIScreen mainScreen] bounds].size.height;
    }
    
    //[self.tableView setContentOffset:CGPointMake(0, bannerFrame.size.height) animated:YES];
    
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

- (void)processorInfo
{
    int mib[2U] = { CTL_HW, HW_NCPU };
    size_t sizeOfNumCPUs = sizeof(numCPUs);
    int status = sysctl(mib, 2U, &numCPUs, &sizeOfNumCPUs, NULL, 0U);
    if(status)
        numCPUs = 1;
    
    CPUUsageLock = [[NSLock alloc] init];
    
    natural_t numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCpuInfo);
    if(err == KERN_SUCCESS) {
        [CPUUsageLock lock];
        if (!cpuUsageArray) {
            cpuUsageArray = [[NSMutableArray alloc] init];
        } else {
            [cpuUsageArray removeAllObjects];
        }
        if (!cpuTotalArray) {
            cpuTotalArray = [[NSMutableArray alloc] init];
        } else {
            [cpuTotalArray removeAllObjects];
        }
        
        for(unsigned i = 0U; i < numCPUs; ++i) {
            
            if(prevCpuInfo) {
                inUse = (
                         (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                         + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                         + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                         );
                totalCPU = inUse + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                inUse = cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                totalCPU = inUse + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [cpuTotalArray addObject:[NSNumber numberWithFloat:totalCPU]];
            [cpuUsageArray addObject:[NSNumber numberWithFloat:(inUse / totalCPU) * 100.00]];
        }
        [CPUUsageLock unlock];
    } else {
        NSLog(@"Error!");
    }

}

- (NSString *)memoryInfoWithInfo:(NSString *)info
{
    NSString *value;
	size_t length;
	int mib[6];	
	int result;
    
	int pagesize;
	mib[0] = CTL_HW;
	mib[1] = HW_PAGESIZE;
	length = sizeof(pagesize);
	if (sysctl(mib, 2, &pagesize, &length, NULL, 0) < 0)
	{
		perror("getting page size");
	}
    if ([info isEqual:@"Page Size"]) {
        value = [NSString stringWithFormat:@"%d", pagesize];
    }
    
	mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
	
	vm_statistics_data_t vmstat;
	if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count) != KERN_SUCCESS)
	{
		printf("Failed to get VM statistics.");
	}
	
	int wired = vmstat.wire_count * pagesize;
	int active = vmstat.active_count * pagesize;
	int inactive = vmstat.inactive_count * pagesize;
	int free = vmstat.free_count * pagesize;
    
    if ([info isEqual:@"Total"]) {
        value = [NSString stringWithFormat:@"%d MB", wired + (active) + inactive + free / (1048576.00 * pagesize)];
    }
    
	if ([info isEqual:@"Wired"]) {
        value = [NSString stringWithFormat:@"%d MB",wired / 1048576];
    }
    
    if ([info isEqual:@"Active"]) {
        value = [NSString stringWithFormat:@"%d MB",active / 1048576];
    }
    
    if ([info isEqual:@"Inactive"]) {
        value = [NSString stringWithFormat:@"%d MB",inactive / 1048576];
    }
    
    if ([info isEqual:@"Free"]) {
        value = [NSString stringWithFormat:@"%d MB",free / 1048576];
    }
    
    
	mib[0] = CTL_HW;
	mib[1] = HW_PHYSMEM;
	length = sizeof(result);
	if (sysctl(mib, 2, &result, &length, NULL, 0) < 0)
	{
		perror("getting physical memory");
	}
    
    if ([info isEqual:@"Physical"]) {
        value = [NSString stringWithFormat:@"%f",result];
    }
    
	mib[0] = CTL_HW;
	mib[1] = HW_USERMEM;
	length = sizeof(result);
	if (sysctl(mib, 2, &result, &length, NULL, 0) < 0)
	{
		perror("getting user memory");
	}
    
    if ([info isEqual:@"User"]) {
        value = [NSString stringWithFormat:@"%f",result];
    }
    
    return value;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Textures, blue, background, wallpaper patterns ,603..jpg"]];
    [self processorInfo];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (NSString *)configureReachability: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired= [curReach connectionRequired];
    NSString* statusString= @"";
    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = @"Access Not Available";
            //Minor interface detail- connectionRequired may return yes, even when the host is unreachable.  We cover that up here...
            connectionRequired= NO;  
            break;
        }
            
        case ReachableViaWWAN:
        {
            statusString = @"Reachable WWAN";
            break;
        }
        case ReachableViaWiFi:
        {
            statusString= @"Reachable WiFi";
            break;
        }
    }
    if(connectionRequired)
    {
        statusString= [NSString stringWithFormat: @"%@, Connection Required", statusString];
    }
    return statusString;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
    wifiReach = [Reachability reachabilityForLocalWiFi];
	[wifiReach startNotifier];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [internetReach stopNotifier];
	[wifiReach stopNotifier];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = nil;
    NSString *head = nil;
    switch (section) {
        case 0:
            head = @"   Device Info";
            break;
        case 1:
            head = @"   Network Info";
            break;
        case 2:
            head = @"   CPU Info";
            break;
        case 3:
            head = @"   Memory Info";
            break;
    }
    if (head) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(00, 0, 680, 200)];
        [label setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        label.text = head;
        label.textColor = [UIColor whiteColor];
    }
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int row = 0;
    switch (section) {
        case 0:
            row = 3;
            break;
        case 1:
            row = 6;
            break;
        case 2:
            row = numCPUs * 2;
            break;
        case 3:
            row = 5;
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *deviceIdentifier = @"Device";
    static NSString *cellIdentifier = @"Cell";
    static NSString *cpuIdentifier = @"CPU";
    static NSString *ramIdentifier = @"RAM";

    
    UITableViewCell *cell;
    
    CTTelephonyNetworkInfo *carrier = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *fn;
    
    switch (indexPath.section)
	{
		case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:deviceIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:deviceIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Device Name";
                    cell.detailTextLabel.text = [UIDevice currentDevice].name;
                    break;
                case 1:
                    cell.textLabel.text = @"System Version";
                    cell.detailTextLabel.text = [UIDevice currentDevice].systemVersion;
                    break;
                case 2:
                    cell.textLabel.text = @"System Name";
                    cell.detailTextLabel.text = [UIDevice currentDevice].systemName;
                    break;
                    
            }
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Carrier Name";
                    cell.detailTextLabel.text = carrier.subscriberCellularProvider.carrierName;
                    break;
                case 1:
                    cell.textLabel.text = @"ISO Country Code";
                    cell.detailTextLabel.text = carrier.subscriberCellularProvider.isoCountryCode;
                    break;
                case 2:
                    cell.textLabel.text = @"Mobile Country Code";
                    cell.detailTextLabel.text = carrier.subscriberCellularProvider.mobileCountryCode;
                    break;
                case 3:
                    cell.textLabel.text = @"Mobile Network Code";
                    cell.detailTextLabel.text = carrier.subscriberCellularProvider.mobileNetworkCode;
                    break;
                case 4:
                    fn = cell.textLabel.font.familyName;
                    cell.textLabel.font = [UIFont fontWithName:fn size:14];
                    cell.textLabel.text = @"Internet Reachability";
                    cell.detailTextLabel.text = [self configureReachability:internetReach];
                    break;
                case 5:
                    cell.textLabel.text = @"Wifi";
                    cell.detailTextLabel.text = [self configureReachability:wifiReach];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:cpuIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cpuIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            //cell.textLabel.text = [NSString stringWithFormat:@"Total CPU on Core #%d", (indexPath.row / 2) + 1];
            //cell.detailTextLabel.text = [self processorInfoFor:@"CPU Frequency"];
            
            if (fmod(indexPath.row, 2.00)) {
                cell.textLabel.text = [NSString stringWithFormat:@"Usage on Core #%d", (indexPath.row / 2) + 1];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%%%d", [(NSNumber *)[cpuUsageArray objectAtIndex:(indexPath.row / 2)] intValue]];
            } else {
                cell.textLabel.text = [NSString stringWithFormat:@"Total CPU on Core #%d", (indexPath.row / 2) + 1];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [(NSNumber *)[cpuTotalArray objectAtIndex:(indexPath.row / 2)] intValue]];
            }
            
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:ramIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ramIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Page Size";
                    cell.detailTextLabel.text = [self memoryInfoWithInfo:@"Page Size"];
                    break;
                case 1:
                    cell.textLabel.text = @"Free";
                    cell.detailTextLabel.text = [self memoryInfoWithInfo:@"Free"];
                    break;
                case 2:
                    cell.textLabel.text = @"Wired";
                    cell.detailTextLabel.text = [self memoryInfoWithInfo:@"Wired"];
                    break;
                case 3:
                    cell.textLabel.text = @"Active";
                    cell.detailTextLabel.text = [self memoryInfoWithInfo:@"Active"];
                    break;
                case 4:
                    cell.textLabel.text = @"Inactive";
                    cell.detailTextLabel.text = [self memoryInfoWithInfo:@"Inactive"];
                    break;
                case 5:
                    cell.textLabel.text = @"Total";
                    cell.detailTextLabel.text = [self memoryInfoWithInfo:@"Total"];
                    break;
                case 6:
                    cell.textLabel.text = @"Physical Memory";
                    cell.detailTextLabel.text = [self memoryInfoWithInfo:@"Physical"];
                    break;
                case 7:
                    cell.textLabel.text = @"User Memory";
                    cell.detailTextLabel.text = [self memoryInfoWithInfo:@"User"];
                    break;
            }
            break;
    }
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

@end
