--- STEAMODDED HEADER
--- MOD_NAME: JoeyJokers
--- MOD_ID: JoeyJokers
--- MOD_AUTHOR: [Joey]
--- MOD_DESCRIPTION: Another vanilla-ish content mod. Adds X jokers.
--- BADGE_COLOUR: 1d6e22
--- DISPLAY_NAME: JoeyJokers
--- PREFIX: joey
--- VERSION: 1.0.0
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-1406b]

SMODS.Atlas {
    key = "Jokers",
    path = "Jokers.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'openwater',
    loc_txt = {
        name = 'Open Water',
        text = {
            '{X:chips,C:white}1/#1#{} chips,',
            '{X:mult,C:white}X#2#{} mult'
        }
    },
    atlas = 'Jokers',
    pos = {x = 4, y = 0},
    rarity = 2,
    cost = 5,
    config = { extra = {
        chips = 3,
        Xmult = 3
        }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.chips, card.ability.extra.Xmult}}
    end,

    calculate= function(self,card,context)
        if context.joker_main then
            return { 
                xmult = card.ability.extra.Xmult,
                chips = math.min(math.floor(hand_chips * -((card.ability.extra.chips-1)/card.ability.extra.chips)), 0)
            }
        end
    end
}

SMODS.Joker {
    key = 'feltmansion',
    loc_txt = {
        name = 'Felt Mansion',
        text = {
            'This joker gains {C:mult}+#1#{} mult',
            'for every {C:attention}#2# {C:inactive}[#3#]{C:attention} Aces',
            'discarded each round',
            '{C:inactive}(Currently {C:mult}+#4#{C:inactive} mult)'
        }
    },
    atlas = 'Jokers',
    pos = {x = 2, y = 0},
    rarity = 3,
    cost = 7,
    blueprint_compat = true,
    config = { extra = {
        mult_mod = 15,
        discards = 4,
        mult = 0
        }
    },

    set_ability = function(self, card, initial, delay_sprites)
        card.ability.felt_discards = card.ability.extra.discards
    end,

    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.mult_mod, card.ability.extra.discards, card.ability.felt_discards, card.ability.extra.mult}}
    end,

    calculate = function(self,card,context)
        if context.discard and not context.blueprint and not context.other_card.debuff and context.other_card:get_id() == 14 then
            if card.ability.felt_discards <= 1 then
                card.ability.felt_discards = card.ability.extra.discards
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                return {
                    delay = 0.75,
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult_mod}},
                    colour = G.C.RED
                }
            else
                card.ability.felt_discards = card.ability.felt_discards - 1
                return {
                    delay = 0.2,
                    message = (card.ability.extra.discards - card.ability.felt_discards)..'/'..(card.ability.extra.discards),
                    colour = G.C.RED
                }
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            card.ability.felt_discards = card.ability.extra.discards
        end
    end
}

