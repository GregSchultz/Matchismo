//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Greg Schultz on 2/3/13.
//  Copyright (c) 2013 Greg Schultz. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@property (readwrite, strong, nonatomic) NSString *lastFlipResult;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define THREE_CARD_MATCH_BONUS 6
#define THREE_CARD_MISMATCH_PENALTY 1
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index]; // get reference to most flipped card
    if (card && !card.isUnplayable) { // check that is valid reference and card is not unplayable
        if (!card.isFaceUp) { // check that the clicked card is not already faceUp.
            for (Card *otherCard in self.cards) {  // loop through current card deck checking for matches
                if (otherCard.isFaceUp && !otherCard.isUnplayable){ // is card in deck flipped and not already matched, check for match
                    int matchScore = [card match:@[otherCard]]; // check for match to last flipped card
                    if (matchScore) {  // they matched...
                        if (self.isThreeCardMatchMode) { // if first two matched, then check if in 3 card mode..
                            for (Card *thirdCard in self.cards) { // loop through current card deck checking for matches
                                if (thirdCard.isFaceUp && !thirdCard.isUnplayable && !([otherCard.contents isEqualToString:thirdCard.contents])) {
                                    // we have a playable, faceUp card and it is not the 2nd card
                                    // now check the match score for all three cards
                                    //int matchThreeScore = [card match:@[otherCard, thirdCard]];
                                    int matchThreeScore = [card match:@[thirdCard]];
                                    if (matchThreeScore) {  // if flipped card matched 3rd flipped card
                                        // all three cards match (in rank or suit)
                                        card.unplayable = YES;
                                        otherCard.unplayable = YES;
                                        thirdCard.unplayable = YES;
                                        self.score += matchThreeScore * MATCH_BONUS;
                                        self.lastFlipResult = [NSString stringWithFormat:@"Matched %@, %@ & %@ for %d points", card.contents, otherCard.contents, thirdCard.contents, matchThreeScore * MATCH_BONUS];

                                    } else {
                                        // no three-card-match
                                        otherCard.faceUp = NO;
                                        thirdCard.faceUp = NO;
                                        self.score -= MISMATCH_PENALTY;
                                        self.lastFlipResult = [NSString stringWithFormat:@"%@, %@ & %@ don't match! %d point penalty!", card.contents, otherCard.contents, thirdCard.contents, MISMATCH_PENALTY];

                                    }
                                    break;
                                }
                            }
                        } else {
                            card.unplayable = YES;
                            otherCard.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                            self.lastFlipResult = [NSString stringWithFormat:@"Matched %@ & %@ for %d points", otherCard.contents, card.contents, matchScore * MATCH_BONUS];
                        }
                    } else {
                        otherCard.faceUp = NO; // flip the card back over
                        //card.faceUp = !card.faceUp;
                        self.score -= MISMATCH_PENALTY;
                        self.lastFlipResult = [NSString stringWithFormat:@"%@ & %@ don't match! %d point penalty!", otherCard.contents, card.contents, MISMATCH_PENALTY];
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.faceUp; // flip the card back over
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *) deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
            
        }
        self.score = 0;
        self.threeCardMatchMode = FALSE;
    }
    
    return self;
}

@end
