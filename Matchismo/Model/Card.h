//
//  Card.h
//  Matchismo
//
//  Created by Greg Schultz on 2/3/13.
//  Copyright (c) 2013 Greg Schultz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;

- (int)match:(NSArray *)otherCards;

@end