SMODS.Joker {
    key = 'braintelephone',
    loc_txt = {
        name = 'Brain Telephone',
        text = {
            'After 7 {C:attention}digits',
            '{C:inactive}[#1#]',
            'have been discarded,',
            'create a {C:spectral}Spectral{} card',
            '{C:inactive}(ranks reset each round)'
        }
    },
    atlas = 'Jokers',
    pos = {x = 0, y = 0},
    rarity = 2,
    cost = 6,
    blueprint = false,
    config = { extra = {
        combination = '',
        valid_cards = {},
        card_list = {},
        ranks = {}
        }
    },
    
        -- Based on Bunco's Registration Plate
        -- Pseudorandom and ace support by @.berrybeat (discord)
    loc_vars = function(self,info_queue,card)
        local vars
        if card.ability.extra.combination == '' then
            vars = {'? ? ? ? ? ? ?'}
        else
            vars = {card.ability.extra.combination}
        end
        return {vars = vars}
    end,

    add_to_deck = function(self,card)
        card.ability.extra.valid_cards = {}
		-- checks for all cards in the deck and returns all non-face, 10, and stone cards in table valid_cards
		for i, v in ipairs(G.playing_cards) do
			if v.base.id ~= 10 and v.base.id ~= 11 and v.base.id ~= 12 and v.base.id ~= 13 and v.ability.effect ~= 'Stone Card' then
				table.insert(card.ability.extra.valid_cards, v)
			end
		end

		card.ability.extra.card_list = {}
		-- fills card_list with unique items from valid_cards
		if next(card.ability.extra.valid_cards) then
			for i = 1, 7 do
				local index = pseudorandom_element(card.ability.extra.valid_cards, pseudoseed('phone'))
				table.insert(card.ability.extra.card_list, index)
				table.remove(card.ability.extra.valid_cards, card.ability.extra.valid_cards[index])
			end
		-- fallback
		else 
			for i = 1, 7 do
				table.insert(card.ability.extra.card_list, "Heart_5")
			end
		end	
		-- sets table combination filled with the ranks of table card_list
		local combination = {}
		for i = 1, 7 do
			if card.ability.extra.card_list[i].base.value ~= 14 then 
				table.insert(combination, card.ability.extra.card_list[i].base.value)
			else
				table.insert(combination, 1)
			end
		end

		-- creates table ranks out of the ids of table card_list
		card.ability.extra.ranks = {}
		for i = 1, 7 do
			if card.ability.extra.card_list[i]:get_id() ~= 14 then 
				table.insert(card.ability.extra.ranks, card.ability.extra.card_list[i]:get_id())
			else
				table.insert(card.ability.extra.ranks, 1)
			end
		end
		-- sets combination variable, which appears in the description
		card.ability.extra.combination = table.concat(card.ability.extra.ranks, ' ', 1, #card.ability.extra.ranks)
	end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            card.ability.extra.valid_cards = {}
            -- checks for all cards in the deck and returns all non-face, 10, and stone cards in table valid_cards
            for i, v in ipairs(G.playing_cards) do
                if v.base.id ~= 10 and v.base.id ~= 11 and v.base.id ~= 12 and v.base.id ~= 13 and v.ability.effect ~= 'Stone Card' then
                    table.insert(card.ability.extra.valid_cards, v)
                end
            end

            card.ability.extra.card_list = {}
            -- fills card_list with unique items from valid_cards
            if next(card.ability.extra.valid_cards) then
                for i = 1, 7 do
                    local index = pseudorandom_element(card.ability.extra.valid_cards, pseudoseed('phone'))
                    table.insert(card.ability.extra.card_list, index)
                    table.remove(card.ability.extra.valid_cards, card.ability.extra.valid_cards[index])
                end
            -- fallback
            else 
				for i = 1, 7 do
                	table.insert(card.ability.extra.card_list, "Heart_5")
            	end
			end	
               -- sets table combination filled with the ranks of table card_list
			local combination = {}
			for i = 1, 7 do
				if card.ability.extra.card_list[i].base.value ~= 14 then 
					table.insert(combination, card.ability.extra.card_list[i].base.value)
				else
					table.insert(combination, 1)
				end
			end

			-- creates table ranks out of the ids of table card_list
			card.ability.extra.ranks = {}
			for i = 1, 7 do
				if card.ability.extra.card_list[i]:get_id() ~= 14 then 
					table.insert(card.ability.extra.ranks, card.ability.extra.card_list[i]:get_id())
				else
					table.insert(card.ability.extra.ranks, 1)
				end
			end
			-- sets combination variable, which appears in the description
			card.ability.extra.combination = table.concat(card.ability.extra.ranks, ' ', 1, #card.ability.extra.ranks)
        end
        if context.discard then
            -- clears card_list and creates a spectral if the last value is removed
            if #card.ability.extra.ranks == 1 and context.other_card:get_id() == card.ability.extra.ranks[#card.ability.extra.ranks] then
                card.ability.extra.card_list  = {}
                card.ability.extra.ranks = {}
                card.ability.extra.combination = 'Called!'
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'bra')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            return true
                        end
                    }))
                    return {
                        delay = 0.75,
                        message = 'Called!',
                        colour = G.C.SECONDARY_SET.Spectral
                    }
                end
                --scans ranks for values with ids matching the discarded card, then removes those values from ranks and card_list
            elseif not context.blueprint then
				for i, v in ipairs(card.ability.extra.ranks) do 
					if v == 1 and context.other_card:get_id() == 14 then 
						table.remove(card.ability.extra.ranks, i)
						card.ability.extra.combination = table.concat(card.ability.extra.ranks, ' ', 1, #card.ability.extra.ranks)
                        return {
                            delay = .375,
                            message = '1...',
                            colour = G.C.SECONDARY_SET.Spectral
                        }
					elseif v == context.other_card:get_id() then
						table.remove(card.ability.extra.ranks, i)
						card.ability.extra.combination = table.concat(card.ability.extra.ranks, ' ', 1, #card.ability.extra.ranks)
                        return {
                            delay = .375,
                            message = (v)..'...',
                            colour = G.C.SECONDARY_SET.Spectral
                        }
					end
				end
            end
        end
	end
}

SMODS.Joker{
    key = 'brimstone',
    loc_txt = {
        name = 'Brimstone',
        text = {
            'Retrigger {C:attention}last played',
            'card {C:attention}#1#{} #4#. This joker gains',
            '{C:attention}+#2#{} trigger per unused discard',
            'and {C:attention}-#3#{} trigger per discard'
        }
    },
    atlas = 'Jokers',
    pos = {x = 1, y = 0},
    rarity = 3,
    cost = 8,
    blueprint = true,
    config = { extra = {
        retriggers = 0,
        gain = 1,
        loss = 1,
        time = 'times'
        }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.retriggers, card.ability.extra.gain, card.ability.extra.loss, card.ability.extra.time}}
    end,

    calculate = function(self, card, context)
        -- Decreases number of retriggers by the "loss" value (1) on discard 
        if context.discard and context.other_card == context.full_hand[#context.full_hand] and card.ability.extra.retriggers > 0 and not context.blueprint then
            card.ability.extra.retriggers = card.ability.extra.retriggers - 1
            if card.ability.extra.retriggers == 1 then
                card.ability.extra.time = 'time'
            else card.ability.extra.time = 'times'
            end
            return {
                delay = 0.5,
                message = '-'..(card.ability.extra.loss)..' retrigger',
                colour = G.C.RED
            }
        end
        -- Retriggers last played card equal to number of retriggers. Doesnt work rn
        if context.repetition and context.cardarea == G.play and context.scoring_hand and context.other_card == context.scoring_hand[#context.scoring_hand] then 
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
                card = card
            }
        end
        -- Increase number of retriggers by number of discards left at end of round. Currently bugged, each card in hand also increments the value for some reason
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint and G.GAME.current_round.discards_left > 0 then
            local bonus = G.GAME.current_round.discards_left
            card.ability.extra.retriggers = card.ability.extra.retriggers + bonus
            if card.ability.extra.retriggers == 1 then
                card.ability.extra.time = 'time'
            else card.ability.extra.time = 'times'
            end
            return {
                delay = 0.5,
                message = '+'..(G.GAME.current_round.discards_left)..' retrigger(s)',
                colour = G.C.red
            }
        end
    end
}

SMODS.Joker{
    key = 'techx',
    loc_txt = {
        name = 'Tech X',
        text = {
            'After {C:attention}#1#{} rounds,',
            'sell this to',
            '{C:attention}win the Blind',
            '{C:inactive}(currently {C:attention}#2#{C:inactive}/{C:attention}#1#{C:inactive})'
        }
    },
    atlas = 'Jokers',
    pos = {x = 5, y = 0},
    rarity = 1,
    cost = 5,
    blueprint = true,
    eternal = false,
    config = { extra = {
        rounds = 3,
        remaining = 0
        }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.rounds, card.ability.extra.remaining}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context_blueprint and card.ability.extra.remaining < card.ability.extra.rounds then
            card.ability.extra.remaining = card.ability.extra.remaining + 1
            if card.ability.extra.remaining == card.ability.extra.rounds then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
				{ message = 'Active!' })
            else 
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
				{ message = card.ability.extra.remaining..'/'..card.ability.extra.rounds })
            end
        end
        if context.selling_self and card.ability.extra.remaining == card.ability.extra.rounds then
            if G.GAME.blind.in_blind then
                -- taken from @nh6574 (discord)
                G.GAME.chips = G.GAME.blind.chips
                G.STATE = G.STATES.HAND_PLAYED
                G.STATE_COMPLETE = true
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
				{ message = 'Blind defeated!' })
                end_round()
            else return { message = 'Not in blind!', delay = 1}
            end
        end
    end
}

