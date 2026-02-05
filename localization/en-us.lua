return {
    descriptions = {
        Back = {
            b_joey_honkifex = {
                name = 'Honkifex Deck',
                text = {
                    'Starts with a random',
                    '{C:legendary,E:1}Legendary{} Joker,',
                    'final Ante is {C:attention}Ante #1#',
                    '{C:dark_edition,T:tag_joey_successor_reminder}Succesor Tokens: #2#'
                }
            }
        },
        Enhanced = {
            m_joey_joculinewild = {
                name = 'Wild Card',
                text = {
                'Can be used',
                'as any Suit',
                '{C:inactive,s:0.7}(removed along',
                '{C:inactive,s:0.7}with Joculine)'
                }
            } 
        },
        Joker = {
            j_joey_openwater = {
                name = 'Open Water',
                text = {
                    '{X:mult,C:white}X#2#{} Mult',
                    'Base {C:chips}Chips {}are',
                    'set to {C:attention}1{}'
            }},
            j_joey_feltmansion = {
                name = 'Felt Mansion',
                text = {
                    'This joker gains {C:mult}+#1#{} Mult',
                    'for every {C:attention}#2# {C:inactive}[#3#]{C:attention} Aces',
                    'discarded each round',
                    '{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult)'
            }},
            j_joey_braintelephone = {
                name = 'Brain Telephone',
                text = {
                    'After 10 {C:attention}Digits',
                    '{C:inactive}[#1#]',
                    'have been discarded,',
                    'create a {C:spectral}Spectral Card',
                    '{C:inactive}(ranks reset each round)'
                }
            },
            j_joey_brimstone = {
                name = 'Brimstone',
                text = {
                    'Retrigger {C:attention}last played',
                    'card {C:attention}#1#{} #4#. This joker gains',
                    '{C:attention}+#2#{} Trigger per unused discard',
                    'and {C:attention}-#3#{} trigger per discard'
                }
            },
            j_joey_techx = {
                name = 'Tech X',
                text = {
                    'After {C:attention}#1#{} Rounds,',
                    'sell this to',
                    '{C:attention}win the Blind',
                    '{C:inactive}(currently {C:attention}#2#{C:inactive}/{C:attention}#1#{C:inactive})'
                }
            },
            j_joey_tetra = {
                name = 'Tetrachromacy',
                text = {
                    'Creates {C:attention}The Fool',
                    'if played hand contains four',
                    'different scoring {C:attention}Suits',
                    '{C:inactive}(must have room)'
                }
            },
            j_joey_oddments = {
                name = 'Oddments',
                text = {
                    'This joker gains {C:chips}+#2#{} Chips',
                    'per unique scoring {C:attention}Rank{}',
                    'played each round',
                    '{C:inactive}(currently {C:chips}+#1#{C:inactive} Chips)'
                }
            },
            j_joey_kinggila = {
                name = 'Flamethrower',
                text = {
                    'Create a {C:planet}Planet Card',
                    'if score is {C:attention}on fire',
                    '{C:inactive}(must have room)'
                }
            },
            j_joey_mmfood = {
                name = 'MM..FOOD',
                text = {
                    'Copies the ability',
                    'of {C:attention}Food Jokers'
                }
            },
            j_joey_robotstop = {
                name = 'Robot Stop',
                text = {
                    '{C:attention}Retrigger{} each played card',
                    'if number of cards {C:attention}in full deck',
                    'is a multiple of {C:attention}#1#{C:inactive}#2#'
                }
            },
            j_joey_icev = {
                name = 'Ice V',
                text = {
                    'Create an {C:attention}Economy Tag {}if',
                    'played hand contains a {C:attention}Lucky 7',
                    'and an {C:attention}Ace of Spades'
                }
            },
            j_joey_draculadrug = {
                name = 'Dracula Drug',
                text = {
                    '{C:attention}Removes Enhancements {}from each',
                    'played card in scoring hand,',
                    '{X:mult,C:white}X#1#{} Mult per Enhancement removed',
                    '{C:inactive}(resets each hand)'
                }
            },
            j_joey_avoidaroid = {
                name = 'Avoid-a-Roid',
                text = {
                    '{X:mult,C:white}X#1#{} Mult if played',
                    'hand contains a',
                    '{C:attention}Straight {}with #4# {C:attention}#2#',
                    '{C:inactive}(rank changes every round)'
                }
            },
            j_joey_hazy2 = {
                name = 'Hazy',
                text = {
                    'Earn {C:money}$#2#{} at end of round',
                    'if you scored less than',
                    "{C:attention}last round{}'s score",
                    '{C:inactive}[was #1#]'
                }
            },
            j_joey_economy= {
                name = 'Economy',
                text = {
                    '{C:mult}+#1# {}Mult per {C:money}$',
                    'earned, resets',
                    'at end of round',
                    '{C:inactive}(currently {C:mult}+#2# {C:inactive}mult)'
                }
            },
            j_joey_luckyrainbow = {
                name = 'Lucky Rainbow',
                text = {
                    'Played {C:attention}#3#s{} give',
                    '{C:mult}+#1#{} Mult when scored',
                    '{C:inactive}(rank set when gained)'
                }
            },
            j_joey_zhen = {
                name = 'Z',
                text = {
                    '{C:blue}+1{} Hand per unused',
                    'Hand last round',
                    '{C:inactive}(currently {C:blue}+#1#{C:inactive} hands)'
                }
            },
            j_joey_joculine = {
                name = 'Joculine',
                text = {
                'After #1# {C:inactive}[#2#]{} Rounds, all {C:attention}Cards',
                'in deck become {C:attention}Wild Cards',
                '{C:inactive,s:0.7}(cards unenhanced when this joker is sold)'
                }
            },
            j_joey_riotus = {
                name = 'Riotus',
                text = { 'Each played {V:1}#1# {}gives',
                '{X:mult,C:white}X#2#{} Mult when scored',
                '{C:inactive}(suit changes on trigger)'
                }
            },
            j_joey_mizzlebip = {
                name = 'Mizzlebip',
                text = { '{X:mult,C:white}X#1#{} Mult per scoring {C:attention}Rank {}and',
                '{X:mult,C:white}X#2#{} Mult per scoring {C:attention}Suit',
                'played this round',
                '{C:inactive}(currently {X:mult,C:white}X#3#{C:inactive} Mult and {X:mult,C:white}X#4#{C:inactive} Mult)'
                }
            },
            j_joey_dclussie = {
                name = 'D-Clussie',
                text = {
                    'When {C:attention}Boss Blind {}is',
                    'defeated, {C:green}#1# in 13 chance',
                    'for {C:attention}#2# {}Ante'
                }
            }
        },
        Loot = {
            c_joey_soulheart = {
                name = 'Soul Heart',
                text = {
                    '{C:blue}+1{} Hand',
                    '{C:inactive,s:0.7}({C:attention,s:0.7}#1#{C:inactive,s:0.7} #2# left)'
                }
            },
            c_joey_diceshard = {
                name = 'Dice Shard',
                text = {
                    '{C:red}+1{} Discard',
                    '{C:inactive,s:0.7}({C:attention,s:0.7}#1#{C:inactive,s:0.7} #2# left)'
                }
            },
            c_joey_2cents = {
                name = '2 Cents',
                text = {
                    'Earn {C:money}$2',
                    '{C:inactive,s:0.7}({C:attention,s:0.7}#1#{C:inactive,s:0.7} #2# left)'
                }
            },
            c_joey_3cents = {
                name = '3 Cents',
                text = {
                    'Earn {C:money}$3',
                    '{C:inactive,s:0.7}({C:attention,s:0.7}#1#{C:inactive,s:0.7} #2# left)'
                }
            },
            c_joey_stickynickel = {
                name = 'Sticky Nickel',
                text = {
                    '{C:green}#3# in 2{} chance',
                    'to earn {C:money}$5',
                    '{C:inactive,s:0.7}({C:attention,s:0.7}#1#{C:inactive,s:0.7} #2# left)'
                }
            },
            c_joey_dime = {
                name = 'Dime',
                text = {
                    'Earn {C:money}$10{} when this',
                    'runs out of {C:attention}Uses',
                    '{C:inactive,s:0.7}({C:attention,s:0.7}#1#{C:inactive,s:0.7} #2# left)'
                }
            },
            c_joey_goldbomb = {
                name = 'Gold Bomb',
                text = {
                    '{X:mult,C:white}X#3#{} Mult',
                    '{C:inactive,s:0.7}({C:attention,s:0.7}#1#{C:inactive,s:0.7} #2# left)'
                }
            },
            c_joey_megabomb = {
                name = 'Mega Bomb',
                text = {
                    '{X:mult,C:white}X#3#{} Mult',
                    '{C:inactive,s:0.7}({C:attention,s:0.7}#1#{C:inactive,s:0.7} #2# left)'
                }
            },
            c_joey_bomb = {
                name = 'Bomb',
                text = {
                    '{X:mult,C:white}X#3#{} Mult',
                    '{C:inactive,s:0.7}({C:attention,s:0.7}#1#{C:inactive,s:0.7} #2# left)'
                }
            },
            c_joey_key = {
                name = 'Key',
                text = {
                    'Create a {C:attention}Temporary',
                    '{C:attention}Double Tag',
                    '{C:inactive,s:0.7}({C:attention,s:0.7}#1#{C:inactive,s:0.7} #2# left)'
                }
            },
            c_joey_sack = {
                name = 'Sack',
                text = {
                    'Create a random Consumable',
                    '{C:inactive}({C:tarot}Tarot, {C:planet}Planet,',
                    '{C:spectral}Spectral{C:inactive}, or {V:1}Loot{C:inactive})',
                    '{C:inactive,s:0.7}({C:attention,s:0.7}#1#{C:inactive,s:0.7} #2# left)'
                }
            }
        },
        Tag = {
            tag_joey_successor_reminder = {
                name = 'Successor Tokens',
                text = {
                    'One is awarded upon',
                    'winning a run, and',
                    'one must be spent',
                    'to play this deck'
                }
            },
            tag_joey_temp_double={
                name = "Temp. Double Tag",
                text = {
                    "Gives a copy of the",
                    "next selected {C:attention}Tag{}",
                    "{s:0.8,C:inactive}(removed when blind",
                    "{s:0.8,C:inactive}is selected)"
                },
            },
        },
        Other = {
            joey_credit_conboi = {
                name = 'Credits',
                text = {
                    'Art and effect',
                    'by Conboi'
                }
            },
            joey_info_loot = {
                name = 'Loot Card',
                text = {
                    'Loot cards occupy half',
                    'of a consumable slot.',
                    'You may use {C:attention}#1# {}Loot',
                    'Card(s) each round'
                }
            },
            p_joey_lootpack1 = {
                name = 'Loot Pack',
                text = {
                    'Choose up to {C:attention}#2#',
                    'of {C:attention}#1#{} Loot Cards'
                }
            },
            p_joey_lootpack2 = {
                name = 'Loot Pack',
                text = {
                    'Choose up to {C:attention}#2#',
                    'of {C:attention}#1#{} Loot Cards'
                }
            },
            p_joey_jumbolootpack = {
                name = 'Jumbo Loot Pack',
                text = {
                    'Choose up to {C:attention}#2#',
                    'of {C:attention}#1#{} Loot Cards'
                }
            },
            p_joey_megalootpack = {
                name = 'Mega Loot Pack',
                text = {
                    'Choose up to {C:attention}#2#',
                    'of {C:attention}#1#{} Loot Cards'
                }
            },
        }
    },
    misc = {
        dictionary = {
            k_joey_lootpack = 'Loot Pack',
            k_joey_jumbolootpack = 'Jumbo Loot Pack',
            k_joey_megalootpack = 'Mega Loot Pack'
        },
        v_dictionary = {
            joey_retcon = 'Retconned!',
            joey_converted = 'Converted!',
            joey_betrayed = 'Betrayed!'
        }
    }
}