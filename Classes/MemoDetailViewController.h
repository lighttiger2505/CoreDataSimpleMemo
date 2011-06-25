//
//  DetailViewController.h
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/06/16.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MemoDetailViewController : UIViewController {
	UITextView *textView;
	NSManagedObject *memo;
}

@property(nonatomic, retain) UITextView *textView;
@property(nonatomic, retain) NSManagedObject *memo;

- (void)saveMemo:(id)sender;

@end