SMODS.Joker{
    key = 'tetrachromancy',
    loc_txt = {
        name = 'Tetrachromacy',
        text = {
            'Creates {C:attention}The Fool',
            'if played hand contains four',
            'different scoring {C:attention}Suits',
            '{C:inactive}(must have room)'
        }
    },
    atlas = 'Jokers',
    pos = {x = 6, y = 0},
    soul_pos = {x = 7, y = 0},
    rarity = 2,
    cost = 6,
    blueprint = true,

    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
    end,

    calculate = function(self, card, context)
        if context.joker_main then
        local suits = {
            ['1'] = 0,
            ['2'] = 0,
            ['3'] = 0,
            ['4'] = 0
        }
        for i, v in ipairs(context.scoring_hand) do
            if context.scoring_hand[i].ability.name ~= 'Wild Card' and context.scoring_hand[i].ability.name ~= 'Stone Card' then
                if suits['1'] == v.base.suit then break
                elseif suits['1'] == 0 then suits['1'] = v.base.suit
                elseif suits['2'] == v.base.suit then break
                elseif suits['2'] == 0 then suits['2'] = v.base.suit
                elseif suits['3'] == v.base.suit then break
                elseif suits['3'] == 0 then suits['3'] = v.base.suit
                elseif suits['4'] == v.base.suit then break
                elseif suits['4'] == 0 then suits['4'] = v.base.suit
                end 
            end
            if context.scoring_hand[i].ability.name == 'Wild Card' then
                if suits['1'] == 0 then suits['1'] = 'Wild'
                elseif suits['2'] == 0 then suits['2'] = 'Wild'
                elseif suits['3'] == 0 then suits['3'] = 'Wild'
                elseif suits['4'] == 0 then suits['4'] = 'Wild'
                end
            end
        end
        if suits['1'] ~= 0 and suits['2'] ~= 0 and suits['3'] ~= 0 and suits['4'] ~= 0 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_fool', 'tet')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
				{ message = 'Witnessed!' })
        end
    end
