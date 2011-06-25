    //
//  AddViewController.m
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/06/16.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import "MemoAddViewController.h"

@implementation MemoAddViewController

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

/**
 ビューのロード後に実行。初期化処理。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// ビューのタイトル設定。
	self.title = @"メモを追加";
	
	// ナビゲーションバーにボタンとアクションを追加。
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																						   target:self action:@selector(cancel:)] autorelease];
	
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																							target:self action:@selector(save:)] autorelease];
	[self setEditing:YES animated:NO];
}

/**
 ビューを閉じた際に呼び出される。メモの保存を実行
 */
- (void)viewWillDisappear:(BOOL)animated {
	//オーバーライドで保存の実行を拒否
}

#pragma mark -
#pragma mark Save and cancel operations

/**
 メモ追加をキャンセル。
 */
- (IBAction)cancel:(id)sender {
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
	// 追加したオブジェクトを削除
	[[self.memo managedObjectContext] deleteObject:memo];
	
}

/**
 追加のメモを保存。
 */
- (IBAction)save:(id)sender {
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
	// 保存を実行
	[self saveMemo:sender];
}

@end
