--- STEAMODDED HEADER
--- MOD_NAME: JoeyJokers
--- MOD_ID: JoeyJokers
--- MOD_AUTHOR: [Joey]
--- MOD_DESCRIPTION: Another vanilla-ish content mod. Adds X jokers.
--- BADGE_COLOUR: 26d454
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

SMODS.Atlas {
    key = "Enhancements",
    path = "Enhancements.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "Loot",
    path = "Loot.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "Decks",
    path = "Decks.png",
    px = 71,
    py = 95
}

G.C.JOEY_LOOT = HEX('999999')
G.PROFILES[G.SETTINGS.profile].successorTokens = G.PROFILES[G.SETTINGS.profile].successorTokens or 1

getrankname = function(id)
    if id == 14 then return ('Ace')
    elseif id == 13 then return ('King')
    elseif id == 12 then return ('Queen')
    elseif id == 11 then return ('Jack')
    else return (id)
    end
end

function SMODS.current_mod.reset_game_globals(run_start)

    G.GAME.current_round.econmult = 0

    G.GAME.current_round.roid_card.rank = 7
    local roidranks = {}
    for _, v in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(v) then roidranks[#roidranks + 1] = v end
    end
    if roidranks[1] then 
        local roidcard = pseudorandom_element(roidranks, pseudoseed('roid'..G.GAME.round_resets.ante))
        G.GAME.current_round.roid_card.rank = roidcard.base.id
        G.GAME.current_round.roid_card.name = getrankname(roidcard.base.id)
        if G.GAME.current_round.roid_card.rank == 14 or G.GAME.current_round.roid_card.rank == 8 then
            G.GAME.current_round.roid_card.letter = 'an'
        else G.GAME.current_round.roid_card.letter = 'a'
        end
    end

    G.GAME.current_round.zhen_hands = G.GAME.current_round.hands_left

    G.GAME.lootPlays.current = G.GAME.lootPlays.normal
end

SMODS.Joker {
    key = 'openwater',
    atlas = 'Jokers',
    pos = {x = 4, y = 0},
    rarity = 2,
    cost = 5,
    config = { extra = {
        chips = 1,
        Xmult = 3,
        savedchips = {}
        }
    },
    blueprint_compat = true,

    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.chips, card.ability.extra.Xmult}}
    end,

    add_to_deck = function(self, card)
        for i, v in pairs(G.GAME.hands) do 
            card.ability.extra.savedchips[i] = G.GAME.hands[i].chips - 1
            G.GAME.hands[i].chips = 1
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        for i, v in pairs(G.GAME.hands) do 
            G.GAME.hands[i].chips = 1 + card.ability.extra.savedchips[i]
        end
    end,

    calculate= function(self,card,context)
        if context.joker_main then
            return { 
                xmult = card.ability.extra.Xmult,
            }
        end
    end
}

