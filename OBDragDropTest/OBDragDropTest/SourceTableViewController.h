//
//  SourceTableViewController.h
//  OBDragDropTest
//
//  Created by Zai Chang on 3/10/15.
//  Copyright (c) 2015 Oblong Industries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBDragDropManager.h"


// An example of allowing drag and drop from a UITableView
//
// The view needs to persist throughout the drag and drop gesture
// in which the source of a drag object does not need to persist
// through the duration of the drag and drop gesture

@interface SourceTableViewController : UITableViewController <OBOvumSource>

@end
