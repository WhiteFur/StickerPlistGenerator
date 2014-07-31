//
//  main.m
//  StickerPlistGenerator
//
//  Created by Lin Cheng Kai on 13/7/18.
//  Copyright (c) 2013年 Lin Cheng Kai. All rights reserved.
//
//The project is used to generate Stickers.plist file for weiwha project.
//TEST_STICKER block is for testSticker2 branch, and the other is for master branch.

#import <Foundation/Foundation.h>
//#define TEST_ANIMATION 1
#define NO_FILE_EXTENSION

typedef enum
{
    StickerTypeNormal, //角色貼圖
    StickerTypeBGImage, //漫畫背景圖
    StickerTypeCamera, //photo
    StickerTypeIcon, //圖包 icon
}StickerType;

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        // insert code here...
        
#ifdef TEST_STICKER
        NSArray *directories = @[@"/Users/whiteFur/Dropbox/Coscomic/iPhone尺寸/初音_01-24",
                                 @"/Users/whiteFur/Dropbox/Coscomic/iPhone尺寸/正太_01-24"];
        NSMutableArray *fileNames = [NSMutableArray array];
        NSError *error = nil;
        for(NSString *direcotry in directories)
        {
            NSArray *filePaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:direcotry error:&error];
            
            for(NSString *path in filePaths)
                [fileNames addObject:[[NSFileManager defaultManager] displayNameAtPath:path]];
        }
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:fileNames options:0 error:&error];
        [data writeToFile:@"/Users/whiteFur/Desktop/project/weiwha/weiwha/sticker.json" atomically:YES];
#elif TEST_ANIMATION
        NSFileManager *fm = [NSFileManager defaultManager];
        NSURL *direcotryURL = [NSURL fileURLWithPath:@"/Users/whiteFur/Dropbox/Coscomic/iPhone尺寸_ 動畫"];
        NSDirectoryEnumerator *dirEnumerator = [fm enumeratorAtURL:direcotryURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsSubdirectoryDescendants errorHandler:nil];
        
        NSMutableArray *packages = [NSMutableArray array];
        for(NSURL *packageURL in dirEnumerator)
        {
            NSDirectoryEnumerator *packageDirEnumerator = [fm enumeratorAtURL:packageURL
                                                   includingPropertiesForKeys:nil
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                           | NSDirectoryEnumerationSkipsSubdirectoryDescendants
                                                                 errorHandler:nil];
            
            NSMutableArray *stickers = [NSMutableArray array];
            for(NSURL *stickersDirURL in packageDirEnumerator)
            {
                NSError *error = nil;
                NSArray *paths = [fm contentsOfDirectoryAtPath:stickersDirURL.path error:&error];
                NSDictionary *sticker = @{@"sid" : stickersDirURL.lastPathComponent,
                                          @"paths" : paths};
                [stickers addObject:sticker];
            }
            
            NSDictionary *package = @{@"pid": packageURL.lastPathComponent,
                                      @"stckers": stickers};
            [packages addObject:package];
        }
        
        [packages writeToFile:@"/Users/whiteFur/Desktop/project/weiwha/weiwha/Stickers.plist" atomically:YES];
