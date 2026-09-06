local Entity = require 'core.entity'
local page = require 'entity.page'
local conf = require 'conf'

local gallery = Entity:extend()

local rows
local collumns
rows,collumns = page.getDimensions()

function gallery:init(o)
    o = o or {}
    Entity.init(self,o)

    self.cards = o.cards or {}

    table.sort(self.cards,function(a,b) --sort the cards so the order is lost and so that the number of copies is obvious.
        return a.title < b.title
    end)

    self.selectedPage = 1
    self.book = self:createBook() --Books are made up of pages

    self.leftTurnButton = self:makeLeftRotate()
    self.rightTurnButton = self:makeRightRotate()
end

function gallery:createBook()
    local maxCardsPerPage = rows*collumns
    local numPages = math.ceil(#self.cards/(maxCardsPerPage))
    local counter = 1
    local book = {}

    local cardsPerThisPage
    for i = 1, numPages,1 do
        local cardsLeft = #self.cards + 1 - counter
        if maxCardsPerPage > (cardsLeft) then --If the max cards per page is greater than or equal to the number of cards left then we can just add the remaining cards to this page
            cardsPerThisPage = cardsLeft
        else --Just fill the entire page then
            cardsPerThisPage = maxCardsPerPage
        end
        local cards = {}
        for j = 1, cardsPerThisPage, 1 do --Create the page!
            table.insert(cards,self.cards[counter])
            counter = counter + 1
        end
        local currentPage = page:new({cards = cards})
        table.insert(book,currentPage) --Save it to our book
    end
    return book
end

function gallery:turnPage(left)
    if left then
        self.selectedPage = self.selectedPage - 1
        if self.selectedPage < 1 then
            self.selectedPage = #self.book
        end
    else
        self.selectedPage = self.selectedPage + 1
        if self.selectedPage > #self.book then
            self.selectedPage = 1
        end
    end
end


function gallery:draw()
    self.book[self.selectedPage]:draw()
end

function gallery:makeRightRotate()
    local localW,localH = 16,30
    local localX,localY = conf.windoww - (localW * 2),conf.windowh/2 - localH

    local view = {h = localH, w = localW,x = localX, y = localY}

    local rightRotateButton = pageLeft(self)
    rightRotateButton:draw(view.x,view.y)
    rightRotateButton.view = view
    return rightRotateButton
end

function gallery:makeLeftRotate()
    local localW,localH = 16,30
    local localX,localY = localW*2,conf.windowh/2 - localH
   
    local view = {h = localH, w = localW,x = localX, y = localY}

    local leftRotateButton = pageRight(self)
    leftRotateButton:draw(view.x,view.y)
    leftRotateButton.view = view
    return leftRotateButton
end

return gallery

