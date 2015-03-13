//
//  SourceTableViewController.m
//  OBDragDropTest
//
//  Created by Zai Chang on 3/10/15.
//  Copyright (c) 2015 Oblong Industries. All rights reserved.
//

#import "SourceTableViewController.h"


@interface SourceTableViewController ()
{
  NSMutableArray *sources;
}

@end


static NSString *kCellIdentifier = @"cell";

@implementation SourceTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];

  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
  
  sources = [[NSMutableArray alloc] init];
  
  for (NSInteger i=0; i<30; i++) {
    CGFloat r = (float)rand() / RAND_MAX;
    CGFloat g = (float)rand() / RAND_MAX;
    CGFloat b = (float)rand() / RAND_MAX;
    
    UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
    [sources addObject:color];
  }
  [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dismiss {
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];

  // Configure the cell...
  UIColor *dataObject = sources[indexPath.row];
  cell.backgroundColor = dataObject;
  cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
  cell.selectedBackgroundView.backgroundColor = cell.backgroundColor;

  // Drag drop with long press gesture
  //
  // Be careful with attaching gesture recognizers inside tableView:cellForRowAtIndexPath: as cells
  // get reused. Add a check to prevent multiple gesture recognizers from being added to the same cell.
  // The below check is crude but works; you may need something more specific or elegant.
  if (cell.gestureRecognizers.count == 0) {
    OBDragDropManager *dragDropManager = [OBDragDropManager sharedManager];
    UIGestureRecognizer *recognizer = [dragDropManager createLongPressDragDropGestureRecognizerWithSource:self];
    [cell addGestureRecognizer:recognizer];
  }

  return cell;
}

-(OBOvum *) createOvumFromView:(UIView*)sourceView
{
  OBOvum *ovum = [[OBOvum alloc] init];
  ovum.dataObject = sourceView.backgroundColor;
  return ovum;
}


-(UIView *) createDragRepresentationOfSourceView:(UIView *)sourceView inWindow:(UIWindow*)window
{
  CGRect frame = [sourceView convertRect:sourceView.bounds toView:sourceView.window];
  frame = [window convertRect:frame fromWindow:sourceView.window];
  
  UIView *dragView = [[UIView alloc] initWithFrame:frame];
  dragView.backgroundColor = sourceView.backgroundColor;
  dragView.layer.cornerRadius = 5.0;
  dragView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
  dragView.layer.borderWidth = 1.0;
  dragView.layer.masksToBounds = YES;
  return dragView;
}


-(void) dragViewWillAppear:(UIView *)dragView inWindow:(UIWindow*)window atLocation:(CGPoint)location
{
  dragView.transform = CGAffineTransformIdentity;
  dragView.alpha = 0.0;
  
  [UIView animateWithDuration:0.25 animations:^{
    dragView.center = location;
    dragView.transform = CGAffineTransformMakeScale(0.80, 0.80);
    dragView.alpha = 0.75;
  }];
}

// Called regardless of whether the ovum drop was successful or cancelled
-(void) ovumDragEnded:(OBOvum*)ovum
{
}

@end