end
}

SMODS.Joker{
    key = 'oddments',
    loc_txt = {
        name = 'Oddments',
        text = {
            'This joker gains {C:chips}+#2#{} chips',
            'per unique scoring {C:attention}rank{}',
            'played each round',
            '{C:inactive}(currently {C:chips}+#1#{C:inactive} chips)'
        }
    },
    atlas = 'Jokers',
    pos = {x = 3, y = 0},
    rarity = 1,
    cost = 4,
    blueprint = true,
    config = {extra = {
        chips = 0,
        bonuschips = 2,
        ranks = {0}
        }
    },

    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.chips, card.ability.extra.bonuschips, card.ability.extra.ranks}}
    end,

    calculate = function(self, card, context)
        if context.before and context.cardarea==G.jokers and not context.blueprint then
            for i,v in ipairs(context.scoring_hand) do 
                local current_rank = v.base.id
                for h,k in ipairs(card.ability.extra.ranks) do
                    if card.ability.extra.ranks[h] == current_rank then break
                    elseif card.ability.extra.ranks[h] == 0 and context.scoring_hand[i].ability.name ~= 'Stone Card' then 
                        table.insert(card.ability.extra.ranks, current_rank)
                        table.remove(card.ability.extra.ranks, h)
                        table.insert(card.ability.extra.ranks, 0)
                        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.bonuschips
                        break
                    end
                end
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
        if context.end_of_round then
            card.ability.extra.ranks = {0}
        end
    end
}

SMODS.Joker{
    key = 'kinggila',
    loc_txt = {
        name = 'Flamethrower',
        text = {
            'Create up to 2 {C:planet}Planet',
            '{C:planet}Cards{} if score',
            'is currently {C:attention}on fire',
            '{C:inactive}(must have room)'
        }
    },
    atlas = 'Jokers',
    pos = {x = 9, y = 0},
    soul_pos = {x = 0, y = 1},
    rarity = 1,
    cost = 6,
    blueprint = true,

    calculate = function(self, card, context)
        if context.joker_main and hand_chips * mult >= G.GAME.blind.chips then
            if G.consumeables.config.card_limit - #G.consumeables.cards - G.GAME.consumeable_buffer >= 2 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, nil, 'king')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, nil, 'gila')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        return true
                    end
                }))
                return {
                    message = 'Scorched!'
                }
            elseif G.consumeables.config.card_limit - #G.consumeables.cards - G.GAME.consumeable_buffer == 1 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, nil, 'king')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        return true
                    end
                }))
                return {
                    message = 'Scorched!'
                }
            end
        end
    end
}