SMODS.Joker {
    key = 'feltmansion',
    atlas = 'Jokers',
    pos = {x = 2, y = 0},
    rarity = 3,
    cost = 7,
    blueprint_compat = true,
    perishable_compat = false,
    config = { extra = {
        mult_mod = 15,
        discards = 4,
        mult = 8
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
    atlas = 'Jokers',
    pos = {x = 0, y = 0},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    config = { extra = {
        combination = '',
        valid_cards = {},
        card_list = {},
        ranks = {},
        card_num = 10,
        savedcardrank = 1,
        cardspawns = 0
        }
    },
    
        -- Based on Bunco's Registration Plate
        -- Pseudorandom and ace support by @.berrybeat (discord)
    loc_vars = function(self,info_queue,card)
        local vars
        if card.ability.extra.combination == '' then
            vars = {'? ? ? ? ? ? ? ? ? ?'}
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
			for i = 1, card.ability.extra.card_num do
				local index = pseudorandom_element(card.ability.extra.valid_cards, pseudoseed('phone'))
				table.insert(card.ability.extra.card_list, index)
				table.remove(card.ability.extra.valid_cards, card.ability.extra.valid_cards[index])
			end
		-- fallback
		else 
			for i = 1, card.ability.extra.card_num do
				table.insert(card.ability.extra.card_list, "Heart_5")
			end
		end	
		-- sets table combination filled with the ranks of table card_list
		local combination = {}
		for i = 1, card.ability.extra.card_num do
			if card.ability.extra.card_list[i].base.value ~= 14 then 
				table.insert(combination, card.ability.extra.card_list[i].base.value)
			else
				table.insert(combination, 1)
			end
		end

		-- creates table ranks out of the ids of table card_list
		card.ability.extra.ranks = {}
		for i = 1, card.ability.extra.card_num do
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
                for i = 1, card.ability.extra.card_num do
                    local index = pseudorandom_element(card.ability.extra.valid_cards, pseudoseed('phone'))
                    table.insert(card.ability.extra.card_list, index)
                    table.remove(card.ability.extra.valid_cards, card.ability.extra.valid_cards[index])
                end
            -- fallback
            else 
				for i = 1, card.ability.extra.card_num do
                	table.insert(card.ability.extra.card_list, "Heart_5")
            	end
			end	
               -- sets table combination filled with the ranks of table card_list
			local combination = {}
			for i = 1, card.ability.extra.card_num do
				if card.ability.extra.card_list[i].base.value ~= 14 then 
					table.insert(combination, card.ability.extra.card_list[i].base.value)
				else
					table.insert(combination, 1)
				end
			end

			-- creates table ranks out of the ids of table card_list
			card.ability.extra.ranks = {}
			for i = 1, card.ability.extra.card_num do
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
            if #card.ability.extra.ranks <= 1 and context.other_card:get_id() == card.ability.extra.savedcardrank then
                card.ability.extra.card_list  = {}
                card.ability.extra.ranks = {}
                card.ability.extra.combination = 'Called!' 
                    if #G.consumeables.cards + G.GAME.consumeable_buffer + card.ability.extra.cardspawns < G.consumeables.config.card_limit then  
                        card.ability.extra.cardspawns = card.ability.extra.cardspawns + 1
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'bra')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                return true
                            end
                        }))
                    end
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Called!', colour = G.C.PURPLE})
                --scans ranks for values with ids matching the discarded card, then removes those values from ranks and card_list
            elseif not context.blueprint then
				for i, v in ipairs(card.ability.extra.ranks) do 
					if v == 1 and context.other_card:get_id() == 14 then 
						table.remove(card.ability.extra.ranks, i)
                        card.ability.extra.savedcardrank = card.ability.extra.ranks[1] 
						card.ability.extra.combination = table.concat(card.ability.extra.ranks, ' ', 1, #card.ability.extra.ranks)
                        return {
                            delay = .375,
                            message = '1...',
                            colour = G.C.SECONDARY_SET.Spectral
                        }
					elseif v == context.other_card:get_id() then
						table.remove(card.ability.extra.ranks, i)
                        card.ability.extra.savedcardrank = card.ability.extra.ranks[1]
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
        if context.after then
            card.ability.extra.cardspawns = 0
        end
	end
}

