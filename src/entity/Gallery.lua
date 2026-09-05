local Entity = require 'core.entity'
local page = require 'entity.page'

local gallery = Entity:extend()

local rows = 6
local collumns = 6

function gallery:init(o)
    o = o or {}
    Entity.init(self,o)

    self.cards = o.cards or {}

    table.sort(self.cards,function(a,b)
        return a.title < b.title
    end)

    self.selectedPage = 1
    self.book = {} --Books are made up of pages
end

function gallery:createBook()
    local maxCardsPerPage = rows*collumns
    local numPages = math.ceil(#self.cards/(maxCardsPerPage))
    local counter = 1

    local cardsPerThisPage
    for i = 1, numPages,1 do
        local currentPage = page:new() --Placeholder for before I make this page object
        local cardsLeft = #self.cards + 1 - counter
        if maxCardsPerPage >= (cardsLeft) then
            cardsPerThisPage = cardsLeft    
        else
            cardsPerThisPage = maxCardsPerPage
        end

        for j = 1, cardsPerThisPage, 1 do --Create the page!
            page:addCard(self.cards[counter])
            counter = counter + 1
        end
        table.insert(self.book,page) --Save it to our book
    end
end

function gallery:draw()
    self.book[self.selectedPage]:draw()
end



