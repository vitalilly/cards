local Entity = require 'core.entity'
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
    self.player = o.player or {} --Reference to the player who owns this hand.

    self.leftPosition = o.leftPosition or 0 --Defines the boundaries between the left and right of the hand for empty
    self.spacing = o.spacing or 0
end

function hand:gethitboxes()
    local result = {}
    local heightBuffer = 5 --Extra space ontop of the card that can still detect the mouse
    for i = #self.cards,1,-1 do
        local xDivision =  (((config.gamew - (self.leftPosition * 2))/#self.cards) * (i-1)) + self.leftPosition
        local yDivision = config.gameh - (config.cardHeight + heightExtension + heightBuffer)
        local localWidth = (config.gamew - (self.leftPosition * 2))/#self.cards
        local localHeight = config.cardHeight + heightExtension + heightBuffer
        local hitbox = hitbox:new({x = xDivision, y = yDivision, width = localWidth, height = localHeight})
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
    local X, Y = love.mouse.getPosition()
    local mouseX,mouseY = push:toGame(X,Y)

    self:selectionBehavior(mouseX,mouseY)
    self:moveToIdeal(mouseX,mouseY)
end

function hand:moveToIdeal(mouseX,mouseY)
    self.wait = false --Cards on screen may have to wait for the card ahead of them to be visible before their behavior kicks in
    local speed = 20
    local outtaTheWay = 0
    local leftDown = love.mouse.isDown(1) --left click
    local selectedIndex = self:getSelectedIndex() --The index of the card that has been selected
    local dropBuffer = 50 -- Amount of space above where the card is extended where the card may be dropped without playing it

    if self.spacing < 0 then
        outtaTheWay = -self.spacing --We're gonna move out of the way the same distance that the cards are overlapping    
    end

    for i, v in ipairs(self.cards) do
        if not self.wait then
            local idealposx = self.idealPositions[i]
            local idealposy = config.gameh - config.cardHeight

            if not leftDown and v.grabbed then
                v.grabbed = false
                if mouseY < idealposy - heightExtension - config.cardHeight/2 - dropBuffer then --Playing a card logic
                    if self.player:playCard(v) then
                        table.remove(self.cards,i)
                        self:updateCardTables()
                    end
                end
            end
            
            if selectedIndex > -1 then
                if i == selectedIndex then --Selected and clicked on
                    if leftDown then
                        --idealposx = mouseX - config.cardWidth/2
                        --idealposy = mouseY - config.cardHeight/2
                        v.x = mouseX - config.cardWidth/2
                        v.y = mouseY - config.cardHeight/2
                        v.grabbed = true
                        return
                    else --Selected but not clicked on
                        idealposy = idealposy - heightExtension --Move the card up if it is selected
                    end
                elseif i < selectedIndex then --Remeber that the right most card is at index 1
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
            else
                v.entered = true
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

function hand:getSelectedIndex() --Get the index of the selected card or return -1 if no cards are selected
    for i, v in ipairs(self.cards) do
        if v.selected and v.entered then
            return i
        end
    end
    return -1
end

function hand:selectionBehavior(mouseX,mouseY) --Detect selections
    for _,v in ipairs(self.cards) do
        if v.grabbed then --If any of the cards have been grabbed we gotta skip this
            return
        end
    end

    for i, v in ipairs(self.cards) do
        v.selected = self.hitboxes[i]:rectangle(mouseX,mouseY) --Collision?
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