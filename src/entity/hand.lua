local Entity = require 'core.entity'
local slash = require 'entity.Cards.attacks.Slash'
local deck = require 'entity.deck'
local config = require 'conf'
local hitbox = require 'entity.hitbox'

local hand = Entity:extend()
local heightExtension = config.cardHeight + 5 --Defines how high the cards raise

function hand:init(o) --Intitialise an instance of the card class
    Entity.init(self,o)
    o = o or {} --Give a blank table if no object is given

    self.cards = o.cards or {}
    self.deck = o.deck or deck:new() --Set the deck that is associated with this hand
    self.wait = false
    self.idealPositions = o.idealPositions or self:getIdealPositions() --stores the ideal positions of the cards in the hand
    self.hitboxes = o.hitboxes or self:gethitboxes() --stores the hitboxes of the cards in the hand

    self.leftPosition = o.leftPosition or 0 --Defines the boundaries between the left and right of the hand for empty
    self.spacing = o.spacing or 0

    self.deck = hand.testHand(20) --Test function to see if the hand is working
    self:drawCards(10) --Testing
end

    
    

function hand:gethitboxes()
    local result = {}
    local heightBuffer = 5 --Extra space ontop of the card that can still detect the mouse
    for i = #self.cards,1,-1 do
        local xDivision =  (((config.gamew - (self.leftPosition * 2))/#self.cards) * (i-1)) + self.leftPosition
        local yDivision = config.gameh - (config.cardHeight + heightExtension + heightBuffer)
        local locWidth = (config.gamew - (self.leftPosition * 2))/#self.cards
        local locHeight = config.cardHeight + heightExtension + heightBuffer
        local hitbox = hitbox:new({x = xDivision, y = yDivision, width = locWidth, height = locHeight})
        table.insert(result,hitbox)
    end
    return result
end

function hand:getIdealPositions() --Determines where a given card should be based on its index in the x plane.
    local center = config.gamew/2
    local cardWidth = config.cardWidth
    self.leftPosition = 0
    local leftLimit = 20 --The limit for how far left the cards are allowed to be
    self.spacing = 20 --How much space is inbetween individual cards. This value may be negative in which case the cards overlap.
    
    local result = {}

    while self.leftPosition < leftLimit do

        if #self.cards % 2 == 0 then --If there is an even number of cards in the hand
            --remove the self.spacing/2 because it will be split in half.
            self.leftPosition = center - (self.spacing/2) - (#self.cards/2 * cardWidth) - (self.spacing * (#self.cards/2 - 1))

        else --If there is an odd number of cards in the hand
        --remove the cardwith/2 because a card will be in the center and the rest will be split evenly on either side
            self.leftPosition = center - (cardWidth/2) - ((#self.cards - 1)/2 * cardWidth) - (self.spacing * ((#self.cards - 1)/2))
        end

        if self.leftPosition < leftLimit then
            self.spacing = self.spacing -1
        end

    end

    for i = #self.cards, 1, -1 do --The first card is last in the order and vice verca
        local position = self.leftPosition + ((cardWidth + self.spacing) * (i - 1))
        table.insert(result,position)
    end
    return result
end

function hand.testHand(num) --Test function to see if the hand is working
    local result = deck:new()
    for i = 1,num,1 do
        result:addCard(slash:new())
    end
    return result
end

function hand:drawCards(x) --Draw x cards from the deck
    for i = 1,x,1 do
        local card = self.deck:drawACard()
        table.insert(self.cards,card)
    end
    self:updateCardTables()
end

function hand:discardHand() --Put the entire hand into the discard pile
    for i, v in ipairs(self.cards) do
        self.deck.discard(v)
    end
    self.cards = {}
end

function hand:draw() --Draw the cards in the hand
    for i, v in ipairs(self.cards) do
        v:draw()
    end
end

function hand:update(dt) --Update to be used whenever the number of cards in hand changes
    self:selectionBehavior()
    self:moveToIdeal()
end

function hand:moveToIdeal()
    self.wait = false --Cards on screen may have to wait for the card ahead of them to be visible before their behavior kicks in
    local speed = 6
    local outtaTheWay = 0
    if self.spacing < 0 then
        outtaTheWay = -self.spacing --We're gonna move out of the way the same distance that the cards are overlapping    
    end
    
    local selectedIndex = self:getSelectedIndex()

    for i, v in ipairs(self.cards) do
        if not self.wait then
            local idealposx = self.idealPositions[i]
            local idealposy = config.gameh - config.cardHeight
            
            if selectedIndex > -1 then
                if i == selectedIndex then
                    idealposy = idealposy - heightExtension --Move the card up if it is selected
                elseif i < selectedIndex then
                    idealposx = idealposx + outtaTheWay
                else
                    idealposx = idealposx - outtaTheWay
                end
            end

            v.x = self:snapToPlace(v.x,idealposx,speed)
            v.y = self:snapToPlace(v.y,idealposy, speed)

            if v.x < idealposx then --Move towards the goal
                v.x = v.x + speed
            elseif v.x > idealposx then
                v.x = v.x - speed
            end

            if v.y < idealposy then
                v.y = v.y + speed
            elseif v.y > idealposy then
                v.y = v.y - speed
            end
            
            if v.x < 0 then
                self.wait = true --Wait until the card is on the screen before moving the next one
            end

        end
    end
end

function hand:getSelectedIndex()
    for i, v in ipairs(self.cards) do
        if v.selected and v.x == self.idealPositions[i] then
            return i
        end
    end
    return -1
end

function hand:selectionBehavior()
    local X, Y = love.mouse.getPosition()
    local mouseX,mouseY = push:toGame(X,Y)
    
    
    for i, v in ipairs(self.cards) do
        if self.hitboxes[i]:rectangle(mouseX,mouseY) then
            v.selected = true
        else
            v.selected = false
        end
    end
end


function hand:snapToPlace(cardX,idealPos,sensitivity) --If the card is within a certain distance of its ideal position snap it to that position
    local difference = math.abs(cardX - idealPos)
    if difference <= sensitivity then
        return idealPos
    else
        return cardX
    end
end

function hand:updateCardTables() --Run this whenever the number of cards change
    self.idealPositions = self:getIdealPositions()
    self.hitboxes = self:gethitboxes()
end

--TODO. Add functionality to select and then play cards

return hand