SMODS.Joker{
    key = 'mmfood',
    loc_txt = {
        name = 'MM..FOOD',
        text = {
            'Copies the ability',
            'of {C:attention}food Jokers'
        }
    },
    atlas = 'Jokers',
    pos = {x = 8, y = 0},
    rarity = 2,
    cost = 5,
    blueprint = true,
    config = {extra = {
        food = {
            'Loyalty Card',
            'Gros Michel',
            'Ice Cream',
            'Egg',
            'Cavendish',
            'Turtle Bean',
            'Diet Cola',
            'Popcorn',
            'Ramen',
            'Vegemite'
        }
        }
    },

    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.food}}
    end,

    calculate = function(self,card,context)
        if context.joker_main then 
            for i = 1, #G.jokers.cards do 
                for h, k in ipairs(card.ability.extra.food) do
                    if  G.jokers.cards[i].ability.name == card.ability.extra.food[h] then
                        local ret = SMODS.blueprint_effect(card, G.jokers.cards[i], context)
                        if ret then SMODS.calculate_effect(ret,card) end
                    end
                end
            end
        end
        if context.repetition and context.cardarea == G.play and context.scoring_hand then
            for i = 1, #G.jokers.cards do 
                if G.jokers.cards[i].ability.name == 'Seltzer' then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = 1,
                        card = card
                    }
                end
            end
        end
    end
}

SMODS.Joker{
    key = 'robotstop',
    loc_txt = {
        name = 'Robot Stop',
        text = {
            '{C:attention}Retrigger{} each played card',
            'if number of cards {C:attention}in full deck',
            'is a multiple of {C:attention}#1#{C:inactive}#2#'
        }
    },
    atlas = 'Jokers',
    pos = {x = 1, y = 1},
    rarity = 2,
    cost = 5,
    blueprint = true,
    config = {extra = {
        req = 7,
        status = ''
        }
    },

    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.req, card.ability.extra.status}}
    end,

    add_to_deck = function(self,card)
        if #G.playing_cards / card.ability.extra.req == math.ceil(#G.playing_cards / card.ability.extra.req) then
            card.ability.extra.status = ' (active!)'
        else
            card.ability.extra.status = ' (inactive)'
        end
    end,

    calculate = function(self,card,context)
        if #G.playing_cards / card.ability.extra.req == math.ceil(#G.playing_cards / card.ability.extra.req) and context.repetition and context.cardarea == G.play and context.scoring_hand then
            return {
                message = localize('k_again_ex'),
                repetitions = 1,
                card = card
            }
        end
        if context.playing_card_added then
            if ( #G.playing_cards / card.ability.extra.req) == math.ceil( #G.playing_cards / card.ability.extra.req) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.ability.extra.status = ' (active!)'
                      return true
                    end
                  }))
                SMODS.calculate_effect({
                    message = 'Active!'
                },card)
            else
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.ability.extra.status = ' (inactive)'
                      return true
                    end
                  }))
            end
        end
        if context.remove_playing_cards or context.cards_destroyed then
            if ((#G.playing_cards - #context.removed) / card.ability.extra.req) == math.ceil( (#G.playing_cards - #context.removed) / card.ability.extra.req) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.ability.extra.status = ' (active!)'
                      return true
                    end
                  }))
                SMODS.calculate_effect({
                    message = 'Active!'
                },card)
            else
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.ability.extra.status = ' (inactive)'
                      return true
                    end
                  }))
            end
        end
    end
}

SMODS.Joker{
    key = 'icev',
    loc_txt = {
        name = 'Ice V',
        text = {
            'Create an {C:attention}Economy Tag {}if',
            'played hand contains a {C:attention}Lucky 7',
            'and an {C:attention}Ace of Spades'
        }
    },
    atlas = 'Jokers',
    pos = {x = 2, y = 1},
    rarity = 3,
    cost = 8,
    blueprint = false,

    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue + 1] = G.P_TAGS.tag_economy
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
    end,
    
    calculate = function(self,card,context)
        if context.joker_main then
            local sevencheck = false
            -- lucky 7
            for i, v in ipairs(context.full_hand) do
                if v.base.id == 7 and context.full_hand[i].ability.name == 'Lucky Card' then
                    sevencheck = true
                    break
                end
            end
            local acecheck = false
            for i, v in ipairs(context.full_hand) do
                if v.base.id == 14 and v.base.suit == 'Spades' then
                    acecheck = true
                    break
                end
            end
            if sevencheck and acecheck then 
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag('tag_economy'))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
            end
        end
    end
}