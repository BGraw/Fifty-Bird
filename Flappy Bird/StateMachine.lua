-- Brennyn Gray Flappy bird remake

--[[States are only created as needed to save memory, reduce 
    clean up bugs, and increase speed due to garbage collection
    taking longer with more data memory. States are added with 
    string identifier and initialisation function. 
    functions that are expected are init, and when called it
    will return a table with render, update, enter, exit methods.

    gStateMachine = StateMachine {
                    ['MainMenu'] = function()
                        return MainMenu()
                    end,
                    ['InnerGame'] = function()
                        return InnerGame()
                    end,
                    ['GameOver'] = function()
                        return GameOver()
                    end,
    }
    gStateMachine:change("MainGame")

    State identifiers should have the same name as the state
    table, unless there's a good reason not to. i.e. MainMenu
    creates a state using the MainMenu table. This keeps 
    things straight forward.
]]

StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }
    self.states = states or {} --[[name ->  function that returns state]]
    self.current = self.empty
end

function StateMachine:change(stateName, enterParams) --Params are optional
    assert(self.states[stateName]) --state must exist
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterParams) -- params optional
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end
