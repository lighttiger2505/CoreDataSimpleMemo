    //
//  DetailViewController.m
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/06/16.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import "MemoEditorViewController.h"


@implementation MemoEditorViewController

@synthesize textView;
@synthesize memo;

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	textView = nil;
}


- (void)dealloc {
	[textView release];
	[memo release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

/**
 ビューのロード後に呼び出される。
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = [self.memo valueForKey:@"text"];
	
	// ナビゲーションバー右にキーボードを隠すボタンを追加
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																							target:self 
																							action:@selector(finish:)] autorelease];
	
	// テキスト入力のビューを作成して親のビューに追加。
	UITextView *aTextView = [[UITextView alloc] init];
	aTextView.frame = [[UIScreen mainScreen] bounds];
	aTextView.font = [UIFont systemFontOfSize:20.0f];
	aTextView.scrollEnabled = YES;
	aTextView.delegate = self;
	self.textView = aTextView;
	[self.view addSubview:self.textView];
	[aTextView release];
}

/**
 ビューを開いた際に呼び出される。
 渡されたメモの内容を反映。
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	
	// 渡されたオブジェクトからメモの内容を表示させる。
	self.textView.text = [memo valueForKey:@"text"];
	// テキストを編集状態にする
	[self.textView becomeFirstResponder];
}

/**
 ビューを閉じた際に呼び出される。
 メモの保存を実行。
 */
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:YES];
	
	// メモの保存を実行。
	[self saveMemo:nil];
}

/**
 メモを保存する。
 */
- (void)saveMemo:(id)sender {
	// 変更内容をデータオブジェクトに反映。
	[self.memo setValue:self.textView.text forKey:@"text"];
	
	// コンテキストに保存内容を反映。
	NSError *error;
	if (![[self.memo managedObjectContext] save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}



/**
 テキスト編集開始時に呼び出されるメソッド
 */
- (void)textViewDidBeginEditing:(UITextView *)handleTextView {
	// このメソッドの送信元がメモの編集ビューならば
	if(handleTextView == self.textView) {
		// ビューのサイズをキーボードで隠れない程度に小さくする
		CGRect  frame;
		frame.origin.x = 0 ;
		frame.origin.y = 0 ;
		frame.size.width = 320 ;
		frame.size.height = 232 ;
		
		handleTextView.frame = frame ;
	}
}

/**
 テキスト編集終了時に呼び出されるメソッド
 */
- (void)textViewDidEndEditing:(UITextView *)handleTextView {
	// このメソッドの送信元がメモの編集ビューならば
	if(handleTextView == self.textView) {
		// ビューのサイズを画面一杯のサイズに戻す
		CGRect  frame;
		frame.origin.x = 0 ;
		frame.origin.y = 0 ;
		frame.size.width = 320 ;
		frame.size.height = 480 ;
		
		handleTextView.frame = frame ;
	}
}

/**
 右上のボタンを押すことでで実行されるコマンド
 */
-(IBAction)finish:(id)sender {
	// キーボードを隠す処理
	[textView resignFirstResponder];
}

@end
