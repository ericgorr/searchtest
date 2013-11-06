//
//  ELIZAppDelegate.m
//  search test
//
//  Created by Eric Gorr on 11/5/13.
//  Copyright (c) 2013 Eric Gorr. All rights reserved.
//

#import "ELIZAppDelegate.h"

@implementation ELIZAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSBundle* mainBundle = [NSBundle mainBundle];
	
	NSURL*		docURL				= [mainBundle URLForResource:@"message" withExtension:@"emlx"];
	NSString*	homePath			= NSHomeDirectory();
	NSURL*		homeURL				= [NSURL fileURLWithPath:homePath];
	NSString*   searchIndexName     = @"index.idx";
	NSURL*		indexURL			= [homeURL URLByAppendingPathComponent:searchIndexName];
	
	SKIndexRef  searchIndexFile;
	
    SKLoadDefaultExtractorPlugIns();
    
    NSDictionary*   textAnalysisOptions = @{ (__bridge NSString*)kSKProximityIndexing : @YES };
    
    [[NSFileManager defaultManager] removeItemAtURL:indexURL error:nil];
    
    searchIndexFile = SKIndexCreateWithURL( (__bridge CFURLRef)indexURL, (__bridge CFStringRef)searchIndexName, kSKIndexInverted, (__bridge CFDictionaryRef)textAnalysisOptions );

    NSLog( @"Index Exists: %d", [[NSFileManager defaultManager] fileExistsAtPath:[indexURL path]] );
    NSLog( @"Message Exists: %d", [[NSFileManager defaultManager] fileExistsAtPath:[docURL path]] );
    
    CFURLRef        fullMessageURLRef           = (CFURLRef)CFBridgingRetain( docURL );
    SKDocumentRef   doc                         = SKDocumentCreateWithURL ( fullMessageURLRef );
    
    SKIndexAddDocument( searchIndexFile, doc, NULL, false );
    
    NSLog( @"added" );
}

@end
