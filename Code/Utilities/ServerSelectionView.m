//
//  ServerSelectionView.m
//  Created by Ryan Dudley
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import "ServerSelectionView.h"

#define ccSelectionSave @"ccSavedServerSelection"

@implementation ServerSelectionView

// create the selection view
+ (id) serverSelectionView: (NSDictionary*)servers onSelect:(void(^)(NSString* selection, BOOL save))onSelect {
	// create the view
	ServerSelectionView* view = [[[ServerSelectionView alloc] initWithNibName:nil bundle:nil] autorelease];

	// add the servers
	view->_dataSource = [[NSMutableArray alloc] init];
	view->_onSelect = [onSelect copy];
	[servers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		[view->_dataSource addObject:key];
	}];
	
	return view;
}

-(void) dealloc {
	[_onSelect release];
	[_dataSource release];
	[super dealloc];
}

// datasource for table - sort & return the length
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	[_dataSource sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [obj1 compare:obj2];
	}];
	return [_dataSource count];
}

// datasource for table - create a cell with the name of the server
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString* cellIdentifier = @"ServerCell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	
    cell.textLabel.text = _dataSource[[indexPath indexAtPosition:[indexPath length]-1]];
    cell.accessoryType = UITableViewCellAccessoryNone;
	
    return cell;
}

// give it a header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Select a Server";
}

// NO EDITING
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

// NO MOVING
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

// on selection, continue with the game
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* file = _dataSource[[indexPath indexAtPosition:[indexPath length]-1]];
	_onSelect(file, self.saveSelection.on);
}

@end
