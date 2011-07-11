//
//  MemoViewController.m
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/06/16.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import "MemoTableViewController.h"

#import "MemoEditorViewController.h"

@implementation MemoTableViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	fetchedResultsController = nil;
	managedObjectContext = nil;
}


- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"メモ";
	
	// ナビゲーションバーに編集ボタンを作成。
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

	// ナビゲーションバーに追加ボタンを作成。
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																			   target:self 
																			   action:@selector(addMemo:)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
}

/*
 ビューを開いた際に呼び出される。
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// データの読み込み。
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
	
	// テーブルビューに内容を反映。
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Adding a Student

/**
 メモの追加処理を行う。
 */
- (IBAction)addMemo:sender
{
	// 追加用ビューを作成。
	MemoEditorViewController *detailViewController = [[MemoEditorViewController alloc] init];
	
	// メモのエンティティを追加。
	detailViewController.memo = [NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:self.managedObjectContext];
	
	// モーダルで追加メモの編集ビューを表示
    [self.navigationController pushViewController:detailViewController animated:YES];
	
	[detailViewController release];
}

#pragma mark -
#pragma mark Table view data source

/**
 セクション数を返すデリゲートの実装。
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

/**
 セクション内のデータ数を返すデリゲートの実装。
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

/**
 引数に渡されたセルの情報を編集して返すデリゲートの実装。
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
	NSString *text = [[managedObject valueForKey:@"text"] description];
    cell.textLabel.text = text;
	
    return cell;
}

/**
 セルの内容を編集
 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
	NSString *text = [[managedObject valueForKey:@"text"] description];
    cell.textLabel.text = text;
}

#pragma mark -
#pragma mark Table view delegate

/**
 引数に渡されたセルをタップした際のイベントを定義するデリゲートの実装。
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // 選択したセルの情報の詳細表示ビューを作成して、そのビューに移動。
    MemoEditorViewController *detailViewController = [[MemoEditorViewController alloc] init];
	detailViewController.memo = [self.fetchedResultsController objectAtIndexPath:indexPath];
	[self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
}

#pragma mark - Fetched results controller   

/**
 フェッチのコントローラーを作成する。
 */
- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController != nil)
    {
        return fetchedResultsController;
    }
	
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // データを取得するエンティティを指定
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // 取得するデータの並び順を指定
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // フェッチのコントローラーを作成
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
	// フェッチを実行する。
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
		
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return fetchedResultsController;
}   


@end

