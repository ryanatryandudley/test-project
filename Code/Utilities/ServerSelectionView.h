//
//  ServerSelectionView.h
//  MLB
//
//  Created by Ryan Dudley 
//
//

#import <UIKit/UIKit.h>

@interface ServerSelectionView : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	NSMutableArray* _dataSource;
	void(^_onSelect)(NSString* selection, BOOL save);
}

// tableview of servers
@property (nonatomic, assign) IBOutlet UITableView* serverList;
@property (nonatomic, assign) IBOutlet UISwitch* saveSelection;

// returns a server selector view with the passed in servers
+(id) serverSelectionView: (NSDictionary*)servers onSelect:(void(^)(NSString* selection, BOOL save))onSelect;

@end
