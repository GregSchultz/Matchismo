//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Greg Schultz on 2/3/13.
//  Copyright (c) 2013 Greg Schultz. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchStatus;
@property (nonatomic) int flipCount;
@property (nonatomic) BOOL threeCardMatchMode;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeControl;

@property (strong, nonatomic) CardMatchingGame *game;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[PlayingCardDeck alloc] init]];
                             
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void) updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
        
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.matchStatus.text = self.game.lastFlipResult;
}

- (void) setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}


- (IBAction)flipCard:(UIButton *)sender
{    
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

- (IBAction)deal:(UIButton *)sender {
    [self setGame:[[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                    usingDeck:[[PlayingCardDeck alloc] init]]];    
    self.flipCount = 0;
    self.gameModeControl.enabled = YES;
    [self updateUI];
}

- (IBAction)matchMode:(UISegmentedControl *)sender {
    
    [self.game setThreeCardMatchMode:[sender selectedSegmentIndex] == 0 ? NO : YES];
}

@end
