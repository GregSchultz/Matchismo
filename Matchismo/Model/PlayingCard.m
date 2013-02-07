//
//  PlayingCard.m
//  Matchismo
//
//  Created by Greg Schultz on 2/3/13.
//  Copyright (c) 2013 Greg Schultz. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit; // because we provide setter AND getter

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    if ([otherCards count] == 1) {
        // perform 2 card match
        PlayingCard *otherCard  = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (otherCard.rank == self.rank) {
            score = 4;
        }
    } else if ([otherCards count] == 2) {
        // perform 3 card match
        PlayingCard *secondCard = [otherCards objectAtIndex:0];
        PlayingCard *thirdCard = [otherCards objectAtIndex:1];
        if (([self.suit isEqualToString:secondCard.suit]) && ([secondCard.suit isEqualToString:thirdCard.suit])) {
            score = 8;
        } else if ((self.rank == secondCard.rank) && (secondCard.rank == thirdCard.rank)) {
            score = 16;
        }
    }
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];    
}

+ (NSArray *)validSuits {
    
    //static NSArray *validSuits = nil;
    //if (!validSuits) validSuits = @[@"♥",@"♦",@"♠",@"♣"];
    //return validSuits;
    return @[@"♥",@"♦",@"♠",@"♣"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

+ (NSArray *)rankStrings
{    
    //static NSArray *rankStrings = nil;
    //if (!rankStrings) rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    //return rankStrings;
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
    return [self rankStrings].count-1;
}


@end