SMODS.Joker{
    key = 'brimstone',
    atlas = 'Jokers',
    pos = {x = 1, y = 0},
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    perishable_compat = false,
    config = { extra = {
        retriggers = 0,
        gain = 1,
        loss = 666,
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
        -- Retriggers last played card equal to number of retriggers
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
    key = 'joey_techx',
    atlas = 'Jokers',
    pos = {x = 5, y = 0},
    rarity = 2,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = false,
    config = { extra = {
        rounds = 3,
        remaining = 0
        }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.rounds, card.ability.extra.remaining}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint and card.ability.extra.remaining < card.ability.extra.rounds then
            card.ability.extra.remaining = card.ability.extra.remaining + 1
            if card.ability.extra.remaining == card.ability.extra.rounds then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
				{ message = localize('k_active_ex') })
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
    key = 'tetra',
    atlas = 'Jokers',
    pos = {x = 6, y = 0},
    soul_pos = {x = 7, y = 0},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,

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
    atlas = 'Jokers',
    pos = {x = 3, y = 0},
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    perishable_compat = false,
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
    atlas = 'Jokers',
    pos = {x = 9, y = 0},
    soul_pos = {x = 0, y = 1},
    rarity = 1,
    cost = 6,
    blueprint_compat = true,

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
    atlas = 'Jokers',
    pos = {x = 8, y = 0},
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
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
        for i = 1, #G.jokers.cards do 
            for h, k in ipairs(card.ability.extra.food) do
                if  G.jokers.cards[i].ability.name == card.ability.extra.food[h] then
                    local ret = SMODS.blueprint_effect(card, G.jokers.cards[i], context)
                    if ret then SMODS.calculate_effect(ret,card) end
                end
            end
        end
    end
}

SMODS.Joker{
    key = 'robotstop',
    atlas = 'Jokers',
    pos = {x = 1, y = 1},
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    config = {extra = {
        req = 9,
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
    atlas = 'Jokers',
    pos = {x = 2, y = 1},
    rarity = 3,
    cost = 8,
    blueprint_compat = true,

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

SMODS.Joker{
    key = 'draculadrug',
    atlas = 'Jokers',
    pos = {x = 3, y = 1},
    rarity = 1,
    config = {extra = {
        bonus = 0.5,
        mult = 1
    }},
    cost = 5,
    blueprint_compat = true,

    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.bonus, card.ability.extra.mult}}
    end,
    
    calculate = function(self,card,context)
        if context.before and not context.blueprint then 
            card.ability.extra.mult = 1
            for h, k in ipairs(context.scoring_hand) do
                if k.config.center ~= G.P_CENTERS.c_base and not k.debuff and not k.vampired then 
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.bonus
                    k.vampired = true
                    k:set_ability(G.P_CENTERS.c_base, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            k:juice_up()
                            k.vampired = nil
                            return true
                        end
                    })) 
                end
            end
        end
        if context.joker_main then return { x_mult = card.ability.extra.mult } end
    end
}

SMODS.Joker{
    key = 'avoidaroid',
    atlas = 'Jokers',
    pos = {x = 4, y = 1},
    rarity = 2,
    config = {extra = {
        mult = 3
    }},
    cost = 6,
    blueprint_compat = true,

    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue + 1] = {key = 'joey_credit_conboi', set = 'Other'}
        return {vars = {card.ability.extra.mult, G.GAME.current_round.roid_card.name, G.GAME.current_round.roid_card.rank, G.GAME.current_round.roid_card.letter}}
    end,
    
    calculate = function(self,card,context)
        if context.joker_main and next(context.poker_hands['Straight']) then 
            local roidcheck = false
            for i,v in ipairs(context.scoring_hand) do 
                if v.base.id == G.GAME.current_round.roid_card.rank then
                    roidcheck = true
                end
            end
            if roidcheck then return {
                x_mult = card.ability.extra.mult
            }
            end
        end
    end
}

local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.current_round.roid_card = {rank = 7, name = 7, letter = 'a'}
	return ret
end

SMODS.Joker{
    key = 'hazy',
    atlas = 'Jokers',
    pos = {x = 6, y = 1},
    rarity = 1,
    config = {extra = {
        multbonus = 4,
        mult = 0,
        scorereq = 2
    }},
    cost = 5,
    blueprint_compat = true,
    perishable_compat = false,

    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.multbonus, card.ability.extra.mult, card.ability.extra.scorereq}}
    end,
    
    calculate = function(self,card,context)
        if context.first_hand_drawn then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multbonus
            return {
                message = "+"..card.ability.extra.mult..' Mult'
            }
        end
        if context.joker_main then 
            return { mult = card.ability.extra.mult }
        end
        if context.end_of_round and not context.blueprint and context.cardarea == G.jokers then
            if G.GAME.chips >= G.GAME.blind.chips * card.ability.extra.scorereq then
                card.ability.extra.mult = 0
                return {
                    message = "Could've been worse...",
                    delay = 1
                }
            end
        end
    end
}

