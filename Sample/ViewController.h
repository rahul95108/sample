//
//  ViewController.h
//  Sample
//
//  Created by Rahul R Patel on 1/6/18.
//  Copyright © 2018 Rahul R Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Webservice.h"
#import "MXSegmentedPager.h"

@interface ViewController : UIViewController<WebServiceDelegate,MXSegmentedPagerDelegate, MXSegmentedPagerDataSource>

@property (nonatomic,strong) Webservice *service;
@property (nonatomic,strong) UITableView *tbView;
@property (nonatomic,strong) NSMutableArray *arrData;
@property (nonatomic, strong) MXSegmentedPager  * segmentedPager;
@end

