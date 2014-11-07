//
//  MainTableViewController.m
//  NavBarTest
//
//  Created by Yihe Li on 11/7/14.
//  Copyright (c) 2014 Yihe Li. All rights reserved.
//

#import "MainTableViewController.h"
//#import "TLYShyNavBarManager.h"
#define NAV_BAR_HEIGHT 44
#define NAV_BAR_MIN_CENTER_Y -2
#define NAV_BAR_MAX_CENTER_Y 42
#define NAV_BAR_CENTER_THRESHOLD 15

@interface MainTableViewController () <UIScrollViewDelegate>
@property (nonatomic) CGFloat startOffset;
#warning Get rid of this
@property (nonatomic) CGFloat startPostionNavBar;
@property (nonatomic) CGFloat lastOffset;
@property (nonatomic) int direction; // 0 for up 1 for down
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.shyNavBarManager.scrollView = self.tableView;
//    self.navigationController.hidesBarsOnSwipe = YES;
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
//    [self.refreshControl addTarget:self action:@selector(changeValueOfRefreshControl) forControlEvents:UIControlEvent]
    [self.refreshControl addTarget:self
                            action:@selector(functionPlaceHolder)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)functionPlaceHolder
{
    NSLog(@"-------------%f",self.tableView.contentOffset.y);
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    // Configure the cell...
    [cell.textLabel setText:[NSString stringWithFormat: @"Index: %ld",(long)indexPath.row]];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.lastOffset = self.tableView.contentOffset.y;
    self.startOffset = self.tableView.contentOffset.y;
    self.startPostionNavBar = self.navigationController.navigationBar.center.y;
    NSLog(@"---------startoffset: %f",self.startOffset);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (self.tableView.contentOffset.y > -64) {
    self.lastOffset = self.tableView.contentOffset.y;
    NSLog(@"%f",self.tableView.contentOffset.y);
        [self.navigationController.navigationBar setCenter:CGPointMake(self.navigationController.navigationBar.center.x,MIN(NAV_BAR_MAX_CENTER_Y, MAX(NAV_BAR_MIN_CENTER_Y, self.startPostionNavBar+self.startOffset-self.tableView.contentOffset.y)))];
    }  else {
        [self.navigationController.navigationBar setCenter:CGPointMake(self.navigationController.navigationBar.center.x,NAV_BAR_MAX_CENTER_Y)];
    }
    [self updateNavBar];
    
}

- (void)updateNavBar
{
    if(self.navigationController.navigationBar.center.y == NAV_BAR_MIN_CENTER_Y || self.navigationController.navigationBar.center.y == NAV_BAR_MAX_CENTER_Y)
    {
        self.startOffset = self.tableView.contentOffset.y;
        self.startPostionNavBar = self.navigationController.navigationBar.center.y;
    }
    NSLog(@"Nav bar center y: %f",self.navigationController.navigationBar.center.y);
    NSLog(@"Moved Distance: %f", self.startOffset-self.tableView.contentOffset.y);
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:1 alpha: (self.navigationController.navigationBar.center.y - NAV_BAR_MIN_CENTER_Y) / NAV_BAR_HEIGHT]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:(self.navigationController.navigationBar.center.y - NAV_BAR_MIN_CENTER_Y) / NAV_BAR_HEIGHT]}];
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
    NSLog(@"---------END");
    CGFloat centerY = self.navigationController.navigationBar.center.y;
    NSLog(@"-----current nav bar center: %f",centerY);
    CGFloat correctCenter = centerY < NAV_BAR_CENTER_THRESHOLD ? NAV_BAR_MIN_CENTER_Y   : NAV_BAR_MAX_CENTER_Y;
    
    NSLog(@"-----Correct Center : %f",correctCenter);
    if (centerY != NAV_BAR_MAX_CENTER_Y && centerY != NAV_BAR_MIN_CENTER_Y) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
            [self.navigationController.navigationBar setCenter:CGPointMake(self.navigationController.navigationBar.center.x, correctCenter)];
            [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:1 alpha: (correctCenter - NAV_BAR_MIN_CENTER_Y) / NAV_BAR_HEIGHT]];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:(correctCenter - NAV_BAR_MIN_CENTER_Y) / NAV_BAR_HEIGHT]}];
        } completion:nil];
        
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