SMODS.Joker{
    key = 'economy',
    atlas = 'Jokers',
    pos = {x = 5, y = 1},
    rarity = 2,
    config = {extra = {
        mult = 1
    }},
    cost = 6,
    blueprint_compat = true,

    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.mult, G.GAME.current_round.econmult}}
    end,
    
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                mult = G.GAME.current_round.econmult
            }
        end
        if context.end_of_round and context.cardarea == G.jokers then
            return {
                message = localize('k_reset_ex')
            }
        end
    end
}

local igo2 = Game.init_game_object
function Game:init_game_object()
	local ret = igo2(self)
	ret.current_round.econmult = 0
	return ret
end

local easecash = ease_dollars
function ease_dollars(mod, instant)
    if mod > 0 then
	    G.GAME.current_round.econmult = G.GAME.current_round.econmult + mod
    end
	local ret = easecash(mod,instant)
	return ret
end

SMODS.Atlas {
    key = "vinyl",
    path = "vinyl.png",
    px = 71,
    py = 71
}

SMODS.Joker{
    key = 'luckyrainbow',
    atlas = 'vinyl',
    pos = {x = 14, y = 0},
    soul_pos = {x = 0, y = 0},
    display_size = {w = 71, h = 71},
    rarity = 1,
    config = {extra = {
        mult = 8,
        rank = 0,
        rankname = '?'
    }},
    cost = 3,
    blueprint_compat = true,

    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.mult, card.ability.extra.rank, card.ability.extra.rankname}}
    end,

    add_to_deck = function(self,card)
        if card.ability.extra.rank == 0 then 
            local valid_ranks = {}
            for i, v in ipairs(G.playing_cards) do
                if not SMODS.has_no_rank(v) then valid_ranks[#valid_ranks + 1] = v.base.id
                end
            end
            if valid_ranks[1] then 
                card.ability.extra.rank = pseudorandom_element(valid_ranks, pseudoseed('luckyrainbow'..G.GAME.round_resets.ante))
                card.ability.extra.rankname = getrankname(card.ability.extra.rank)
                if card.ability.extra.rank <= 14 then
                    local spritepos = card.ability.extra.rank - 1
                    card.children.floating_sprite:set_sprite_pos({x = spritepos, y = 0})
                end
            end
        end
    end,

    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play and not card.debuff then
            if context.other_card:get_id() == card.ability.extra.rank then return {mult = card.ability.extra.mult}
            end
        end
    end
}

-- Legendary Jokers

SMODS.Joker{
    key = 'zhen',
    atlas = 'Jokers',
    pos = {x = 7, y = 1},
    soul_pos = {x = 8, y = 1},
    rarity = 4,
    cost = 20,
    blueprint_compat = true,

    loc_vars = function(self,info_queue,card)
        return {vars = {G.GAME.current_round.zhen_hands}}
    end,
    
    calculate = function(self,card,context)
        if context.setting_blind and not card.getting_sliced then
            G.E_MANAGER:add_event(Event({func = function()
                ease_hands_played(G.GAME.current_round.zhen_hands)
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hands', vars = {G.GAME.current_round.zhen_hands}}})
            return true end }))
        end
    end
}

local zhen_igo = Game.init_game_object
function Game:init_game_object()
	local ret = zhen_igo(self)
	ret.current_round.zhen_hands = 0
	return ret
end

