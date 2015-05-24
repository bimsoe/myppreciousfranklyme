//
//  ViewController.m
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 21/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableCell.h"
#import "CelebView.h"
#import "ServerDataManager.h"
#import "Reachability.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CelebDelegate, CelebCategoryRowProtocol>
{
  UIRefreshControl *refreshControl;
  NSMutableArray *filteredArray;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *celebCategoriesData;
@property (nonatomic, strong, readonly) Reachability *reachability; /**< Whether network is reachable or not */

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.searchBar setDelegate:self];
  [self setUpUISettings];
  [self fetchCelebsData];
  
  
  //reachability
  _reachability = [Reachability reachabilityForInternetConnection];
  [self.reachability startNotifier];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAndShowNetworkIssueAlert) name:kReachabilityChangedNotification object:nil];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)checkAndShowNetworkIssueAlert
{
  if (self.reachability.currentReachabilityStatus == NotReachable) {
    [self displayAlertWithTitle:@"No Connectivity" message:@"You have lost data connectivity"];
  }
}


- (void)setUpUISettings
{
  [self.mainTableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
  if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
    [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
  }
  [[UITableView appearance] setSeparatorColor:[UIColor lightGrayColor]];
  [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
  
  // Do any additional setup after loading the view, typically from a nib.
  [self addPullToRefresh];  
}


//using completion blocks rather than delegates
- (void)fetchCelebsData
{
  [[ServerDataManager sharedManager] fetchCelebsInfoForAllCategories:nil
                                                     completionBlock:^(NSArray *celebCategories, NSError *error) {
                                                       _celebCategoriesData = celebCategories;
                                                       if (error) {
                                                         [self checkAndShowNetworkIssueAlert];
                                                       }

                                                       [refreshControl endRefreshing];
                                                       [self.mainTableView reloadData];
                                                     }];
}


- (void)addPullToRefresh
{
  refreshControl = [[UIRefreshControl alloc] init];
  refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
  [refreshControl setTintColor:[UIColor whiteColor]];
  [refreshControl addTarget:self action:@selector(fetchCelebsData) forControlEvents:UIControlEventValueChanged];
  [self.mainTableView addSubview:refreshControl];
  
}


//might be filtered or unfiltered
- (NSArray *)celebCategoriesData
{
  if (filteredArray) {
    return filteredArray;
  }
  return _celebCategoriesData;
}


- (CelebData *)celebDataAtIndexPath:(NSIndexPath *)indexPath
{
  NSArray *celebsCatArray = self.celebCategoriesData;
  if (celebsCatArray.count > indexPath.section) {
    CelebCategory *celebCategory = celebsCatArray[indexPath.section];
    if (celebCategory.celebs.count > indexPath.item) {
      return celebCategory.celebs[indexPath.item];
    }
  }
  //out of bounds
  return nil;
}

//called when image is downloaded or some reload is required
- (void)reloadCelebViewAtIndexPath:(NSIndexPath *)indexPathOfCelebCell
{
  //get the table cell first
  CustomTableCell *cell = (CustomTableCell *)[self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexPathOfCelebCell.section inSection:0]];
  //now get the CelebView
  [[cell celebViewCellAtIndex:indexPathOfCelebCell.item] refresh];
}


#pragma mark - Table View Delegates -

#pragma mark - Table View DataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.celebCategoriesData.count;//for now
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CustomCellIdentifier = @"CustomTableCell";
  CustomTableCell *customCell = [self.mainTableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
  if (customCell.celebCategoryRowDataSource == nil) {
    customCell.celebCategoryRowDataSource = self;
  }  
  [customCell setRowNumber:indexPath.row];
  return customCell;
}


#pragma mark - CelebDelegate -
- (void)celebFollowButtonPressedAtIndexPath:(NSIndexPath *)indexPath
{
  [self displayAlertWithTitle:@"Feature Unavailable" message:@"This feature is currently not available!"];
}

- (void)celebImageTappedAtIndexPath:(NSIndexPath *)indexPath
{
  CelebData *celebData = [self celebDataAtIndexPath:indexPath];
  [self displayAlertWithTitle:celebData.celebDisplayName message:celebData.celebBio];
}


- (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message
{
  if ([UIAlertController class]) {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
  } else {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alertView show];
  }
}


#pragma mark - CelebCategoryRowProtocol -
- (CelebData *)dataForCelebAtIndexPath:(NSIndexPath *)indexPath
{
  CelebData *celebData = [self celebDataAtIndexPath:indexPath];
  NSAssert(celebData, @"Can't be nil");
  //check if image is available
  if (celebData.celebImage == nil) {
    //initiate download
    [[ServerDataManager sharedManager] downloadImageForCeleb:celebData completionBlock:^(NSError *error) {
      if (error == nil) {
        //reload
        [self reloadCelebViewAtIndexPath:indexPath];
      }
    }];
  }
  return celebData;
}

- (NSInteger)numberOfItemsForRow:(NSInteger)row
{
  CelebCategory *celebCategory = self.celebCategoriesData[row];
  return celebCategory.celebs.count;
}

- (NSString *)captionForRow:(NSInteger)row
{
  CelebCategory *celebCategory = self.celebCategoriesData[row];
  return celebCategory.celebCategoryName;
}

#pragma mark - UISearchBarDelegate -
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
  if (searchBar.text.length == 0) {
    filteredArray = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
  }
  [self.mainTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  [searchBar setText:@""];
  [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  //popultae fitlered array
  NSString *searchString = self.searchBar.text; //not checking for empty space right now
  filteredArray = [NSMutableArray arrayWithCapacity:_celebCategoriesData.count];
  //apply filters
  for (CelebCategory *celebCategory in _celebCategoriesData) {
    //check if category name contains that text
    if ([celebCategory.celebCategoryName containsString:searchString]) {
      //add it
      [filteredArray addObject:celebCategory];
    } else {
      //browse throught the CelebData objects
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.celebDisplayName contains[cd] %@", searchString];
      NSArray *matchingArray = [celebCategory.celebs filteredArrayUsingPredicate:predicate];
      if (matchingArray.count) {
        //create and add category
        CelebCategory *celebCat = [[CelebCategory alloc] init];
        celebCat.celebCategoryName = celebCategory.celebCategoryName;
        celebCat.celebs = matchingArray;
        [filteredArray addObject:celebCat];
      }
    }
  }
  [searchBar resignFirstResponder];
  [searchBar setShowsCancelButton:YES animated:YES];
}
@end
