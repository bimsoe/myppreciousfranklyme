//
//  ViewController.m
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 21/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableCell.h"
#import "CelebCollectionCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - Table View Delegates -


#pragma mark - Table View DataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 10;//for now
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CustomCellIdentifier = @"CustomTableCell";
  CustomTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
  if (customCell.collectionDelegate == nil) {
    customCell.collectionDelegate = self;
  }
  [customCell.horizontalCollectionView setContentOffset:CGPointZero];
  return customCell;
}



#pragma mark - UICollectionViewDelegateFlowLayout -

#pragma mark - UICollectionViewDataSource -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return 20;// for now
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CustomCellIdentifier = @"CelebCollectionCell";
  CelebCollectionCell *celebCell = [collectionView dequeueReusableCellWithReuseIdentifier:CustomCellIdentifier forIndexPath:indexPath];
  return celebCell;
}


@end