#else
        //---最上層資料夾下的
        NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSUserDirectory inDomains:NSLocalDomainMask];
        NSURL *userURL = [urls lastObject];
        NSURL *topDir = [userURL URLByAppendingPathComponent:@"whiteFur/Dropbox/domiso/Stickers" isDirectory:YES];
        NSError *error = nil;
        NSArray *categoryURLs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:topDir includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
        //---
        if(error)
            NSLog(@"圖包 error: %@", error);
        else
        {
            NSMutableArray *packages = [NSMutableArray array];
            //Stickers Dir
            for(NSURL *categoryURL in categoryURLs)
            {
                //directories in BG & Normal (Free & Charge)
                NSArray *paymentDirs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:categoryURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
                if(error)
                    NSLog(@"payment dirs error: %@", error);
                else
                {
                    for(NSURL *paymentURL in paymentDirs)
                    {
                        NSError *error = nil;
                        NSArray *packageDirs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:paymentURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
                        
                        if(error)
                            NSLog(@"packagesDirs error: %@", error);
                        else
                        {
                            for(NSURL *packageURL in packageDirs)
                            {
                                NSMutableDictionary *packageInfo = [NSMutableDictionary dictionary];
                                
                                NSString *pid = [packageURL lastPathComponent];
                                [packageInfo setObject:pid forKey:@"pid"];
                                
                                if([[categoryURL lastPathComponent] isEqualToString:@"BG"])
                                    [packageInfo setObject:@(StickerTypeBGImage) forKey:@"type"];
                                else
                                    [packageInfo setObject:@(StickerTypeNormal) forKey:@"type"];
                                
                                //---order
                                NSUInteger order = 9999;
                                if([pid rangeOfString:@"Kii"].location != NSNotFound)
                                    order = 0;
                                else if([pid rangeOfString:@"Prince"].location != NSNotFound)
                                    order = 1;
                                else if([pid rangeOfString:@"Amei"].location != NSNotFound)
                                    order = 2;
                                else if([pid rangeOfString:@"Guy"].location != NSNotFound)
                                    order = 3;
                                else if([pid rangeOfString:@"SnowWhite"].location != NSNotFound)
                                    order = 4;
                                else if([pid rangeOfString:@"Shouta"].location != NSNotFound)
                                    order = 5;
                                else if([pid rangeOfString:@"Jenny"].location != NSNotFound)
                                    order = 6;
                                else if([pid rangeOfString:@"moustache"].location != NSNotFound)
                                    order = 7;
                                else if ([pid rangeOfString:@"BG"].location != NSNotFound)
                                    order = 10000;
                                [packageInfo setObject:@(order) forKey:@"order"];
                                //---
                                
                                
                                
                                //各角色資料夾下的
                                NSArray *URLs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:packageURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
                                if(error)
                                    NSLog(@"contentsOfDirectoryAtURL:packageURL :%@", error);
                                else
                                {
                                    NSMutableArray *stickers = [NSMutableArray array];
                                    for(NSURL *url in URLs)
                                    {
                                        //btn dir
                                        if([url.lastPathComponent isEqualToString:@"btn"])
                                        {
                                            NSDirectoryEnumerator *btnEnumerator = [[NSFileManager defaultManager] enumeratorAtURL:url includingPropertiesForKeys:nil options:0 errorHandler:^BOOL(NSURL *url, NSError *error) {
                                                NSLog(@"btn enumerator error: %@", error);
                                                return NO;
                                            }];
                                            for(NSURL *btnURL in btnEnumerator)
                                            {
                                                //---sticker icon on toolbar of Editor
                                                NSString *filename = [btnURL.lastPathComponent stringByDeletingPathExtension];
                                                if([filename hasSuffix:@"0"])
                                                    [packageInfo setObject:filename forKey:@"dark_icon"];
                                                else
                                                    [packageInfo setObject:filename forKey:@"light_icon"];
                                                //----
                                            }
                                        }
                                        //DL dir
                                        else if([[url lastPathComponent] isEqualToString:@"DL"])
                                        {
                                            NSDirectoryEnumerator *dlEnumerator = [[NSFileManager defaultManager] enumeratorAtURL:url includingPropertiesForKeys:nil options:0 errorHandler:^BOOL(NSURL *url, NSError *error) {
                                                NSLog(@"DL enumerator error: %@", error);
                                                return NO;
                                            }];
                                            
                                            for(NSURL *imgURL in dlEnumerator)
                                            {
                                                NSString *filename = [imgURL.lastPathComponent stringByDeletingPathExtension];
                                                
                                                StickerType type = StickerTypeNormal;
                                                if([[categoryURL lastPathComponent] isEqualToString:@"BG"])
                                                    type = StickerTypeBGImage;
                                                [stickers addObject:@{@"sid": filename, @"free": @(NO), @"type": @(type)}];
                                            }
                                        }
                                        else
                                        {
#ifdef NO_FILE_EXTENSION
                                            NSString *filename = [url.lastPathComponent stringByDeletingPathExtension];
#else
                                            NSString *filename = url.lastPathComponent;
#endif
                                            BOOL free = YES;
                                            StickerType type = StickerTypeNormal;
                                            
                                            if([[paymentURL lastPathComponent] isEqualToString:@"Charge"])
                                                free = NO;
                                            if([[categoryURL lastPathComponent] isEqualToString:@"BG"])
                                                type = StickerTypeBGImage;
                                            [stickers addObject:@{@"sid": filename, @"free": @(free), @"type":@(type)}];
                                        }
                                    }
                                    [packageInfo setObject:stickers forKey:@"stickers"];
                                }
                                [packages addObject:packageInfo];
                            }
                            
                        }
                    }
                }
            }
            
            [packages sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
            [packages writeToFile:@"/Users/whiteFur/Dropbox/domiso/weiwha/weiwha/Stickers.plist" atomically:YES];
        }
#endif
    }
    return 0;
}

