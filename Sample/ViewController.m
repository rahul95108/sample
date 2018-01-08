

#import "ViewController.h"
#import <RSSParser.h>

@interface ViewController (){
    NSInteger MainIndex;
}

@end

@implementation ViewController
@synthesize service;
@synthesize arrData;
@synthesize tbView;

- (void)viewDidLoad {
    [super viewDidLoad];
    MainIndex = 0;
    
    [self callService];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillLayoutSubviews {
    self.segmentedPager.frame = (CGRect){
        .origin.x       = 0.f,
        .origin.y       = 20.f,
        .size.width     = self.view.frame.size.width,
        .size.height    = self.view.frame.size.height - 20.f
    };
    [super viewWillLayoutSubviews];
}

- (MXSegmentedPager *)segmentedPager {
    if (!_segmentedPager) {
        
        // Set a segmented pager
        _segmentedPager = [[MXSegmentedPager alloc] init];
        _segmentedPager.delegate    = self;
        _segmentedPager.dataSource  = self;
    }
    return _segmentedPager;
}

#pragma -mark <MXSegmentedPagerDelegate>

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"%@ page selected.", title);
}

#pragma -mark <MXSegmentedPagerDataSource>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return self.arrData.count;
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    MainIndex = index;
    NSDictionary *dict = [self.arrData objectAtIndex:index];
    [self.tbView reloadData];
    return [dict valueForKey:@"FeedTitle"];
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    return self.tbView;
}

#pragma -mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = (indexPath.row % 2) + 1;
    [self.segmentedPager.pager showPageAtIndex:index animated:YES];
}

#pragma -mark <UITableViewDataSource>

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)callService{
    NSURL *URL = [NSURL URLWithString:@"http://appnevents.com/Services/EventService.asmx/GetNewsViewList"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"18" forKey:@"FeatureID"];
    [dict setValue:@"001d010g190A0Q03001d010g1501a000v00005011h111k11" forKey:@"Keys"];
    [dict setValue:@"0" forKey:@"UserID"];

    
    self.service = [[Webservice alloc] initWithURL:URL.absoluteString RequestType:@"POST" PostDataValuesAndKeys:nil UrlParameters:dict];
    self.service.delegate = self;
    self.service.webServiceId = 1;
}

#pragma mark - Webservice Delegate Methods -

-(void) webService:(id) webService result:(id) result{
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:result
                 options:0
                 error:&error];
    if (self.service.webServiceId == 1) {
        if ([[object valueForKey:@"Success"] boolValue]) {
            self.arrData = [NSMutableArray array];
            NSArray *arrNews = [object valueForKey:@"ListOfNews"];
            for (int i = 0; i < arrNews.count; i++) {
                NSDictionary *dict = [arrNews objectAtIndex:i];
                [self.arrData addObject:dict];
            }
            [self.view addSubview:self.segmentedPager];
            self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
            self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor orangeColor];
            self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
            self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor]};
            
            self.segmentedPager.pager.gutterWidth = 20;
            [self setLayout];
        }
        else{
        }
    }
}

-(void)setLayout{
    for (int i = 0; i < self.arrData.count; i++) {
        NSDictionary *dict = [self.arrData objectAtIndex:i];
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[dict valueForKey:@"FeedURL"]]];
        [RSSParser parseRSSFeedForRequest:req success:^(NSArray *feedItems) {
            NSLog(@"%@",RSSItem.description);
            
            //you get an array of RSSItem
            
        } failure:^(NSError *error) {
            
            //something went wrong
            
        }];
    }
}

@end
