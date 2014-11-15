//
//  MainTableViewController.m
//  NavBarTest
//
//  Created by Yihe Li on 11/7/14.
//  Copyright (c) 2014 Yihe Li. All rights reserved.
//

#import "AutoShrinkNavBarTableViewController.h"

#define NAV_BAR_HEIGHT 44
#define NAV_BAR_MIN_CENTER_Y -2
#define NAV_BAR_MAX_CENTER_Y 42
#define NAV_BAR_CENTER_THRESHOLD 10
#define TAB_BAR_HEIGHT 49

@interface AutoShrinkNavBarTableViewController () <UIScrollViewDelegate>
@property (nonatomic) CGFloat startOffset;
@property (nonatomic) CGFloat startPostionNavBar;
@property (nonatomic) CGFloat startPostionTabBar;
@property (nonatomic) CGFloat tabBarMaxCenterY;
@property (nonatomic) CGFloat tabBarMinCenterY;
@property (nonatomic, strong) UIColor *titleColor;
@end

@implementation AutoShrinkNavBarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.backgroundColor = [UIColor purpleColor];
//    self.refreshControl.tintColor = [UIColor whiteColor];
//    [self.refreshControl addTarget:self
//                            action:@selector(functionPlaceHolder)
//                  forControlEvents:UIControlEventValueChanged];
//    
    
    self.tabBarMinCenterY = CGRectGetHeight(self.view.frame) - TAB_BAR_HEIGHT/2;
    self.tabBarMaxCenterY = self.tabBarMinCenterY + TAB_BAR_HEIGHT;
    NSLog(@"%f-------Fuck ", self.tabBarMaxCenterY);
    
    //overrideThis
    self.titleColor = [UIColor whiteColor];
}

//- (void)functionPlaceHolder
//{
//    [self.refreshControl endRefreshing];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell.textLabel setText:[NSString stringWithFormat: @"Index: %ld",(long)indexPath.row]];
    return cell;
}

#pragma mark - AutoHiding Nav Bar

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startOffset = self.tableView.contentOffset.y;
    self.startPostionNavBar = self.navigationController.navigationBar.center.y;
    self.startPostionTabBar = self.navigationController.tabBarController.tabBar.center.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UITabBar *tabBar = self.navigationController.tabBarController.tabBar;
    
    if (self.tableView.contentOffset.y > -64) {
        [navBar setCenter:CGPointMake(navBar.center.x,MIN(NAV_BAR_MAX_CENTER_Y, MAX(NAV_BAR_MIN_CENTER_Y, self.startPostionNavBar+self.startOffset-self.tableView.contentOffset.y)))];
        [tabBar setCenter:CGPointMake(tabBar.center.x, MIN(self.tabBarMaxCenterY, MAX(self.tabBarMinCenterY, self.startPostionTabBar-(self.startOffset-self.tableView.contentOffset.y)*49/44)))];
    }  else {
        [navBar setCenter:CGPointMake(navBar.center.x,NAV_BAR_MAX_CENTER_Y)];
        [tabBar setCenter:CGPointMake(tabBar.center.x, self.tabBarMinCenterY)];
    }
    [self updateNavBar];
    
}

- (UIColor *)colorFromColor:(UIColor *)color withAlpha:(CGFloat)alpha
{
    CGFloat red, green, blue, myAlpha;
    [color getRed: &red
               green: &green
                blue: &blue
               alpha: &myAlpha];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)updateNavBar
{
    if(self.navigationController.navigationBar.center.y == NAV_BAR_MIN_CENTER_Y || self.navigationController.navigationBar.center.y == NAV_BAR_MAX_CENTER_Y)
    {
        self.startOffset = self.tableView.contentOffset.y;
        self.startPostionNavBar = self.navigationController.navigationBar.center.y;
        self.startPostionTabBar = self.navigationController.tabBarController.tabBar.center.y;
    }
    [self.navigationController.navigationBar setTintColor:[self colorFromColor:self.titleColor withAlpha: (self.navigationController.navigationBar.center.y - NAV_BAR_MIN_CENTER_Y) / NAV_BAR_HEIGHT]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [self colorFromColor:self.titleColor withAlpha:(self.navigationController.navigationBar.center.y - NAV_BAR_MIN_CENTER_Y) / NAV_BAR_HEIGHT]}];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self endScrolling];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
        [self endScrolling];
}

- (void)endScrolling
{
    CGFloat centerY = self.navigationController.navigationBar.center.y;
    CGFloat correctCenter = centerY < NAV_BAR_CENTER_THRESHOLD ? NAV_BAR_MIN_CENTER_Y   : NAV_BAR_MAX_CENTER_Y;
    
    CGFloat centerYTabBar = self.navigationController.tabBarController.tabBar.center.y;
    CGFloat correctCenterTabBar = centerY < NAV_BAR_CENTER_THRESHOLD ? self.tabBarMaxCenterY   : self.tabBarMinCenterY;
    
    if (centerY != NAV_BAR_MAX_CENTER_Y && centerY != NAV_BAR_MIN_CENTER_Y) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
            [self.navigationController.navigationBar setCenter:CGPointMake(self.navigationController.navigationBar.center.x, correctCenter)];
            [self.navigationController.navigationBar setTintColor:[self colorFromColor:self.titleColor withAlpha:(correctCenter - NAV_BAR_MIN_CENTER_Y) / NAV_BAR_HEIGHT]];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [self colorFromColor:self.titleColor withAlpha:(correctCenter - NAV_BAR_MIN_CENTER_Y) / NAV_BAR_HEIGHT]}];
        } completion:nil];
        
    }
    
    if (centerYTabBar != self.tabBarMaxCenterY && centerYTabBar != self.tabBarMinCenterY) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
            [self.navigationController.tabBarController.tabBar setCenter:CGPointMake(self.navigationController.tabBarController.tabBar.center.x, correctCenterTabBar)];
        } completion:nil];

    }
}

@end