SMODS.Joker{
    key = 'joculine',
    atlas = 'Jokers',
    pos = {x = 0, y = 2},
    soul_pos = {x = 9, y = 1},
    rarity = 4,
    cost = 20,
    config = { extra = {
        rounds = 3,
        roundsLeft = 0
        }
    },
    blueprint_compat = false,

    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_joey_joculinewild
        return {vars = {card.ability.extra.rounds, card.ability.extra.roundsLeft}}
    end,

    remove_from_deck = function(self, card, from_debuff)
        for i, v in ipairs(G.hand.cards) do 
            if v.config.center == G.P_CENTERS.m_joey_joculinewild then
                v:set_ability(G.P_CENTERS.c_base, nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        v:juice_up()
                        return true
                    end
                })) 
            end
        end
        for h, k in ipairs(G.playing_cards) do
            if k.config.center == G.P_CENTERS.m_joey_joculinewild then
                k:set_ability(G.P_CENTERS.c_base, nil, true)
            end
        end
    end,
    
    calculate = function(self,card,context)
        if context.end_of_round and context.main_eval and not context.blueprint and not context.repetition  then
            if card.ability.extra.roundsLeft ~= 'Active!' then 
                if card.ability.extra.roundsLeft <= 2 then
                    card.ability.extra.roundsLeft = card.ability.extra.roundsLeft + 1
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
				        { message = card.ability.extra.roundsLeft..'/'..card.ability.extra.rounds })
                    if card.ability.extra.roundsLeft == 3 then 
                        for i, v in ipairs(G.hand.cards) do
                            if v.config.center == G.P_CENTERS.c_base then
                                v:set_ability(G.P_CENTERS.m_joey_joculinewild, nil, true)
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        v:juice_up()
                                        return true
                                    end
                                })) 
                            end
                        end
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
				            { message = 'Converted!' })
                        for h, k in ipairs(G.playing_cards) do
                            if k.config.center == G.P_CENTERS.c_base then
                                k:set_ability(G.P_CENTERS.m_joey_joculinewild, nil, true)
                            end
                        end
                        card.ability.extra.roundsLeft = 'Active!'
                    end
                end
            end
        end
        if context.selling_self and card.ability.extra.roundsLeft == 'Active!' then
            card_eval_status_text(card, 'extra', nil, nil, nil,
			{ message = 'Betrayed!',
            delay = 1 })
        end
    end
}

SMODS.Enhancement{
    key = 'joculinewild',
    atlas = 'Enhancements',
    pos = {x = 0, y = 0},
    any_suit = true
}

SMODS.Joker{
    key = 'riotus',
    atlas = 'Jokers',
    pos = {x = 1, y = 2},
    soul_pos = {x = 2, y = 2},
    rarity = 4,
    cost = 20,
    config = {extra = {
        mult = 2
    }},
    blueprint_compat = true,

    loc_vars = function(self,info_queue,card)
        return {vars = {
            localize(G.GAME.riotus_suit, 'suits_singular'),
            card.ability.extra.mult,
            colours = {G.C.SUITS[G.GAME.riotus_suit]}
        }}
    end,
    
    calculate = function(self,card,context)
        if context.before and not context.blueprint then
            for h, k in ipairs(context.scoring_hand) do 
                if k:is_suit(G.GAME.riotus_suit) then
                    k.riotusTrigger = true
                    resetRiotus()
                end
            end
        end
        if context.cardarea == G.play and context.individual then
            if context.other_card.riotusTrigger then
                return {
                    x_mult = card.ability.extra.mult,
                    card = card
                }
            end
        end
        if context.after and not context.blueprint then
            for i, v in ipairs(G.playing_cards) do
                if v.riotusTrigger == true then
                    v.riotusTrigger = false
                end
            end
        end
    end
}

local riotus_igo = Game.init_game_object
function Game:init_game_object()
	local ret = riotus_igo(self)
	ret.riotus_suit = 'Diamonds'
	return ret
end

