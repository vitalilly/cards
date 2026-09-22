local Entity = require 'core.entity'
local page = require 'entity.page'
local conf = require 'conf'
local Signal = require 'lib.signal'

local gallery = Entity:extend()

local rows
local collumns
rows,collumns = page.getDimensions()

function gallery:init(o)
    o = o or {}
    Entity.init(self,o)

    self.cards = o.cards or {}
    self.minions = o.minions or false --Whether or not this gallery is for displaying minions

    if next(self.cards) ~= nil then --Incase its empty
        table.sort(self.cards,function(a,b) --sort the cards so the order is lost and so that the number of copies is obvious.
            return a.title < b.title
        end)
        self.book = self:createBook() --Books are made up of pages
    else
        self.book = {[1] = page:new({cards = {}, minions = self.minions})} --If there are no cards then just make a blank page
    end

    self.selectedPage = 1

    self.buttons = {}

    if not self.minions and #self.book > 1 then
         self.buttons = {["leftTurn"] = self:makeLeftRotate(),
    ["rightTurn"] = self:makeRightRotate()}
    end

    self.buttons["exit"] = self:makeExitButton()

    Signal.register("drawGalleryButtons", function() self:drawButtons() end)
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
        local currentPage = page:new({cards = cards, minions = self.minions})
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

    local rightRotateButton = pageRight(self)
    rightRotateButton:draw(view.x,view.y)
    rightRotateButton.view = view
    return rightRotateButton
end

function gallery:makeLeftRotate()
    local localW,localH = 16,30
    local localX,localY = localW*2,conf.windowh/2 - localH
   
    local view = {h = localH, w = localW,x = localX, y = localY}

    local leftRotateButton = pageLeft(self)
    leftRotateButton:draw(view.x,view.y)
    leftRotateButton.view = view
    return leftRotateButton
end

function gallery:makeExitButton()
    local localX,localY = 0,0
    local localW,localH = 200,30

    localX,localY = push:toGame(localX,localY)
    localW,localH = push:toGame(localW,localH)
    local view = {h = localH, w = localW,x = localX, y = localY}

    local exitButton = exitGallery(self,view.w,view.h)
    exitButton:draw(view.x,view.y)
    exitButton.view = view
    return exitButton

end

function gallery:drawButtons()
    for _,v in pairs(self.buttons) do
        v:draw(v.view.x,v.view.y)
    end
end

function gallery:undrawButtons()
    for _,v in pairs(self.buttons) do
        v:undraw()
    end
end

return gallery

