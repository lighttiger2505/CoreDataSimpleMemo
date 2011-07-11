//
//  DetailViewController.h
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/06/16.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 メモを編集するビューのコントローラー
 */
@interface MemoEditorViewController : UIViewController <UITextViewDelegate>{
	UITextView *textView;
	NSManagedObject *memo;
}

@property(nonatomic, retain) UITextView *textView;
@property(nonatomic, retain) NSManagedObject *memo;

- (void)saveMemo;
- (void)deleteMemo;

@end