function resetRiotus()
    G.GAME.riotus_suit = 'Diamonds'
    local validSuits = {}
    for k, v in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(v) then
            validSuits[#validSuits+1] = v
        end
    end
    if validSuits[1] then 
        local riotusCard = pseudorandom_element(validSuits, pseudoseed('riotus'))
        G.GAME.riotus_suit = riotusCard.base.suit
    end
end

SMODS.Joker{
    key = 'mizzlebip',
    atlas = 'Jokers',
    pos = {x = 3, y = 2},
    soul_pos = {x = 4, y = 2},
    rarity = 4,
    cost = 20,
    config = {extra = {
        rankMultMod = .20,
        suitMultMod = .25,
        ranks = { 0 },
        suits = { 0 }
    }},
    blueprint_compat = true,

    loc_vars = function(self,info_queue,card)
        return {vars = {
            card.ability.extra.rankMultMod,
            card.ability.extra.suitMultMod,
            1 + ((#card.ability.extra.ranks - 1) * card.ability.extra.rankMultMod),
            1 + ((#card.ability.extra.suits - 1) * card.ability.extra.suitMultMod)
        }}
    end,
    
    calculate = function(self,card,context)
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            for i,v in ipairs(context.scoring_hand) do 
                local current_rank = v.base.id
                local current_suit = v.base.suit
                for h,k in ipairs(card.ability.extra.ranks) do
                    if card.ability.extra.ranks[h] == current_rank then break
                    elseif card.ability.extra.ranks[h] == 0 and not SMODS.has_no_rank(v) then 
                        table.insert(card.ability.extra.ranks, current_rank)
                        table.remove(card.ability.extra.ranks, h)
                        table.insert(card.ability.extra.ranks, 0)
                        break
                    end
                end
                for h,k in ipairs(card.ability.extra.suits) do
                    if card.ability.extra.suits[h] == current_suit then break
                    elseif card.ability.extra.suits[h] == 0 and not SMODS.has_no_suit(v) then 
                        table.insert(card.ability.extra.suits, current_suit)
                        table.remove(card.ability.extra.suits, h)
                        table.insert(card.ability.extra.suits, 0)
                        break
                    end
                end
            end
        end
        if context.joker_main then
            SMODS.calculate_effect({
                x_mult = 1 + ((#card.ability.extra.ranks - 1) * card.ability.extra.rankMultMod)
            },card)
            SMODS.calculate_effect({
                x_mult = 1 + ((#card.ability.extra.suits - 1) * card.ability.extra.suitMultMod)
            },card)
        end
        if context.end_of_round and context.cardarea==G.jokers and not context.blueprint then
            card.ability.extra.ranks = { 0 }
            card.ability.extra.suits = { 0 }
            return {
                message = localize('k_reset')
            }
        end
    end
}

SMODS.Joker{
    key = 'dclussie',
    atlas = 'Jokers',
    pos = {x = 5, y = 2},
    soul_pos = {x = 6, y = 2},
    rarity = 4,
    cost = 20,
    config = {extra = {
        odds = 4,
        minus_ante = -1
    }},
    blueprint_compat = false,

    loc_vars = function(self,info_queue,card)
        return {vars = {
            card.ability.extra.odds * G.GAME.probabilities.normal,
            card.ability.extra.minus_ante
        }}
    end,
    
    calculate = function(self,card,context)
        if context.end_of_round and G.GAME.blind.boss and not context.repetition and not context.individual and not context.blueprint then
            if pseudorandom('dclussie'..G.GAME.round_resets.ante) <= (card.ability.extra.odds * G.GAME.probabilities.normal) / 13 then
                ease_ante(card.ability.extra.minus_ante)
                return {
                    message = 'Retconned!'
                }
            end
        end
    end
}

-- Loot

local lootIgo = Game.init_game_object
function Game:init_game_object()
	local ret = lootIgo(self)
	ret.lootPlays = {
        current = 1,
        normal = 1,
        usedThisRun = 0
    }
	return ret
end

function joeyUseLoot(lootcard)
    G.GAME.lootPlays.current = G.GAME.lootPlays.current - 1
    lootcard.ability.extra.uses = lootcard.ability.extra.uses - 1
    G.GAME.lootPlays.usedThisRun = G.GAME.lootPlays.usedThisRun + 1
end

SMODS.ConsumableType{
    key = 'Loot',
    primary_colour = G.C.JOEY_LOOT,
    secondary_colour = G.C.JOEY_LOOT,
    loc_txt = {
        name = 'Loot Card',
        collection = 'Loot Cards',
        undiscovered = {
            name = 'Loot Card',
            text = {
                'Find this in a run',
                'to see what it does'
            }
        }
    },
    collection_rows = { 2 }
}

SMODS.Consumable{
    key = 'soulheart',
    set = 'Loot',
    atlas = 'Loot',
    pos = {x = 1, y = 0},
    config = {extra = { 
        uses = 2
        }
    },

    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue + 1] = {key = 'joey_info_loot', set = 'Other', specific_vars = {G.GAME.lootPlays.normal} }
        return { 
            vars = {card.ability.extra.uses}
        }
    end,

    can_use = function(self, card)
        if G.GAME.blind.in_blind then
            if G.GAME.lootPlays.current > 0 then
                return true
            end
        end
    end,

    use = function(self,card,area)
        G.E_MANAGER:add_event(Event({func = function()
            ease_hands_played(1)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hands', vars = {1}}})
        return true end }))
        joeyUseLoot(card)
    end,

    keep_on_use = function(self, card)
        if card.ability.extra.uses > 1 then
            return true
        end
    end
}

SMODS.Consumable{
    key = 'diceshard',
    set = 'Loot',
    atlas = 'Loot',
    pos = {x = 0, y = 0},
    config = {extra = { 
        uses = 2
        }
    },

    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue + 1] = {key = 'joey_info_loot', set = 'Other', specific_vars = {G.GAME.lootPlays.normal} }
        return { 
            vars = {card.ability.extra.uses}
        }
    end,

    can_use = function(self, card)
        if G.GAME.blind.in_blind then
            if G.GAME.lootPlays.current > 0 then
                return true
            end
        end
    end,

    use = function(self,card,area)
        G.E_MANAGER:add_event(Event({func = function()
            ease_discard(1)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hands', vars = {1}}})
        return true end }))
        joeyUseLoot(card)
    end,

    keep_on_use = function(self, card)
        if card.ability.extra.uses > 1 then
            return true
        end
    end
}

-- Decks

SMODS.Tag{
    key = 'successor_reminder',
    no_collection = true,
    in_pool = function(self,args)
        return false
    end
}

SMODS.Back{
    key = 'honkifex',
    atlas = 'Decks',
    pos = {x = 0, y = 0},
    config = {winante = 11},

    loc_vars = function(self,info_queue,card)
        return { vars = {
            self.config.winante,
            G.PROFILES[G.SETTINGS.profile].successorTokens
            }
        }
    end,

    apply = function(self,back)
        G.GAME.win_ante = 11
        G.PROFILES[G.SETTINGS.profile].successorTokens = G.PROFILES[G.SETTINGS.profile].successorTokens - 1
        G.E_MANAGER:add_event(Event({func = function()
            local legendary = create_card('Joker', G.jokers, true, 4, nil, nil, nil, 'honk')
            legendary:add_to_deck()
            G.jokers:emplace(legendary)
            legendary:start_materialize()
            G.GAME.joker_buffer = 0
        return true end }))
    end
}

local wingame = win_game
function win_game()
    G.PROFILES[G.SETTINGS.profile].successorTokens = G.PROFILES[G.SETTINGS.profile].successorTokens + 1
	local ret = wingame(self)
	return ret
end
